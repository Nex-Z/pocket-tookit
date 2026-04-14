import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/api_models.dart';
import '../../providers.dart';
import '../../services/shortcut_execution_service.dart';
import '../../services/template_resolver.dart';
import '../widgets/app_chrome.dart';

enum _EditorMenuAction { importCurl, exportJson }

class ShortcutEditorPage extends ConsumerStatefulWidget {
  const ShortcutEditorPage({super.key, this.shortcutId});

  final int? shortcutId;

  @override
  ConsumerState<ShortcutEditorPage> createState() => _ShortcutEditorPageState();
}

class _ShortcutEditorPageState extends ConsumerState<ShortcutEditorPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _scrollController = ScrollController();
  final _steps = <EditableStep>[];
  bool _loading = true;
  bool _saving = false;
  bool _saveHintVisible = false;
  int? _debuggingStepIndex;
  int? _shortcutId;
  Timer? _saveHintTimer;
  int _activeStepIndex = 0;
  int _color = defaultShortcutColor;
  DateTime? _createdAt;

  @override
  void initState() {
    super.initState();
    _shortcutId = widget.shortcutId;
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    _saveHintTimer?.cancel();
    for (final step in _steps) {
      step.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    final id = _shortcutId;
    final shortcut = id == null
        ? ApiShortcut.draft().copyWith(color: _randomShortcutColor())
        : await ref.read(shortcutRepositoryProvider).getShortcut(id);
    if (!mounted) {
      return;
    }
    final loaded = shortcut ?? ApiShortcut.draft();
    _nameController.text = loaded.name;
    _descriptionController.text = loaded.description;
    _color = loaded.color;
    _createdAt = loaded.createdAt;
    _steps
      ..clear()
      ..addAll(
        (loaded.steps.isEmpty
                ? [RequestStep.draft(sortOrder: 0)]
                : loaded.steps)
            .map(EditableStep.fromStep),
      );
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: appBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text(_shortcutId == null ? '新建指令' : '编辑指令'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: const Size.square(32),
              onPressed: _loading || _saving ? null : () => _save(),
              child: Text(
                _saving ? '保存中' : (_saveHintVisible ? '已保存' : '保存'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              minimumSize: const Size.square(32),
              onPressed: _loading || _saving ? null : _openEditorMenu,
              child: const Icon(CupertinoIcons.ellipsis_circle, size: 25),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: _loading
            ? const Center(child: CupertinoActivityIndicator())
            : ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(0, 14, 0, 28),
                children: [
                  AppSection(
                    title: '基础信息',
                    child: PlainPanel(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                      borderColor: appLine.withValues(alpha: 0.65),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabeledField(
                            label: '名称',
                            controller: _nameController,
                          ),
                          const SizedBox(height: 12),
                          LabeledField(
                            label: '描述',
                            controller: _descriptionController,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppSection(
                    title: '请求步骤',
                    trailing: CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size.square(28),
                      onPressed: _addStep,
                      child: const Text('添加'),
                    ),
                    child: Column(
                      children: [
                        for (final entry in _steps.indexed) ...[
                          StepEditorPanel(
                            index: entry.$1,
                            step: entry.$2,
                            active: entry.$1 == _activeStepIndex,
                            onTap: () =>
                                setState(() => _activeStepIndex = entry.$1),
                            onRemove: _steps.length == 1
                                ? null
                                : () => _removeStep(entry.$1),
                            onDebug: () => _debugStep(entry.$1),
                            debugging: _debuggingStepIndex == entry.$1,
                            onChanged: () => setState(() {}),
                          ),
                          const SizedBox(height: 14),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _addStep() {
    setState(() {
      _steps.add(
        EditableStep.fromStep(RequestStep.draft(sortOrder: _steps.length)),
      );
      _activeStepIndex = _steps.length - 1;
    });
  }

  void _removeStep(int index) {
    setState(() {
      final removed = _steps.removeAt(index);
      removed.dispose();
      if (_activeStepIndex >= _steps.length) {
        _activeStepIndex = _steps.length - 1;
      }
    });
  }

  Future<void> _openEditorMenu() async {
    final action = await showCupertinoModalPopup<_EditorMenuAction>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () =>
                Navigator.of(context).pop(_EditorMenuAction.importCurl),
            child: const Text('导入'),
          ),
          CupertinoActionSheetAction(
            onPressed: () =>
                Navigator.of(context).pop(_EditorMenuAction.exportJson),
            child: const Text('导出'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
      ),
    );
    if (!mounted || action == null) {
      return;
    }
    switch (action) {
      case _EditorMenuAction.importCurl:
        await _importCurl();
      case _EditorMenuAction.exportJson:
        await _exportJson();
    }
  }

  Future<void> _exportJson() async {
    final json = const JsonEncoder.withIndent('  ').convert({
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'color': _color,
      'steps': [
        for (final entry in _steps.indexed)
          {
            'key': entry.$2.keyController.text.trim(),
            'name': entry.$2.nameController.text.trim(),
            'sortOrder': entry.$1,
            'request': entry.$2.toStep(sortOrder: entry.$1).request.toJson(),
          },
      ],
    });
    await Clipboard.setData(ClipboardData(text: json));
    if (mounted) {
      await _showMessage('已复制指令 JSON');
    }
  }

  Future<int?> _save({
    bool showMessage = true,
    bool navigate = true,
    bool validateAllSteps = false,
    int? validateStepIndex,
  }) async {
    final trimmedName = _nameController.text.trim();
    final name = trimmedName.isEmpty ? '未命名指令' : trimmedName;
    for (final entry in _steps.indexed) {
      if (!validateAllSteps && entry.$1 != validateStepIndex) {
        continue;
      }
      final step = entry.$2;
      if (step.urlController.text.trim().isEmpty) {
        final stepName = step.nameController.text.trim().isEmpty
            ? '请求 ${entry.$1 + 1}'
            : step.nameController.text.trim();
        await _showMessage('请填写 $stepName 的 URL');
        return null;
      }
    }

    setState(() => _saving = true);
    try {
      final now = DateTime.now();
      final shortcut = ApiShortcut(
        id: _shortcutId,
        name: name,
        description: _descriptionController.text.trim(),
        color: _color,
        createdAt: _createdAt ?? now,
        updatedAt: now,
        steps: [
          for (final entry in _steps.indexed)
            entry.$2.toStep(sortOrder: entry.$1),
        ],
      );
      final id = await ref
          .read(shortcutRepositoryProvider)
          .saveShortcut(shortcut);
      if (!mounted) {
        return null;
      }
      _shortcutId = id;
      ref.invalidate(shortcutsProvider);
      if (showMessage) {
        _showSavedHint();
      }
      if (navigate) {
        context.go('/shortcut/$id');
      }
      return id;
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  void _showSavedHint() {
    _saveHintTimer?.cancel();
    if (mounted) {
      setState(() => _saveHintVisible = true);
    }
    _saveHintTimer = Timer(const Duration(milliseconds: 1300), () {
      if (mounted) {
        setState(() => _saveHintVisible = false);
      }
    });
  }

  Future<void> _debugStep(int index) async {
    if (_debuggingStepIndex != null || index >= _steps.length) {
      return;
    }
    setState(() => _debuggingStepIndex = index);
    try {
      final shortcutId = await _save(
        showMessage: false,
        navigate: false,
        validateAllSteps: false,
        validateStepIndex: index,
      );
      if (!mounted || shortcutId == null) {
        return;
      }
      final shortcut = await ref
          .read(shortcutRepositoryProvider)
          .getShortcut(shortcutId);
      if (!mounted || shortcut == null || index >= shortcut.steps.length) {
        return;
      }
      final step = shortcut.steps[index];
      var debugContext = const TemplateContext();
      final variables = _templateExpressionsForStep(step).toList();
      if (variables.isNotEmpty) {
        final values = await showCupertinoModalPopup<Map<String, String>>(
          context: context,
          builder: (context) => DebugVariableSheet(variables: variables),
        );
        if (!mounted || values == null) {
          return;
        }
        debugContext = TemplateContext(variables: values);
      }
      final result = await ref
          .read(shortcutExecutionServiceProvider)
          .executeStep(shortcut, step, initialContext: debugContext);
      if (!mounted) {
        return;
      }
      await showCupertinoModalPopup<void>(
        context: context,
        builder: (context) => _SingleStepDebugSheet(result: result),
      );
    } catch (error) {
      if (mounted) {
        await _showMessage('调试失败：$error');
      }
    } finally {
      if (mounted) {
        setState(() => _debuggingStepIndex = null);
      }
    }
  }

  Future<void> _importCurl() async {
    final controller = TextEditingController();
    final imported = await showCupertinoModalPopup<RequestStep>(
      context: context,
      builder: (context) => CurlImportSheet(
        controller: controller,
        targetName: _steps.isEmpty
            ? '新步骤'
            : _steps[_activeStepIndex].nameController.text,
        onImport: (text) async {
          try {
            final result = ref
                .read(curlImportServiceProvider)
                .parse(text, sortOrder: _activeStepIndex);
            if (result.warnings.isNotEmpty) {
              await showCupertinoDialog<void>(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text('导入提示'),
                  content: Text(result.warnings.join('\n')),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('继续'),
                    ),
                  ],
                ),
              );
            }
            if (context.mounted) {
              Navigator.of(context).pop(result.step);
            }
          } catch (error) {
            if (!context.mounted) {
              return;
            }
            await showCupertinoDialog<void>(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: const Text('无法解析 curl'),
                content: Text(error.toString()),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('知道了'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
    controller.dispose();
    if (imported == null || !mounted) {
      return;
    }
    setState(() {
      final replacement = EditableStep.fromStep(imported);
      if (_steps.isEmpty) {
        _steps.add(replacement);
        _activeStepIndex = 0;
      } else {
        final old = _steps[_activeStepIndex];
        _steps[_activeStepIndex] = replacement;
        old.dispose();
      }
    });
  }

  Future<void> _showMessage(String message) {
    return showCupertinoDialog<void>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('好'),
          ),
        ],
      ),
    );
  }
}

class StepEditorPanel extends StatelessWidget {
  const StepEditorPanel({
    super.key,
    required this.index,
    required this.step,
    required this.active,
    required this.onTap,
    required this.onDebug,
    required this.debugging,
    required this.onChanged,
    this.onRemove,
  });

  final int index;
  final EditableStep step;
  final bool active;
  final VoidCallback onTap;
  final VoidCallback onDebug;
  final bool debugging;
  final VoidCallback onChanged;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: PlainPanel(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        borderColor: active
            ? const Color(0xFF007AFF).withValues(alpha: 0.55)
            : appLine.withValues(alpha: 0.65),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xFF007AFF)
                        : const Color(0xFFEFF1F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SizedBox(
                    width: 34,
                    height: 34,
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: active
                              ? CupertinoColors.white
                              : const Color(0xFF4B5563),
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        active ? '当前步骤' : '请求步骤',
                        style: TextStyle(
                          color: active ? const Color(0xFF007AFF) : appText,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${step.method} · ${step.keyController.text.trim().isEmpty ? 'step${index + 1}' : step.keyController.text.trim()}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: appMutedText,
                          fontSize: 12,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: const Size.square(30),
                  onPressed: debugging ? null : onDebug,
                  child: debugging
                      ? const CupertinoActivityIndicator(radius: 8)
                      : const Text(
                          '调试',
                          style: TextStyle(
                            color: Color(0xFF007AFF),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0,
                          ),
                        ),
                ),
                if (onRemove != null)
                  CupertinoButton(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size.square(30),
                    onPressed: onRemove,
                    child: const Text(
                      '删除',
                      style: TextStyle(
                        color: Color(0xFFFF3B30),
                        fontSize: 14,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            LabeledField(label: '步骤名', controller: step.nameController),
            const SizedBox(height: 14),
            LabeledField(label: '变量名', controller: step.keyController),
            const SizedBox(height: 14),
            _MethodPicker(
              value: step.method,
              onChanged: (value) {
                step.method = value;
                onChanged();
              },
            ),
            const SizedBox(height: 14),
            LabeledField(
              label: 'URL',
              controller: step.urlController,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 14),
            KeyValueEditor(
              label: 'Query',
              pairs: step.queryPairs,
              keyPlaceholder: 'page',
              valuePlaceholder: '1',
              emptyText: '未添加参数',
              onChanged: onChanged,
            ),
            const SizedBox(height: 14),
            KeyValueEditor(
              label: 'Headers',
              pairs: step.headerPairs,
              keyPlaceholder: 'Accept',
              valuePlaceholder: 'application/json',
              emptyText: '未添加请求头',
              onChanged: onChanged,
            ),
            const SizedBox(height: 16),
            _BodyEditor(step: step, onChanged: onChanged),
            const SizedBox(height: 14),
            LabeledField(
              label: '超时秒数',
              controller: step.timeoutController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodPicker extends StatelessWidget {
  const _MethodPicker({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const methods = ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'HEAD'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: CupertinoSlidingSegmentedControl<String>(
        groupValue: value,
        thumbColor: CupertinoColors.systemBackground.resolveFrom(context),
        backgroundColor: const Color(0xFFEFF1F5),
        children: {
          for (final method in methods)
            method: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                method,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
        },
        onValueChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }
}

class _BodyEditor extends StatelessWidget {
  const _BodyEditor({required this.step, required this.onChanged});

  final EditableStep step;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FieldLabel('请求体'),
        const SizedBox(height: 7),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: CupertinoSlidingSegmentedControl<BodyType>(
            groupValue: step.bodyType,
            thumbColor: CupertinoColors.systemBackground.resolveFrom(context),
            backgroundColor: const Color(0xFFEFF1F5),
            children: {
              for (final type in BodyType.values)
                type: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(bodyTypeLabel(type)),
                ),
            },
            onValueChanged: (value) {
              if (value != null) {
                step.bodyType = value;
                onChanged();
              }
            },
          ),
        ),
        if (step.bodyType == BodyType.json ||
            step.bodyType == BodyType.text) ...[
          const SizedBox(height: 10),
          LabeledField(
            label: step.bodyType == BodyType.json ? 'JSON' : '文本',
            controller: step.bodyRawController,
            maxLines: 6,
            placeholder: step.bodyType == BodyType.json
                ? '{"token":"..."}'
                : '请求正文',
          ),
        ],
        if (step.bodyType == BodyType.formUrlEncoded ||
            step.bodyType == BodyType.formData) ...[
          const SizedBox(height: 10),
          KeyValueEditor(
            label: '字段',
            pairs: step.bodyFieldPairs,
            keyPlaceholder: 'name',
            valuePlaceholder: '{{steps.step1.body.page}}',
            emptyText: '未添加字段',
            onChanged: onChanged,
          ),
        ],
      ],
    );
  }
}

class CurlImportSheet extends StatelessWidget {
  const CurlImportSheet({
    super.key,
    required this.controller,
    required this.targetName,
    required this.onImport,
  });

  final TextEditingController controller;
  final String targetName;
  final ValueChanged<String> onImport;

  @override
  Widget build(BuildContext context) {
    return CupertinoPopupSurface(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: CupertinoPageScaffold(
          backgroundColor: CupertinoColors.systemBackground,
          navigationBar: CupertinoNavigationBar(
            middle: Text('导入到 $targetName'),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '粘贴 curl 命令',
                    style: TextStyle(
                      color: appText,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: CupertinoTextField(
                      controller: controller,
                      expands: true,
                      maxLines: null,
                      minLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      placeholder:
                          'curl -X POST https://api.example.com/login ...',
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: appBackground,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: appLine),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  PrimaryButton(
                    label: '导入到当前步骤',
                    icon: CupertinoIcons.arrow_down_doc_fill,
                    onPressed: () => onImport(controller.text),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DebugVariableSheet extends StatefulWidget {
  const DebugVariableSheet({super.key, required this.variables});

  final List<String> variables;

  @override
  State<DebugVariableSheet> createState() => _DebugVariableSheetState();
}

class _DebugVariableSheetState extends State<DebugVariableSheet> {
  late final Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final variable in widget.variables)
        variable: TextEditingController(),
    };
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPopupSurface(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.72,
        child: CupertinoPageScaffold(
          backgroundColor: CupertinoColors.systemBackground,
          navigationBar: CupertinoNavigationBar(
            middle: const Text('调试变量'),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('取消'),
            ),
          ),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              children: [
                const Text(
                  '只用于本次调试',
                  style: TextStyle(
                    color: appText,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '这个步骤引用了其他响应变量，可以先填入临时值。',
                  style: TextStyle(color: appMutedText, letterSpacing: 0),
                ),
                const SizedBox(height: 16),
                for (final variable in widget.variables) ...[
                  LabeledField(
                    label: variable,
                    controller: _controllers[variable]!,
                    placeholder: '调试值',
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 4),
                PrimaryButton(
                  label: '开始调试',
                  icon: CupertinoIcons.play_fill,
                  onPressed: () {
                    Navigator.of(context).pop({
                      for (final entry in _controllers.entries)
                        entry.key: entry.value.text,
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SingleStepDebugSheet extends StatelessWidget {
  const _SingleStepDebugSheet({required this.result});

  final ShortcutExecutionResult result;

  @override
  Widget build(BuildContext context) {
    final stepResult = result.results.first;
    final log = stepResult.log;
    final error = stepResult.error ?? log.error ?? result.error ?? '';
    final responseTitle = log.responseTruncated ? '响应体（已截断）' : '响应体';

    return CupertinoPopupSurface(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.82,
        child: CupertinoPageScaffold(
          backgroundColor: CupertinoColors.systemBackground,
          navigationBar: CupertinoNavigationBar(
            middle: Text(result.success ? '调试完成' : '调试失败'),
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stepResult.step.name,
                              style: const TextStyle(
                                color: appText,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              error.isEmpty ? '这一步已经执行并写入请求日志。' : error,
                              style: const TextStyle(
                                color: appMutedText,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      StatusPill(
                        success: stepResult.success,
                        statusCode: log.statusCode,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                AppSection(
                  title: '请求',
                  child: PlainPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KeyValueText(label: '方法', value: log.method),
                        KeyValueText(label: '地址', value: log.url),
                        KeyValueText(
                          label: '耗时',
                          value: '${log.durationMs} ms',
                        ),
                        const SizedBox(height: 8),
                        _DebugTextBlock(
                          label: '请求头',
                          value: _formatDebugMap(log.requestHeaders),
                        ),
                        if (log.requestBody.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          _DebugTextBlock(label: '请求体', value: log.requestBody),
                        ],
                      ],
                    ),
                  ),
                ),
                AppSection(
                  title: '响应',
                  child: PlainPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (error.isNotEmpty) ...[
                          KeyValueText(label: '错误', value: error),
                          const SizedBox(height: 8),
                        ],
                        _DebugTextBlock(
                          label: '响应头',
                          value: _formatDebugMap(log.responseHeaders),
                        ),
                        const SizedBox(height: 10),
                        _DebugTextBlock(
                          label: responseTitle,
                          value: log.responseBody.isEmpty
                              ? '-'
                              : log.responseBody,
                        ),
                        const SizedBox(height: 12),
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 9,
                          ),
                          minimumSize: Size.zero,
                          color: const Color(0xFFEFF4FF),
                          borderRadius: BorderRadius.circular(8),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: log.responseBody),
                            );
                          },
                          child: const Text(
                            '复制响应',
                            style: TextStyle(
                              color: Color(0xFF007AFF),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ],
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

class _DebugTextBlock extends StatelessWidget {
  const _DebugTextBlock({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 7),
        DecoratedBox(
          decoration: BoxDecoration(
            color: appBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: appLine.withValues(alpha: 0.72)),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                value,
                style: const TextStyle(
                  color: appText,
                  fontSize: 12,
                  fontFamily: 'monospace',
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String _formatDebugMap(Map<String, String> value) {
  if (value.isEmpty) {
    return '-';
  }
  return const JsonEncoder.withIndent('  ').convert(value);
}

Iterable<String> _templateExpressionsForStep(RequestStep step) {
  final request = step.request;
  final values = <String>[
    request.url,
    ...request.query.keys,
    ...request.query.values,
    ...request.headers.keys,
    ...request.headers.values,
    request.auth.token,
    request.auth.username,
    request.auth.password,
    request.auth.apiKeyName,
    request.auth.apiKeyValue,
    request.body.raw,
    ...request.body.fields.keys,
    ...request.body.fields.values,
  ];
  final expressions = <String>{};
  final pattern = RegExp(r'{{\s*([^{}]+?)\s*}}');
  for (final value in values) {
    for (final match in pattern.allMatches(value)) {
      final expression = match.group(1)?.trim();
      if (expression != null && expression.isNotEmpty) {
        expressions.add(expression);
      }
    }
  }
  return expressions.toList()..sort();
}

class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    required this.controller,
    this.placeholder,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
  });

  final String label;
  final TextEditingController controller;
  final String? placeholder;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final isMultiline = maxLines > 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 7),
        CupertinoTextField(
          controller: controller,
          placeholder: placeholder,
          maxLines: maxLines,
          minLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textAlignVertical: isMultiline ? TextAlignVertical.top : null,
          padding: EdgeInsets.symmetric(
            horizontal: 13,
            vertical: isMultiline ? 12 : 11,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F5F7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: appLine.withValues(alpha: 0.72)),
          ),
        ),
      ],
    );
  }
}

class KeyValueEditor extends StatelessWidget {
  const KeyValueEditor({
    super.key,
    required this.label,
    required this.pairs,
    required this.onChanged,
    required this.keyPlaceholder,
    required this.valuePlaceholder,
    required this.emptyText,
  });

  final String label;
  final List<EditableKeyValuePair> pairs;
  final VoidCallback onChanged;
  final String keyPlaceholder;
  final String valuePlaceholder;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _FieldLabel(label)),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              onPressed: () {
                pairs.add(EditableKeyValuePair.empty());
                onChanged();
              },
              child: const Text(
                '新增',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        if (pairs.isEmpty)
          DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5F7),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: appLine.withValues(alpha: 0.72)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 12,
                ),
                child: Text(
                  emptyText,
                  style: const TextStyle(color: appMutedText, letterSpacing: 0),
                ),
              ),
            ),
          )
        else
          Column(
            children: [
              for (final entry in pairs.indexed) ...[
                _KeyValueRow(
                  pair: entry.$2,
                  keyPlaceholder: keyPlaceholder,
                  valuePlaceholder: valuePlaceholder,
                  onChanged: onChanged,
                  onDelete: () {
                    final removed = pairs.removeAt(entry.$1);
                    removed.dispose();
                    onChanged();
                  },
                ),
                if (entry.$1 != pairs.length - 1) const SizedBox(height: 8),
              ],
            ],
          ),
      ],
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow({
    required this.pair,
    required this.keyPlaceholder,
    required this.valuePlaceholder,
    required this.onChanged,
    required this.onDelete,
  });

  final EditableKeyValuePair pair;
  final String keyPlaceholder;
  final String valuePlaceholder;
  final VoidCallback onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: CupertinoTextField(
            controller: pair.keyController,
            placeholder: keyPlaceholder,
            onChanged: (_) => onChanged(),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: _keyValueDecoration(),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 6,
          child: CupertinoTextField(
            controller: pair.valueController,
            placeholder: valuePlaceholder,
            onChanged: (_) => onChanged(),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: _keyValueDecoration(),
          ),
        ),
        const SizedBox(width: 6),
        CupertinoButton(
          padding: EdgeInsets.zero,
          minimumSize: const Size.square(40),
          onPressed: onDelete,
          child: const Icon(
            CupertinoIcons.minus_circle_fill,
            color: Color(0xFFFF3B30),
            size: 22,
          ),
        ),
      ],
    );
  }

  BoxDecoration _keyValueDecoration() {
    return BoxDecoration(
      color: const Color(0xFFF4F5F7),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: appLine.withValues(alpha: 0.72)),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: appMutedText,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
    );
  }
}

class EditableStep {
  EditableStep.fromStep(RequestStep step)
    : id = step.id,
      shortcutId = step.shortcutId,
      createdAt = step.createdAt,
      keyController = TextEditingController(text: step.key),
      nameController = TextEditingController(text: step.name),
      urlController = TextEditingController(text: step.request.url),
      queryPairs = editablePairsFromMap(step.request.query),
      headerPairs = editablePairsFromMap(step.request.headers),
      timeoutController = TextEditingController(
        text: step.request.timeoutSeconds.toString(),
      ),
      bodyRawController = TextEditingController(text: step.request.body.raw),
      bodyFieldPairs = editablePairsFromMap(step.request.body.fields),
      method = step.request.method,
      bodyType = step.request.body.type;

  final int? id;
  final int? shortcutId;
  final DateTime createdAt;
  final TextEditingController keyController;
  final TextEditingController nameController;
  final TextEditingController urlController;
  final List<EditableKeyValuePair> queryPairs;
  final List<EditableKeyValuePair> headerPairs;
  final TextEditingController timeoutController;
  final TextEditingController bodyRawController;
  final List<EditableKeyValuePair> bodyFieldPairs;
  String method;
  BodyType bodyType;

  RequestStep toStep({required int sortOrder}) {
    return RequestStep(
      id: id,
      shortcutId: shortcutId,
      key: keyController.text.trim().isEmpty
          ? 'step${sortOrder + 1}'
          : keyController.text.trim(),
      name: nameController.text.trim().isEmpty
          ? '请求 ${sortOrder + 1}'
          : nameController.text.trim(),
      sortOrder: sortOrder,
      request: RequestDefinition(
        method: method,
        url: urlController.text.trim(),
        query: editablePairsToMap(queryPairs),
        headers: editablePairsToMap(headerPairs),
        auth: const AuthConfig.none(),
        body: BodyConfig(
          type: bodyType,
          raw: bodyRawController.text,
          fields: editablePairsToMap(bodyFieldPairs),
        ),
        timeoutSeconds: int.tryParse(timeoutController.text) ?? 30,
      ),
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  void dispose() {
    keyController.dispose();
    nameController.dispose();
    urlController.dispose();
    for (final pair in queryPairs) {
      pair.dispose();
    }
    for (final pair in headerPairs) {
      pair.dispose();
    }
    for (final pair in bodyFieldPairs) {
      pair.dispose();
    }
    timeoutController.dispose();
    bodyRawController.dispose();
  }
}

class EditableKeyValuePair {
  EditableKeyValuePair({required String key, required String value})
    : keyController = TextEditingController(text: key),
      valueController = TextEditingController(text: value);

  EditableKeyValuePair.empty() : this(key: '', value: '');

  final TextEditingController keyController;
  final TextEditingController valueController;

  void dispose() {
    keyController.dispose();
    valueController.dispose();
  }
}

List<EditableKeyValuePair> editablePairsFromMap(Map<String, String> value) {
  return value.entries
      .map((entry) => EditableKeyValuePair(key: entry.key, value: entry.value))
      .toList();
}

Map<String, String> editablePairsToMap(List<EditableKeyValuePair> pairs) {
  final map = <String, String>{};
  for (final pair in pairs) {
    final key = pair.keyController.text.trim();
    if (key.isEmpty) {
      continue;
    }
    map[key] = pair.valueController.text.trim();
  }
  return map;
}

int _randomShortcutColor() {
  final random = Random();
  return shortcutColors[random.nextInt(shortcutColors.length)].toARGB32();
}
