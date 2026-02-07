import 'package:app_component/core/constants/theme_constants.dart';
import 'package:flutter/material.dart';

class TabBarWidget<T> extends StatefulWidget implements PreferredSizeWidget {
  final List<T> tabs;
  final int initialIndex;
  final ValueChanged<int> onTabChanged;

  /// How to display each tab (required)
  final String Function(T item) labelBuilder;

  /// Optional custom tab widget
  final Widget Function(T item, bool isSelected)? tabBuilder;

  // Additional customization
  final double height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double itemSpacing;

  const TabBarWidget({
    super.key,
    required this.tabs,
    required this.onTabChanged,
    required this.labelBuilder,
    this.tabBuilder,
    this.initialIndex = 0,
    this.height = 56,
    this.borderRadius = 14,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.margin = EdgeInsets.zero,
    this.itemSpacing = 5,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  State<TabBarWidget<T>> createState() => _TabBarWidgetState<T>();
}

class _TabBarWidgetState<T> extends State<TabBarWidget<T>>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex.clamp(0, widget.tabs.length - 1),
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        widget.onTabChanged(_tabController.index);
        setState(() {});
      }
    });
  }

  @override
  void didUpdateWidget(covariant TabBarWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabs.length != widget.tabs.length) {
      _tabController.dispose();
      _initController();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _tabController.index;

    return SizedBox(
      height: widget.height,
      child: TabBar(
        dividerColor: Colors.transparent,
        controller: _tabController,
        isScrollable: true,
        indicatorColor: Colors.transparent,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        labelPadding: EdgeInsets.zero,
        tabs: List.generate(widget.tabs.length, (index) {
          final item = widget.tabs[index];
          final isSelected = index == selectedIndex;

          if (widget.tabBuilder != null) {
            return widget.tabBuilder!(item, isSelected);
          }

          return Container(
            margin: widget.margin,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: isSelected
                  ? (widget.selectedColor ?? AppColors.surface)
                  : (widget.unselectedColor ??
                      (widget.backgroundColor ??
                          AppColors.surface.withOpacity(0.15))),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: Text(
              widget.labelBuilder(item),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          );
        }),
        onTap: widget.onTabChanged,
      ),
    );
  }
}
