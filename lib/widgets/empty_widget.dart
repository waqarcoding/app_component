import 'package:flutter/material.dart';

class EmptyPlaceholder extends StatelessWidget {
  // Optional content with defaults
  final IconData icon;
  final String title;
  final String subtitle;

  // Optional default button
  final String? buttonText;
  final VoidCallback? onPressed;
  final bool isRoundButton;
  final Color? buttonColor;
  final IconData buttonIcon;

  // Optional custom button
  final Widget? customButton;

  // Customization
  final Color? iconColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final double iconSize;
  final EdgeInsetsGeometry padding;

  const EmptyPlaceholder({
    super.key,
    this.icon = Icons.inbox,
    this.title = "Nothing Here",
    this.subtitle = "Add some items to get started",
    this.buttonText,
    this.onPressed,
    this.isRoundButton = true,
    this.buttonColor,
    this.buttonIcon = Icons.add,
    this.customButton,
    this.iconColor,
    this.titleStyle,
    this.subtitleStyle,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.iconSize = 60,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          border: borderColor != null
              ? Border.all(color: borderColor!, width: borderWidth ?? 1)
              : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor?.withOpacity(0.7) ??
                  colorScheme.onSurface.withOpacity(0.4),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: titleStyle ??
                  theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: subtitleStyle ??
                  theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
            ),
            if (customButton != null ||
                (buttonText != null && onPressed != null))
              const SizedBox(height: 25),
            if (customButton != null)
              customButton!
            else if (buttonText != null && onPressed != null)
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor ?? colorScheme.primary,
                  shape: isRoundButton
                      ? const CircleBorder()
                      : RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                  padding: isRoundButton
                      ? const EdgeInsets.all(18)
                      : const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                ),
                child: isRoundButton
                    ? Icon(buttonIcon, size: 24)
                    : Text(
                        buttonText!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
