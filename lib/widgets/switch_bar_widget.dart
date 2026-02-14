import 'package:flutter/material.dart';

/// 🔹 SwitchBarWidget
class SwitchBarWidget extends StatefulWidget {
  /// Example Usage:
  /// ```dart
  /// SwitchBarWidget(
  ///   items: [
  ///     SwitchItem(
  ///       label: 'Home',
  ///       icon: Icons.home,
  ///       page: Container(color: Colors.blue, child: Center(child: Text('Home'))),
  ///     ),
  ///     SwitchItem(
  ///       label: 'Pending',
  ///       icon: Icons.timelapse,
  ///       page: Container(color: Colors.green, child: Center(child: Text('Pending'))),
  ///     ),
  ///     SwitchItem(
  ///       label: 'Completed',
  ///       icon: Icons.check_circle,
  ///       page: Container(color: Colors.orange, child: Center(child: Text('Completed'))),
  ///     ),
  ///   ],
  ///   onSelected: (item, index) {
  ///     print('Selected ${item.label} at index $index');
  ///   },
  /// )
  /// ```

  const SwitchBarWidget({
    super.key,
    required this.items,
    this.initialIndex = 0,
    this.height = 60,
    this.borderRadius = 24,
    this.borderWidth = 1,
    this.borderColor = Colors.transparent,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.duration = const Duration(milliseconds: 280),
    this.isCupertinoStyle = false,
    this.isVertical = true,
    this.padding = const EdgeInsets.all(2),
    this.margin = EdgeInsets.zero,
    this.itemSpacing = 5,
    this.onSelected,
    this.pagePadding = const EdgeInsets.only(top: 10),
    this.pageBorderRadius = const BorderRadius.all(Radius.circular(5)),
    this.isSwipToChangePage = true,
    this.itemBoxHeight,
    this.indicatorType = IndicatorType.oval,
    this.indicatorWidthFactor = 0.6,
    this.indicatorHeight = 2.0,
    this.dotSize = 6.0,
    this.indicatorOvalBorder = 10,
  });

  final List<SwitchItem> items;
  final int initialIndex;
  final double height;
  final double? itemBoxHeight;
  final double borderRadius;
  final double borderWidth;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Duration duration;
  final bool isCupertinoStyle;
  final bool isVertical;
  final bool isSwipToChangePage;

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double itemSpacing;
  final EdgeInsetsGeometry pagePadding;
  final BorderRadiusGeometry pageBorderRadius;
  final IndicatorType indicatorType;
  final double indicatorWidthFactor; // for line width
  final double indicatorHeight; // for line thickness
  final double dotSize; // for dot size
  final double indicatorOvalBorder;

  /// 🔹 Called when a new item is selected
  final void Function(SwitchItem item, int index)? onSelected;

  @override
  State<SwitchBarWidget> createState() => _SwitchBarWidgetState();
}

class _SwitchBarWidgetState extends State<SwitchBarWidget> {
  late int _currentIndex;
  late PageController _pageController;
  bool _pageJumping = false; // Prevent double updates

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  void _selectIndex(int index) {
    _pageJumping = true;
    _currentIndex = index;
    setState(() {});
    _pageController
        .animateToPage(
          index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        )
        .then((_) => _pageJumping = false);
    widget.onSelected?.call(widget.items[index], index);
  }

  void _onPageChanged(int index) {
    if (!_pageJumping) {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      setState(() {});
      widget.onSelected?.call(widget.items[index], index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.items.length;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 🔹 Header Tabs
        Container(
          height: widget.height,
          padding: widget.padding,
          margin: widget.margin,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(
              widget.isCupertinoStyle ? 12 : widget.borderRadius,
            ),
            border: Border.all(
              color: widget.borderColor ?? Colors.transparent,
              width: widget.borderWidth,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final indicatorWidth = (constraints.maxWidth -
                      widget.itemSpacing * (itemCount - 1)) /
                  itemCount;
              final indicatorLeft =
                  _currentIndex * (indicatorWidth + widget.itemSpacing);

              return Stack(
                children: [
                  // 🔹 Sliding Indicator

                  widget.indicatorType == IndicatorType.oval
                      ? AnimatedPositioned(
                          duration: widget.duration,
                          curve: Curves.easeInOut,
                          left: indicatorLeft,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: indicatorWidth,
                            decoration: BoxDecoration(
                              color:
                                  widget.selectedColor ?? colorScheme.primary,
                              borderRadius: BorderRadius.circular(
                                widget.borderRadius ??
                                    widget.indicatorOvalBorder ??
                                    10,
                              ),
                            ),
                          ),
                        )
                      : AnimatedPositioned(
                          duration: widget.duration,
                          curve: Curves.easeInOut,
                          left: indicatorLeft,
                          child: Builder(
                            builder: (context) {
                              final color =
                                  widget.selectedColor ?? colorScheme.primary;

                              switch (widget.indicatorType) {
                                case IndicatorType.oval:
                                case IndicatorType.dot:
                                  return Container(
                                    width: indicatorWidth,
                                    height: widget.height,
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 6),
                                      width: widget.dotSize,
                                      height: widget.dotSize,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  );

                                case IndicatorType.line:
                                  return Container(
                                    width: indicatorWidth,
                                    height: widget.height,
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 6),
                                      width: indicatorWidth *
                                          widget.indicatorWidthFactor,
                                      height: widget.indicatorHeight,
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );

                                case IndicatorType.none:
                                  return const SizedBox.shrink();
                              }
                            },
                          ),
                        ),

                  // 🔹 Tabs
                  Row(
                    children: List.generate(itemCount, (i) {
                      final item = widget.items[i];
                      final selected = i == _currentIndex;
                      final selectedIconColor = widget.indicatorType ==
                              IndicatorType.oval
                          ? (item.selectedIconColor ?? colorScheme.surface)
                          : (item.selectedIconColor ?? colorScheme.onSurface);

                      final iconColor = selected
                          ? selectedIconColor
                          : (item.iconColor ??
                              colorScheme.onSurface.withOpacity(0.7));
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => _selectIndex(i),
                          behavior: HitTestBehavior.translucent,
                          child: Container(
                            alignment: Alignment.center,
                            child: widget.isVertical
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (item.icon != null)
                                        Icon(item.icon,
                                            size: selected
                                                ? (item.selectedIconSize ??
                                                    item.iconSize ??
                                                    17)
                                                : (item.iconSize ?? 17),
                                            color: iconColor),
                                      if (item.badge != null && item.badge! > 0)
                                        Container(
                                          margin: const EdgeInsets.only(top: 2),
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            color: item.badgeColor ??
                                                colorScheme.primary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            '${item.badge}',
                                            style: selected
                                                ? (item.selectedLabelStyle ??
                                                    TextStyle(
                                                        fontSize: 12,
                                                        color: widget
                                                                .selectedColor ??
                                                            colorScheme
                                                                .surface))
                                                : (item.labelStyle ??
                                                    TextStyle(
                                                        fontSize: 12,
                                                        color: widget
                                                                .selectedColor ??
                                                            colorScheme
                                                                .onSurface
                                                                .withOpacity(
                                                                    0.7))),
                                          ),
                                        ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item.label,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: selected
                                            ? (item.selectedLabelStyle ??
                                                TextStyle(
                                                    fontSize: 12,
                                                    color: widget
                                                                .indicatorType ==
                                                            IndicatorType.oval
                                                        ? widget.selectedColor ??
                                                            colorScheme.surface
                                                        : widget.selectedColor ??
                                                            colorScheme
                                                                .onSurface))
                                            : (item.labelStyle ??
                                                TextStyle(
                                                    fontSize: 12,
                                                    color: widget
                                                                .indicatorType ==
                                                            IndicatorType.oval
                                                        ? widget.selectedColor ??
                                                            colorScheme
                                                                .onSurface
                                                        : widget.selectedColor ??
                                                            colorScheme
                                                                .onSurface)),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (item.icon != null)
                                        Icon(
                                          item.icon,
                                          size: selected
                                              ? (item.selectedIconSize ??
                                                  item.iconSize ??
                                                  20)
                                              : (item.iconSize ?? 20),
                                          color: selected
                                              ? (item.selectedIconColor ??
                                                  Colors.white)
                                              : (item.iconColor ??
                                                  Colors.black54),
                                        ),
                                      if (item.badge != null && item.badge! > 0)
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 4),
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color:
                                                item.badgeColor ?? Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            '${item.badge}',
                                            style: TextStyle(
                                              fontSize: item.badgeSize ?? 8,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          item.label,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: selected
                                              ? (item.selectedLabelStyle ??
                                                  const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white))
                                              : (item.labelStyle ??
                                                  const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black54)),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          ),
        ),

        // 🔹 PageView
        Padding(
          padding: widget.pagePadding,
          child: SizedBox(
            height: widget.itemBoxHeight ?? 300,
            child: PageView.builder(
              physics: widget.isSwipToChangePage
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              controller: _pageController,
              itemCount: widget.items.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: widget.pageBorderRadius,
                child: widget.items[index].page,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 🔹 Switch Item
class SwitchItem {
  final String label;
  final IconData? icon;

  // Icon
  final double? iconSize;
  final double? selectedIconSize;
  final Color? iconColor;
  final Color? selectedIconColor;

  // Label
  final TextStyle? labelStyle;
  final TextStyle? selectedLabelStyle;

  // Badge
  final int? badge;
  final double? badgeSize;
  final Color? badgeColor;

  // Page
  final Widget page;

  const SwitchItem({
    required this.label,
    this.icon,
    this.iconSize,
    this.selectedIconSize,
    this.iconColor,
    this.selectedIconColor,
    this.labelStyle,
    this.selectedLabelStyle,
    this.badge,
    this.badgeSize,
    this.badgeColor,
    this.page = const SizedBox(),
  });
}

enum IndicatorType {
  oval,
  dot,
  line,
  none,
}
