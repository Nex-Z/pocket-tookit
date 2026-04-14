import 'package:flutter/cupertino.dart';

import '../../models/api_models.dart';

const appBackground = Color(0xFFF6F6F8);
const appText = Color(0xFF17171A);
const appMutedText = Color(0xFF6E6E73);
const appLine = Color(0xFFE5E5EA);

const shortcutColors = [
  Color(0xFFFF9F0A),
  Color(0xFF34C759),
  Color(0xFF007AFF),
  Color(0xFFFF2D55),
  Color(0xFF5856D6),
  Color(0xFF00C7BE),
];

class AppSection extends StatelessWidget {
  const AppSection({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: appMutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class PlainPanel extends StatelessWidget {
  const PlainPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.backgroundColor,
    this.borderColor = appLine,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      minimumSize: Size.zero,
      color: const Color(0xFF007AFF),
      borderRadius: BorderRadius.circular(8),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: CupertinoColors.white),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: const TextStyle(
              color: CupertinoColors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.success, this.statusCode});

  final bool success;
  final int? statusCode;

  @override
  Widget build(BuildContext context) {
    final color = success ? const Color(0xFF34C759) : const Color(0xFFFF3B30);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          statusCode == null ? (success ? '成功' : '失败') : '$statusCode',
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

class KeyValueText extends StatelessWidget {
  const KeyValueText({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: const TextStyle(
                color: appMutedText,
                fontSize: 13,
                letterSpacing: 0,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(
                color: appText,
                fontSize: 13,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color shortcutColor(ApiShortcut shortcut) {
  return Color(shortcut.color);
}

String bodyTypeLabel(BodyType type) {
  return switch (type) {
    BodyType.none => '无',
    BodyType.json => 'JSON',
    BodyType.text => '文本',
    BodyType.formUrlEncoded => 'Form URL',
    BodyType.formData => 'Form Data',
  };
}

String authTypeLabel(AuthType type) {
  return switch (type) {
    AuthType.none => '无',
    AuthType.bearer => 'Bearer',
    AuthType.basic => 'Basic',
    AuthType.apiKey => 'API Key',
  };
}
