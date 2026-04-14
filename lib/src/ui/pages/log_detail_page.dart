import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/api_models.dart';
import '../../providers.dart';
import '../widgets/app_chrome.dart';

class LogDetailPage extends ConsumerWidget {
  const LogDetailPage({super.key, required this.logId});

  final int? logId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (logId == null) {
      return const CupertinoPageScaffold(child: Center(child: Text('日志不存在')));
    }
    final log = ref.watch(requestLogProvider(logId!));
    return CupertinoPageScaffold(
      backgroundColor: appBackground,
      navigationBar: const CupertinoNavigationBar(middle: Text('日志详情')),
      child: SafeArea(
        child: log.when(
          data: (entry) {
            if (entry == null) {
              return const Center(child: Text('日志不存在'));
            }
            return _LogDetail(log: entry);
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (error, _) => Center(child: Text('加载失败：$error')),
        ),
      ),
    );
  }
}

class _LogDetail extends StatefulWidget {
  const _LogDetail({required this.log});

  final RequestLogEntry log;

  @override
  State<_LogDetail> createState() => _LogDetailState();
}

class _LogDetailState extends State<_LogDetail> {
  final _searchController = TextEditingController();
  String _keyword = '';

  RequestLogEntry get log => widget.log;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 28),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: CupertinoSearchTextField(
            controller: _searchController,
            placeholder: '搜索请求或响应内容',
            onChanged: (value) => setState(() => _keyword = value),
          ),
        ),
        AppSection(
          title: '摘要',
          child: PlainPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        log.stepName,
                        style: const TextStyle(
                          color: appText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    StatusPill(
                      success: log.success,
                      statusCode: log.statusCode,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                KeyValueText(label: '方法', value: log.method),
                KeyValueText(label: '地址', value: log.url),
                KeyValueText(label: '耗时', value: '${log.durationMs} ms'),
                KeyValueText(
                  label: '时间',
                  value: log.createdAt.toLocal().toString(),
                ),
                if ((log.error ?? '').isNotEmpty)
                  KeyValueText(label: '错误', value: log.error!),
              ],
            ),
          ),
        ),
        _TextBlock(
          title: '请求头',
          value: _prettyMap(log.requestHeaders),
          query: _keyword,
        ),
        _BodyBlock(title: '请求体', value: log.requestBody, query: _keyword),
        _TextBlock(
          title: '响应头',
          value: _prettyMap(log.responseHeaders),
          query: _keyword,
        ),
        _BodyBlock(
          title: log.responseTruncated ? '响应体（已截断）' : '响应体',
          value: log.responseBody,
          query: _keyword,
        ),
      ],
    );
  }

  String _prettyMap(Map<String, String> map) {
    if (map.isEmpty) {
      return '';
    }
    return const JsonEncoder.withIndent('  ').convert(map);
  }
}

enum _BodyDisplayMode { formatted, raw }

class _BodyBlock extends StatefulWidget {
  const _BodyBlock({
    required this.title,
    required this.value,
    required this.query,
  });

  final String title;
  final String value;
  final String query;

  @override
  State<_BodyBlock> createState() => _BodyBlockState();
}

class _BodyBlockState extends State<_BodyBlock> {
  _BodyDisplayMode _mode = _BodyDisplayMode.formatted;

  @override
  Widget build(BuildContext context) {
    final formatted = _prettyJson(widget.value);
    final canFormat = formatted != null && formatted != widget.value;
    final displayValue = canFormat && _mode == _BodyDisplayMode.formatted
        ? formatted
        : widget.value;

    return _TextBlock(
      title: widget.title,
      value: displayValue,
      query: widget.query,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (canFormat) ...[
            SizedBox(
              width: 122,
              child: CupertinoSlidingSegmentedControl<_BodyDisplayMode>(
                groupValue: _mode,
                backgroundColor: const Color(0xFFEFF1F5),
                thumbColor: CupertinoColors.systemBackground.resolveFrom(
                  context,
                ),
                children: const {
                  _BodyDisplayMode.formatted: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Text('格式化'),
                  ),
                  _BodyDisplayMode.raw: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Text('原始'),
                  ),
                },
                onValueChanged: (value) {
                  if (value != null) {
                    setState(() => _mode = value);
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
          ],
          CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: const Size.square(28),
            onPressed: () =>
                Clipboard.setData(ClipboardData(text: displayValue)),
            child: const Text('复制'),
          ),
        ],
      ),
    );
  }
}

class _TextBlock extends StatelessWidget {
  const _TextBlock({
    required this.title,
    required this.value,
    required this.query,
    this.trailing,
  });

  final String title;
  final String value;
  final String query;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppSection(
      title: title,
      trailing:
          trailing ??
          CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: const Size.square(28),
            onPressed: () => Clipboard.setData(ClipboardData(text: value)),
            child: const Text('复制'),
          ),
      child: PlainPanel(
        child: SizedBox(
          width: double.infinity,
          child: _HighlightedMonoText(value: value, query: query),
        ),
      ),
    );
  }
}

class _HighlightedMonoText extends StatelessWidget {
  const _HighlightedMonoText({required this.value, required this.query});

  final String value;
  final String query;

  @override
  Widget build(BuildContext context) {
    final text = value.isEmpty ? '-' : value;
    final trimmedQuery = query.trim();
    final baseStyle = const TextStyle(
      color: appText,
      fontSize: 12,
      fontFamily: 'monospace',
      letterSpacing: 0,
    );
    if (trimmedQuery.isEmpty) {
      return Text(text, style: baseStyle);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = trimmedQuery.toLowerCase();
    final spans = <TextSpan>[];
    var start = 0;
    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index < 0) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      spans.add(
        TextSpan(
          text: text.substring(index, index + trimmedQuery.length),
          style: const TextStyle(
            color: appText,
            backgroundColor: Color(0xFFFFE58A),
            fontWeight: FontWeight.w700,
          ),
        ),
      );
      start = index + trimmedQuery.length;
    }
    return RichText(
      text: TextSpan(style: baseStyle, children: spans),
    );
  }
}

String? _prettyJson(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  try {
    return const JsonEncoder.withIndent('  ').convert(jsonDecode(trimmed));
  } catch (_) {
    return null;
  }
}
