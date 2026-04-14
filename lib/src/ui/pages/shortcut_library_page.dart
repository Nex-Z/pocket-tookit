import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/api_models.dart';
import '../../providers.dart';
import '../../services/shortcut_execution_service.dart';
import '../widgets/app_chrome.dart';

class ShortcutLibraryPage extends ConsumerStatefulWidget {
  const ShortcutLibraryPage({super.key});

  @override
  ConsumerState<ShortcutLibraryPage> createState() =>
      _ShortcutLibraryPageState();
}

class _ShortcutLibraryPageState extends ConsumerState<ShortcutLibraryPage> {
  int? _runningShortcutId;

  @override
  Widget build(BuildContext context) {
    final shortcuts = ref.watch(shortcutsProvider);
    return CupertinoPageScaffold(
      backgroundColor: appBackground,
      navigationBar: CupertinoNavigationBar(
        middle: const Text('指令库'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: const Size.square(32),
              onPressed: () => context.push('/logs'),
              child: const Icon(CupertinoIcons.doc_text_search),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: const Size.square(32),
              onPressed: () => context.push('/shortcut/new'),
              child: const Icon(CupertinoIcons.add_circled_solid),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: shortcuts.when(
          data: (items) {
            if (items.isEmpty) {
              return _EmptyLibrary(
                onCreate: () => context.push('/shortcut/new'),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
              itemBuilder: (context, index) {
                final shortcut = items[index];
                return _ShortcutTile(
                  shortcut: shortcut,
                  running: _runningShortcutId == shortcut.id,
                  onOpen: () => context.push('/shortcut/${shortcut.id}'),
                  onRun: () => _runShortcut(shortcut),
                  onDelete: () => _deleteShortcut(shortcut),
                );
              },
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemCount: items.length,
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (error, _) => Center(child: Text('加载失败：$error')),
        ),
      ),
    );
  }

  Future<void> _runShortcut(ApiShortcut shortcut) async {
    final id = shortcut.id;
    if (id == null || _runningShortcutId != null) {
      return;
    }
    setState(() => _runningShortcutId = id);
    try {
      final repository = ref.read(shortcutRepositoryProvider);
      final fullShortcut = await repository.getShortcut(id);
      if (!mounted || fullShortcut == null) {
        return;
      }
      if (fullShortcut.steps.isEmpty) {
        await _showMessage('这个指令还没有请求步骤');
        return;
      }
      final result = await ref
          .read(shortcutExecutionServiceProvider)
          .execute(fullShortcut);
      if (!mounted) {
        return;
      }
      await showCupertinoModalPopup<void>(
        context: context,
        builder: (context) => _ExecutionSheet(result: result),
      );
    } catch (error) {
      if (mounted) {
        await _showMessage('执行失败：$error');
      }
    } finally {
      if (mounted) {
        setState(() => _runningShortcutId = null);
      }
    }
  }

  Future<void> _deleteShortcut(ApiShortcut shortcut) async {
    final id = shortcut.id;
    if (id == null) {
      return;
    }
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('删除「${shortcut.name}」？'),
        content: const Text('相关请求日志也会一并删除。'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(shortcutRepositoryProvider).deleteShortcut(id);
    }
  }

  Future<void> _showMessage(String message) {
    return showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }
}

class _EmptyLibrary extends StatelessWidget {
  const _EmptyLibrary({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              CupertinoIcons.bolt_fill,
              size: 54,
              color: Color(0xFFFF9F0A),
            ),
            const SizedBox(height: 18),
            const Text(
              '把常用 API 做成指令',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: appText,
                fontSize: 23,
                fontWeight: FontWeight.w800,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '按步骤填写请求，执行时自动串起上一步响应。',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: appMutedText,
                fontSize: 15,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: '新建指令',
              icon: CupertinoIcons.add,
              onPressed: onCreate,
            ),
          ],
        ),
      ),
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  const _ShortcutTile({
    required this.shortcut,
    required this.running,
    required this.onOpen,
    required this.onRun,
    required this.onDelete,
  });

  final ApiShortcut shortcut;
  final bool running;
  final VoidCallback onOpen;
  final VoidCallback onRun;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final color = shortcutColor(shortcut);
    return PlainPanel(
      padding: EdgeInsets.zero,
      child: CupertinoContextMenu(
        actions: [
          CupertinoContextMenuAction(
            onPressed: () {
              Navigator.of(context).pop();
              onOpen();
            },
            child: const Text('编辑'),
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
          onPressed: onOpen,
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const SizedBox(
                  width: 46,
                  height: 46,
                  child: Icon(
                    CupertinoIcons.bolt_fill,
                    color: CupertinoColors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shortcut.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: appText,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      shortcut.description.isEmpty
                          ? '轻点编辑请求步骤'
                          : shortcut.description,
                      maxLines: 2,
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
              const SizedBox(width: 10),
              CupertinoButton(
                padding: EdgeInsets.zero,
                minimumSize: const Size.square(36),
                onPressed: running ? null : onRun,
                child: running
                    ? const CupertinoActivityIndicator()
                    : const Icon(CupertinoIcons.play_circle_fill, size: 32),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExecutionSheet extends StatelessWidget {
  const _ExecutionSheet({required this.result});

  final ShortcutExecutionResult result;

  @override
  Widget build(BuildContext context) {
    final title = result.success ? '执行完成' : '执行中断';
    return CupertinoPopupSurface(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.82,
        child: CupertinoPageScaffold(
          backgroundColor: CupertinoColors.systemBackground,
          navigationBar: CupertinoNavigationBar(
            middle: Text(title),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('完成'),
            ),
          ),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              children: [
                PlainPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.shortcut.name,
                        style: const TextStyle(
                          color: appText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        result.error ?? '所有步骤已按顺序完成。',
                        style: const TextStyle(
                          color: appMutedText,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                for (final stepResult in result.results) ...[
                  _StepResultTile(result: stepResult),
                  const SizedBox(height: 10),
                ],
                AppSection(
                  title: '变量上下文',
                  child: PlainPanel(
                    child: Text(
                      const JsonEncoder.withIndent('  ').convert(
                        result.context.steps.map(
                          (key, value) => MapEntry(key, {
                            'status': value.status,
                            'headers': value.headers,
                            'body': value.body,
                          }),
                        ),
                      ),
                      style: const TextStyle(
                        color: appText,
                        fontSize: 12,
                        fontFamily: 'monospace',
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepResultTile extends StatelessWidget {
  const _StepResultTile({required this.result});

  final StepExecutionResult result;

  @override
  Widget build(BuildContext context) {
    return PlainPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  result.step.name,
                  style: const TextStyle(
                    color: appText,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                  ),
                ),
              ),
              StatusPill(
                success: result.success,
                statusCode: result.log.statusCode,
              ),
            ],
          ),
          const SizedBox(height: 8),
          KeyValueText(label: '方法', value: result.log.method),
          KeyValueText(label: '地址', value: result.log.url),
          KeyValueText(label: '耗时', value: '${result.log.durationMs} ms'),
          if ((result.error ?? result.log.error ?? '').isNotEmpty)
            KeyValueText(
              label: '错误',
              value: result.error ?? result.log.error ?? '',
            ),
          const SizedBox(height: 8),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            minimumSize: Size.zero,
            color: const Color(0xFFEFF4FF),
            borderRadius: BorderRadius.circular(8),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: result.log.responseBody));
            },
            child: const Text('复制响应', style: TextStyle(letterSpacing: 0)),
          ),
        ],
      ),
    );
  }
}
