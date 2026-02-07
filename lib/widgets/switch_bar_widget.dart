import 'package:flutter/material.dart';

class SwitchBarWidget extends StatefulWidget {
  /// ### Example Usage
  ///  ```dart
  /// SwitchBarWidget(
  ///   items: [
  ///     SwitchItem(
  ///       label: 'Home',
  ///       icon: Ionicons.sparkles,
  ///       page: Container(
  ///         color: Colors.blueAccent,
  ///         alignment: Alignment.center,
  ///         child: const Text(
  ///           'Home',
  ///           style: TextStyle(
  ///             fontSize: 28,
  ///             fontWeight: FontWeight.bold,
  ///             color: Colors.white,
  ///           ),
  ///         ),
  ///       ),
  ///     ),
  ///     SwitchItem(
  ///       label: 'Pending',
  ///       icon: Icons.timelapse,
  ///       page: Container(
  ///         color: Colors.greenAccent,
  ///         alignment: Alignment.center,
  ///         child: const Text(
  ///           'Pending Tasks',
  ///           style: TextStyle(
  ///             fontSize: 28,
  ///             fontWeight: FontWeight.bold,
  ///             color: Colors.white,
  ///           ),
  ///         ),
  ///       ),
  ///     ),
  ///     SwitchItem(
  ///       label: 'Completed',
  ///       icon: Icons.check_circle,
  ///       page: Container(
  ///         color: Colors.orangeAccent,
  ///         alignment: Alignment.center,
  ///         child: const Text(
  ///           'Completed Tasks',
  ///           style: TextStyle(
  ///             fontSize: 28,
  ///             fontWeight: FontWeight.bold,
  ///             color: Colors.white,
  ///           ),
  ///         ),
  ///       ),
  ///     ),
  ///   ],
  ///   onChanged: (index) {
  ///     print('Selected index: $index');
  ///   },
  /// )
  /// ```

  const SwitchBarWidget({
    super.key,
    required this.items,
    this.initialIndex = 0,
    this.height = 48,
    this.borderRadius = 24,
    this.borderWidth = 1,
    this.borderColor = Colors.transparent,
    this.backgroundColor,
    this.selectedColor = Colors.blue,
    this.unselectedColor,
    this.duration = const Duration(milliseconds: 280),
    this.isCupertinoStyle = false,
    this.isVertical = true,
    this.padding = const EdgeInsets.all(2),
    this.margin = EdgeInsets.zero,
    this.itemSpacing = 5,
    this.onChanged,
    this.pagePadding = const EdgeInsets.only(top: 10),
    this.pageBorderRadius = const BorderRadius.all(Radius.circular(5)),
    this.isSwipToChangePage = true,
  });

  final List<SwitchItem> items;
  final int initialIndex;
  final double height;
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

  final ValueChanged<int>? onChanged;

  @override
  State<SwitchBarWidget> createState() => _SwitchBarWidgetState();
}

class _SwitchBarWidgetState extends State<SwitchBarWidget> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  bool _pageJumping = false; // Prevent double updates
  void _selectIndex(int index) {
    _pageJumping = true; // prevent onPageChanged double update
    _currentIndex = index;
    setState(() {}); // update header immediately
    _pageController
        .animateToPage(
          index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        )
        .then((_) => _pageJumping = false); // allow future updates
    widget.onChanged?.call(index);
  }

  void _onPageChanged(int index) {
    if (!_pageJumping) {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      setState(() {}); // update header only
      widget.onChanged?.call(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.items.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
                  // Sliding indicator
                  AnimatedPositioned(
                    duration: widget.duration,
                    curve: Curves.easeInOut,
                    left: indicatorLeft,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: indicatorWidth,
                      decoration: BoxDecoration(
                        color: widget.selectedColor,
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                      ),
                    ),
                  ),

                  // Tabs
                  Row(
                    children: List.generate(itemCount, (i) {
                      final item = widget.items[i];
                      final selected = i == _currentIndex;

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
                                        Positioned(
                                          right: -6,
                                          top: -6,
                                          child: Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              color:
                                                  item.badgeColor ?? Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              '${item.badge}',
                                              style: TextStyle(
                                                fontSize: item.badgeSize ?? 9,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 2),
                                      Text(
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

        // PageView
        Padding(
          padding: widget.pagePadding,
          child: SizedBox(
            height: 300,
            child: PageView.builder(
              physics: widget.isSwipToChangePage
                  ? AlwaysScrollableScrollPhysics()
                  : NeverScrollableScrollPhysics(), // 🔹 disables swipe
              controller: _pageController,
              itemCount: widget.items.length,
              onPageChanged: (i) => _onPageChanged(i),
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: widget.pageBorderRadius,
                child: widget.items[index].page,
              ),
            ),
          ),
        )
      ],
    );
  }
}

/// 🔹 Toggle Item
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
    this.iconSize = 20,
    this.selectedIconSize,
    this.iconColor,
    this.selectedIconColor,
    this.labelStyle,
    this.selectedLabelStyle,
    this.badge,
    this.badgeSize = 7,
    this.badgeColor = Colors.blue,
    this.page = const SizedBox(),
  });
}
