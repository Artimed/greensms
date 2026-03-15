import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Кнопка с градиентом в стиле QR-баннера приложения.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.width,
    this.height = AppTheme.actionButtonHeight,
    this.borderRadius = AppTheme.actionButtonRadius,
  });

  final VoidCallback? onPressed;
  final Widget label;
  final Widget? icon;
  final double? width;
  final double height;
  final double borderRadius;

  static const _gradient = AppColors.gradient;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    final radius = BorderRadius.circular(borderRadius);
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: disabled ? null : _gradient,
          color: disabled
              ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12)
              : null,
          borderRadius: radius,
        ),
        child: Material(
          type: MaterialType.transparency,
          borderRadius: radius,
          child: InkWell(
            onTap: onPressed,
            borderRadius: radius,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    IconTheme(
                      data: IconThemeData(
                        color: disabled
                            ? Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.38)
                            : Colors.white,
                        size: 18,
                      ),
                      child: icon!,
                    ),
                    const SizedBox(width: 8),
                  ],
                  DefaultTextStyle(
                    style: TextStyle(
                      color: disabled
                          ? Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.38)
                          : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1,
                    ),
                    child: label,
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
