import 'package:flutter/material.dart';

class RadioGroupWidget<T> extends StatefulWidget {
  /// ### Example Usage
  ///
  /// ```dart
  /// RadioGroupWidget<String>(
  ///   items: ['Basic', 'Pro', 'Enterprise'],
  ///   initialIndex: 0, // default selected item ("Basic")
  ///   titleBuilder: (v) => v,
  ///   subtitleBuilder: (v) => 'Plan: $v',
  ///   onChanged: (item) {
  ///     print("Selected: $item");
  ///   },
  /// ),
  /// ```
  const RadioGroupWidget({
    super.key,
    required this.items,
    this.onChanged,

    // Text
    this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,

    // Selected / Unselected text colors
    this.selectedTitleColor,
    this.unselectedTitleColor,
    this.selectedSubtitleColor,
    this.unselectedSubtitleColor,

    // LEFT Radio Icons
    this.selectedRadioIcon = Icons.radio_button_checked,
    this.unselectedRadioIcon = Icons.radio_button_unchecked,
    this.selectedRadioIconColor,
    this.unselectedRadioIconColor,
    this.radioIconSize = 24,

    // RIGHT Trailing Icons
    this.selectedTrailingIcon = Icons.arrow_forward_ios,
    this.unselectedTrailingIcon = Icons.arrow_forward_ios,
    this.selectedTrailingColor = Colors.white,
    this.unselectedTrailingColor,
    this.trailingIconSize = 18,

    // UI
    this.unSelectedBackgroundColo = Colors.white,
    this.selectedunSelectedBackgroundColo = Colors.blue,
    this.borderRadius = 12,
    this.borderWidth = 1,
    this.borderColor = Colors.transparent,
    this.shadowColor,
    this.initialIndex = 0, // default to first item
    // Divider
    this.dividerHeight = 12,
  });

  final List<T> items;
  final int initialIndex;

  final ValueChanged<T>? onChanged;

  // Text
  final String? title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  // Text colors
  final Color? selectedTitleColor;
  final Color? unselectedTitleColor;
  final Color? selectedSubtitleColor;
  final Color? unselectedSubtitleColor;

  // LEFT Radio Icons
  final IconData selectedRadioIcon;
  final IconData unselectedRadioIcon;
  final Color? selectedRadioIconColor;
  final Color? unselectedRadioIconColor;
  final double radioIconSize;

  // RIGHT Trailing Icons
  final IconData? selectedTrailingIcon;
  final IconData? unselectedTrailingIcon;
  final Color? selectedTrailingColor;
  final Color? unselectedTrailingColor;
  final double trailingIconSize;

  // UI
  final Color? unSelectedBackgroundColo;
  final Color? selectedunSelectedBackgroundColo;
  final double borderRadius;
  final double borderWidth;
  final Color? borderColor;
  final Color? shadowColor;

  // Divider
  final double dividerHeight;

  @override
  State<RadioGroupWidget<T>> createState() => _RadioGroupWidgetState<T>();
}

class _RadioGroupWidgetState<T> extends State<RadioGroupWidget<T>> {
  late int _selectedIndex; // track selected index

  @override
  void initState() {
    super.initState();
    // If items exist, clamp initialIndex to a valid range
    _selectedIndex = widget.items.isNotEmpty
        ? widget.initialIndex.clamp(0, widget.items.length - 1)
        : 0;
  }

  void _select(int index) {
    setState(() => _selectedIndex = index);
    widget.onChanged?.call(widget.items[index]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      children: List.generate(widget.items.length, (index) {
        final item = widget.items[index];
        final isSelected = index == _selectedIndex;

        return Padding(
          padding: EdgeInsets.only(bottom: widget.dividerHeight),
          child: InkWell(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            onTap: () => _select(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? (widget.selectedunSelectedBackgroundColo ??
                        colorScheme.primary)
                    : (widget.unSelectedBackgroundColo ?? colorScheme.surface),
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  width: widget.borderWidth,
                  color: widget.borderColor ??
                      (isSelected
                          ? theme.colorScheme.primary
                          : theme.dividerColor),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? widget.selectedRadioIcon
                        : widget.unselectedRadioIcon,
                    size: widget.radioIconSize,
                    color: isSelected
                        ? widget.selectedRadioIconColor ?? colorScheme.surface
                        : widget.unselectedRadioIconColor ??
                            colorScheme.onSurface.withOpacity(0.7),
                  ),
                  const SizedBox(width: 12),

                  // Title + Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.toString(),
                          style: widget.titleStyle ??
                              TextStyle(
                                color: isSelected
                                    ? widget.selectedTitleColor ??
                                        colorScheme.surface
                                    : widget.unselectedTitleColor ??
                                        colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                        ),
                        if (widget.subtitle != null) SizedBox(height: 4),
                        if (widget.subtitle != null)
                          Text(
                            item.toString(),
                            style: widget.subtitleStyle ??
                                TextStyle(
                                  color: isSelected
                                      ? widget.selectedSubtitleColor ??
                                          colorScheme.surface
                                      : widget.unselectedSubtitleColor ??
                                          colorScheme.onSurface
                                              .withOpacity(0.5),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                          ),
                      ],
                    ),
                  ),

                  if (widget.selectedTrailingIcon != null ||
                      widget.unselectedTrailingIcon != null)
                    Icon(
                      isSelected
                          ? widget.selectedTrailingIcon
                          : widget.unselectedTrailingIcon,
                      size: widget.trailingIconSize,
                      color: isSelected
                          ? widget.selectedTrailingColor ?? colorScheme.surface
                          : widget.unselectedTrailingColor ??
                              colorScheme.onSurface.withOpacity(0.7),
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
