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
    this.titleBuilder,
    this.subtitleBuilder,
    this.titleStyle = const TextStyle(color: Colors.white),
    this.subtitleStyle = const TextStyle(color: Colors.white70),

    // Selected / Unselected text colors
    this.selectedTitleColor = Colors.white,
    this.unselectedTitleColor = Colors.black,
    this.selectedSubtitleColor = Colors.white70,
    this.unselectedSubtitleColor = Colors.black45,

    // LEFT Radio Icons
    this.selectedRadioIcon = Icons.radio_button_checked,
    this.unselectedRadioIcon = Icons.radio_button_unchecked,
    this.selectedRadioIconColor = Colors.white,
    this.unselectedRadioIconColor = Colors.grey,
    this.radioIconSize = 24,

    // RIGHT Trailing Icons
    this.selectedTrailingIcon = Icons.arrow_forward_ios,
    this.unselectedTrailingIcon = Icons.arrow_forward_ios,
    this.selectedTrailingColor = Colors.white,
    this.unselectedTrailingColor,
    this.trailingIconSize = 18,

    // UI
    this.backgroundColor = Colors.white,
    this.selectedBackgroundColor = Colors.blue,
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
  final String Function(T)? titleBuilder;
  final String Function(T)? subtitleBuilder;
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
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
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
                    ? widget.selectedBackgroundColor
                    : widget.backgroundColor ?? theme.cardColor,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  width: widget.borderWidth,
                  color: widget.borderColor ??
                      (isSelected ? theme.colorScheme.primary : theme.dividerColor),
                ),
              ),
              child:   Row(
            children: [
            Icon(
            isSelected ? widget.selectedRadioIcon : widget.unselectedRadioIcon,
              size: widget.radioIconSize,
              color: isSelected
                  ? widget.selectedRadioIconColor
                  : widget.unselectedRadioIconColor,
            ),
              const SizedBox(width: 12),

              // Title + Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.titleBuilder?.call(item) ?? item.toString(),
                      style: widget.titleStyle?.copyWith(
                        color: isSelected
                            ? widget.selectedTitleColor
                            : widget.unselectedTitleColor,
                      ),
                    ),
                    if (widget.subtitleBuilder != null) SizedBox(height: 4),
                    if (widget.subtitleBuilder != null)
                      Text(
                        widget.subtitleBuilder!(item),
                        style: widget.subtitleStyle?.copyWith(
                          color: isSelected
                              ? widget.selectedSubtitleColor
                              : widget.unselectedSubtitleColor,
                        ),
                      ),
                  ],
                ),
              ),

              if (widget.selectedTrailingIcon != null || widget.unselectedTrailingIcon != null)
          Icon(
        isSelected ? widget.selectedTrailingIcon : widget.unselectedTrailingIcon,
          size: widget.trailingIconSize,
          color: isSelected
              ? widget.selectedTrailingColor ?? theme.colorScheme.primary
              : widget.unselectedTrailingColor ?? theme.disabledColor,
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
