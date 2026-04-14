import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _defaultServerUrl = 'http://your-server:8080';
const _serverUrlKey = 'server_url';

void main() {
  runApp(const ClockInApp());
}

class ClockInApp extends StatelessWidget {
  const ClockInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '打卡',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ClockInPage(),
    );
  }
}

class ClockInPage extends StatefulWidget {
  const ClockInPage({super.key});

  @override
  State<ClockInPage> createState() => _ClockInPageState();
}

class _ClockInPageState extends State<ClockInPage> {
  final _serverController = TextEditingController(text: _defaultServerUrl);
  final _tokenController = TextEditingController();
  final _dio = Dio();

  bool _isLoading = false;
  bool _isClockIn = true;
  bool? _isSuccess;
  String _resultText = '暂无打卡结果';

  @override
  void initState() {
    super.initState();
    _loadServerUrl();
  }

  @override
  void dispose() {
    _serverController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _loadServerUrl() async {
    // 启动时读取上次保存的服务器地址，没有保存时使用默认地址。
    final prefs = await SharedPreferences.getInstance();
    final savedUrl = prefs.getString(_serverUrlKey);
    if (!mounted || savedUrl == null || savedUrl.isEmpty) {
      return;
    }
    _serverController.text = savedUrl;
  }

  Future<void> _saveServerUrl(String value) async {
    // 地址输入变化后即时保存，方便下次打开直接使用。
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_serverUrlKey, value.trim());
  }

  Future<void> _pasteToken() async {
    // 从剪贴板读取 token，减少手动输入长文本的麻烦。
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    if (text == null || text.isEmpty) {
      return;
    }
    _tokenController.text = text;
  }

  Future<void> _clockIn() async {
    final serverUrl = _serverController.text.trim();
    final token = _tokenController.text.trim();

    if (serverUrl.isEmpty || token.isEmpty) {
      setState(() {
        _isSuccess = false;
        _resultText = '请填写服务器地址和 token';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _isSuccess = null;
      _resultText = '正在打卡...';
    });

    await _saveServerUrl(serverUrl);

    try {
      // 后端同时接收 clock_in 和 type，用于区分上班卡、下班卡。
      final response = await _dio.post<dynamic>(
        _buildClockInUrl(serverUrl),
        data: {
          'token': token,
          'clock_in': _isClockIn,
          'type': _isClockIn ? 'up' : 'down',
        },
        options: Options(validateStatus: (_) => true),
      );
      final statusCode = response.statusCode;
      final success =
          statusCode != null && statusCode >= 200 && statusCode < 300;

      setState(() {
        _isSuccess = success;
        _resultText = 'HTTP ${statusCode ?? '-'}\n${response.data}';
      });
    } on DioException catch (error) {
      setState(() {
        _isSuccess = false;
        _resultText = error.message ?? '网络请求失败';
      });
    } catch (error) {
      setState(() {
        _isSuccess = false;
        _resultText = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _buildClockInUrl(String serverUrl) {
    // 兼容用户输入末尾带斜杠的服务器地址。
    final normalizedUrl = serverUrl.endsWith('/')
        ? serverUrl.substring(0, serverUrl.length - 1)
        : serverUrl;
    return '$normalizedUrl/api/v1/clockIn';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final resultColor = switch (_isSuccess) {
      true => Colors.green,
      false => colorScheme.error,
      null => colorScheme.onSurfaceVariant,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('打卡')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              controller: _serverController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '服务器地址',
                hintText: _defaultServerUrl,
              ),
              keyboardType: TextInputType.url,
              onChanged: _saveServerUrl,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tokenController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'token',
                suffixIcon: IconButton(
                  tooltip: '从剪贴板粘贴',
                  onPressed: _pasteToken,
                  icon: const Icon(Icons.content_paste),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: true,
                  label: Text('上班卡'),
                  icon: Icon(Icons.work_outline),
                ),
                ButtonSegment(
                  value: false,
                  label: Text('下班卡'),
                  icon: Icon(Icons.home_outlined),
                ),
              ],
              selected: {_isClockIn},
              onSelectionChanged: _isLoading
                  ? null
                  : (values) {
                      setState(() {
                        _isClockIn = values.first;
                      });
                    },
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _isLoading ? null : _clockIn,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: _isLoading
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('打卡'),
            ),
            const SizedBox(height: 16),
            Text('结果', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            DecoratedBox(
              decoration: BoxDecoration(
                color: resultColor.withValues(alpha: 0.08),
                border: Border.all(color: resultColor.withValues(alpha: 0.55)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SelectableText(
                  _resultText,
                  style: TextStyle(color: resultColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
