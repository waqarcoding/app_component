import 'package:flutter/material.dart';

class ChipWidget<T> extends StatefulWidget {
  const ChipWidget({
    Key? key,
    required this.values,
    required this.onSelected,
    this.labelBuilder,

    // Alignment
    this.alignment = WrapAlignment.start, // overall chips alignment

    // Radio icon
    this.isEnabledRadioBtn = false,
    this.initialIndex = 0,
    this.selectedRadioIcon = Icons.check_circle,
    this.unselectedRadioIcon,
    this.selectedRadioIconColor,
    this.unselectedRadioIconColor,
    this.radioIconSize = 18,

    // Colors
    this.selectedColor = Colors.blue,
    this.unselectedColor = Colors.white,

    // Text styles
    this.selectedTextStyle = const TextStyle(color: Colors.white),
    this.unselectedTextStyle = const TextStyle(color: Colors.black),

    // UI
    this.borderRadius = 20,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.chipHeight = 40,
    this.chipWidth,

    // Selection animation
    this.animationDuration = const Duration(milliseconds: 250),
    this.animationCurve = Curves.easeOut,

    // Tap animation
    this.enableTapEffect = true,
    this.tapScale = 0.94,
    this.tapDuration = const Duration(milliseconds: 120),
  }) : super(key: key);

  final List<T> values;
  final void Function(T value, int index) onSelected;
  final String Function(T value)? labelBuilder;

  /// Overall chips alignment
  final WrapAlignment alignment;

  // Radio icon
  final bool isEnabledRadioBtn;
  final int initialIndex;
  final IconData selectedRadioIcon;
  final IconData? unselectedRadioIcon;
  final Color? selectedRadioIconColor;
  final Color? unselectedRadioIconColor;
  final double radioIconSize;

  // Colors
  final Color selectedColor;
  final Color unselectedColor;

  // Text styles
  final TextStyle selectedTextStyle;
  final TextStyle unselectedTextStyle;

  // UI
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final double chipHeight;
  final double? chipWidth;

  // Selection animation
  final Duration animationDuration;
  final Curve animationCurve;

  // Tap animation
  final bool enableTapEffect;
  final double tapScale;
  final Duration tapDuration;

  @override
  State<ChipWidget<T>> createState() => _ChipWidgetState<T>();
}

class _ChipWidgetState<T> extends State<ChipWidget<T>> {
  late int selectedIndex;
  int? pressedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex.clamp(0, widget.values.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.chipHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: 10,
          runSpacing: 6,
          alignment: widget.alignment,
          children: List.generate(widget.values.length, (index) {
            final value = widget.values[index];
            final isSelected = selectedIndex == index;

            final label =
                widget.labelBuilder?.call(value) ?? value.toString();

            final baseWidth =
                widget.chipWidth ?? (label.length > 10 ? 140 : 90);

            final width =
            widget.isEnabledRadioBtn ? baseWidth + 26 : baseWidth;

            final textStyle =
            isSelected ? widget.selectedTextStyle : widget.unselectedTextStyle;

            final decoration = BoxDecoration(
              color: isSelected ? widget.selectedColor : widget.unselectedColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: widget.borderColor,
                width: widget.borderWidth,
              ),
            );

            final content = Row(
              mainAxisAlignment: MainAxisAlignment.start, // align content to start
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.isEnabledRadioBtn &&
                    (isSelected || widget.unselectedRadioIcon != null)) ...[
                  AnimatedSwitcher(
                    duration: widget.animationDuration,
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: Icon(
                      isSelected
                          ? widget.selectedRadioIcon
                          : widget.unselectedRadioIcon!,
                      key: ValueKey(isSelected),
                      size: widget.radioIconSize,
                      color: isSelected
                          ? widget.selectedRadioIconColor ?? textStyle.color
                          : widget.unselectedRadioIconColor ?? textStyle.color,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: isSelected
                      ? AnimatedDefaultTextStyle(
                    duration: widget.animationDuration,
                    curve: widget.animationCurve,
                    style: textStyle,
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                      : Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle,
                  ),
                ),
              ],
            );

            return SizedBox(
              width: width,
              height: widget.chipHeight,
              child: AnimatedScale(
                scale: widget.enableTapEffect && pressedIndex == index
                    ? widget.tapScale
                    : 1.0,
                duration: widget.tapDuration,
                curve: Curves.easeOut,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    splashColor: widget.selectedColor.withOpacity(0.2),
                    highlightColor: Colors.transparent,
                    onTapDown: widget.enableTapEffect
                        ? (_) => setState(() => pressedIndex = index)
                        : null,
                    onTapCancel: widget.enableTapEffect
                        ? () => setState(() => pressedIndex = null)
                        : null,
                    onTapUp: widget.enableTapEffect
                        ? (_) => setState(() => pressedIndex = null)
                        : null,
                    onTap: () {
                      setState(() => selectedIndex = index);
                      widget.onSelected(value, index);
                    },
                    child: isSelected
                        ? AnimatedContainer(
                      duration: widget.animationDuration,
                      curve: widget.animationCurve,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: decoration,
                      child: content,
                    )
                        : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: decoration,
                      child: content,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
