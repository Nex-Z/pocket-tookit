import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/api_models.dart';
import '../../providers.dart';
import '../widgets/app_chrome.dart';

enum LogFilter { all, success, failed }

class RequestLogsPage extends ConsumerStatefulWidget {
  const RequestLogsPage({super.key});

  @override
  ConsumerState<RequestLogsPage> createState() => _RequestLogsPageState();
}

class _RequestLogsPageState extends ConsumerState<RequestLogsPage> {
  final _searchController = TextEditingController();
  LogFilter _filter = LogFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logs = ref.watch(requestLogsProvider);
    return CupertinoPageScaffold(
      backgroundColor: appBackground,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('请求日志'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          minimumSize: const Size.square(32),
          onPressed: _clearLogs,
          child: const Text('清空'),
        ),
      ),
      child: SafeArea(
        child: logs.when(
          data: (items) {
            final filtered = _applyFilter(items);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: CupertinoSearchTextField(
                    controller: _searchController,
                    placeholder: '搜索 URL、步骤、方法',
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CupertinoSlidingSegmentedControl<LogFilter>(
                    groupValue: _filter,
                    children: const {
                      LogFilter.all: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('全部'),
                      ),
                      LogFilter.success: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('成功'),
                      ),
                      LogFilter.failed: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('失败'),
                      ),
                    },
                    onValueChanged: (value) {
                      if (value != null) {
                        setState(() => _filter = value);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: filtered.isEmpty
                      ? const Center(
                          child: Text(
                            '还没有匹配的日志',
                            style: TextStyle(
                              color: appMutedText,
                              letterSpacing: 0,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                          itemBuilder: (context, index) => _LogTile(
                            log: filtered[index],
                            onTap: () =>
                                context.push('/logs/${filtered[index].id}'),
                            onDelete: () => _deleteLog(filtered[index]),
                          ),
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                          itemCount: filtered.length,
                        ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (error, _) => Center(child: Text('加载失败：$error')),
        ),
      ),
    );
  }

  List<RequestLogEntry> _applyFilter(List<RequestLogEntry> items) {
    final keyword = _searchController.text.trim().toLowerCase();
    return items.where((log) {
      final statusMatch = switch (_filter) {
        LogFilter.all => true,
        LogFilter.success => log.success,
        LogFilter.failed => !log.success,
      };
      if (!statusMatch) {
        return false;
      }
      if (keyword.isEmpty) {
        return true;
      }
      final haystack = [
        log.url,
        log.method,
        log.stepName,
        log.stepKey,
        log.statusCode?.toString() ?? '',
        log.error ?? '',
      ].join(' ').toLowerCase();
      return haystack.contains(keyword);
    }).toList();
  }

  Future<void> _deleteLog(RequestLogEntry log) async {
    await ref.read(shortcutRepositoryProvider).deleteLog(log.id);
  }

  Future<void> _clearLogs() async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('清空请求日志？'),
        content: const Text('指令本身不会被删除。'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('清空'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(shortcutRepositoryProvider).clearLogs();
    }
  }
}

class _LogTile extends StatelessWidget {
  const _LogTile({
    required this.log,
    required this.onTap,
    required this.onDelete,
  });

  final RequestLogEntry log;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PlainPanel(
      padding: EdgeInsets.zero,
      child: CupertinoContextMenu(
        actions: [
          CupertinoContextMenuAction(
            onPressed: () {
              Navigator.of(context).pop();
              onTap();
            },
            child: const Text('查看详情'),
          ),
          CupertinoContextMenuAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop();
              onDelete();
            },
            child: const Text('删除'),
          ),
        ],
        child: CupertinoButton(
          padding: const EdgeInsets.all(14),
          minimumSize: Size.zero,
          onPressed: onTap,
          child: Row(
            children: [
              StatusPill(success: log.success, statusCode: log.statusCode),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${log.method}  ${log.stepName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: appText,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      log.url,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: appMutedText,
                        fontSize: 13,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${log.durationMs} ms',
                style: const TextStyle(
                  color: appMutedText,
                  fontSize: 12,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
