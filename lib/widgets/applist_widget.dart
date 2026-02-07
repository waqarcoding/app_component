import 'package:flutter/material.dart';

class AppListView<T> extends StatefulWidget {
  const AppListView({
    super.key,
    required this.items,
    this.onTap,

    // Selection
    this.isSelectable = false,
    this.selectedItem,
    this.selectedColor = Colors.blue,
    this.unselectedColor = Colors.white,

    // Border
    this.borderRadius = 12,
    this.borderWidth,
    this.borderColor,

    // Layout
    this.padding = const EdgeInsets.all(12),

    // Background
    this.backgroundColor=Colors.white,

    // Content builders
    this.titleBuilder,
    this.subtitleBuilder,
    this.leadingIconBuilder,
    this.trailingIconBuilder,

    // Sizes
    this.titleSize,
    this.subtitleSize,
    this.iconSize = 24,
    this.dividerHeight,

    // Colors (fallback only)
    this.titleColor,
    this.subtitleColor,
    this.leadingIconColor,
    this.trailingIconColor,

    // Base styles
    this.titleStyle,
    this.subtitleStyle,

    // Selected / Unselected TEXT styles
    this.selectedTitleStyle =
    const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    this.unselectedTitleStyle,
    this.selectedSubtitleStyle = const TextStyle(color: Colors.white),
    this.unselectedSubtitleStyle,

    // Selected / Unselected ICON styles
    this.selectedLeadingIconStyle = const IconThemeData(color: Colors.white),
    this.unselectedLeadingIconStyle,
    this.selectedTrailingIconStyle = const IconThemeData(color: Colors.white),
    this.unselectedTrailingIconStyle,

    // Search
    this.isSearchable = false,
    this.searchHint = 'Search...',
    this.searchHintStyle, // NEW
    this.searchLeadingIcon,
    this.searchTrailingIcon,
    this.searchHeight = 70,
    this.searchBorderRadius,

    this.searchBorderColor,
    this.searchBorderWidth = 0,

    // Search icon styles
    this.searchLeadingIconStyle = const IconThemeData(color: Colors.grey),
    this.searchTrailingIconStyle = const IconThemeData(color: Colors.grey),

    this.onSearchChanged,

    // List title
    this.isShowTitle = true,
    this.listTitle="Items",
    this.listTitleStyle,
    this.listFilterIcon = Icons.filter_list,
    this.listFilterIconStyle,
    this.isShowFilter = true,
    this.filterNames = const ['New', 'Old'],
    this.onFilterSelected,

    // No results widget
    this.noResultsWidget, this.searchPadding,
  });

  final List<T> items;
  final ValueChanged<T>? onTap;

  // Selection
  final bool isSelectable;
  final T? selectedItem;
  final Color? selectedColor;
  final Color? unselectedColor;

  // Border
  final double? borderRadius;
  final double? borderWidth;
  final Color? borderColor;

  // Layout
  final EdgeInsets padding;

  // Background
  final Color? backgroundColor;

  // Content builders
  final String Function(T)? titleBuilder;
  final String Function(T)? subtitleBuilder;
  final IconData Function(T)? leadingIconBuilder;
  final IconData Function(T)? trailingIconBuilder;

  // Sizes
  final double? titleSize;
  final double? subtitleSize;
  final double iconSize;
  final double? dividerHeight;

  // Colors (fallback)
  final Color? titleColor;
  final Color? subtitleColor;
  final Color? leadingIconColor;
  final Color? trailingIconColor;

  // Base styles
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  // Text styles
  final TextStyle? selectedTitleStyle;
  final TextStyle? unselectedTitleStyle;
  final TextStyle? selectedSubtitleStyle;
  final TextStyle? unselectedSubtitleStyle;

  // Icon styles
  final IconThemeData? selectedLeadingIconStyle;
  final IconThemeData? unselectedLeadingIconStyle;
  final IconThemeData? selectedTrailingIconStyle;
  final IconThemeData? unselectedTrailingIconStyle;

  // Search
  final bool isSearchable;
  final String searchHint;
  final TextStyle? searchHintStyle; // NEW
  final IconData? searchLeadingIcon;
  final IconData? searchTrailingIcon;
  final double searchHeight;
  final double? searchBorderRadius;
  final Color? searchFillColor=  Colors.white;
  final Color? searchBorderColor;
  final double searchBorderWidth;
  final EdgeInsetsGeometry?  searchPadding;

  // Search icon styles
  final IconThemeData? searchLeadingIconStyle;
  final IconThemeData? searchTrailingIconStyle;

  final ValueChanged<String>? onSearchChanged;

  // List title & filter
  final bool isShowTitle;
  final String? listTitle;
  final TextStyle? listTitleStyle;
  final IconData listFilterIcon;
  final IconThemeData? listFilterIconStyle;
  final bool isShowFilter;
  final List<String> filterNames;
  final ValueChanged<String>? onFilterSelected;

  // No results
  final Widget? noResultsWidget;

  @override
  State<AppListView<T>> createState() => _AppListViewState<T>();
}

class _AppListViewState<T> extends State<AppListView<T>> {
  String _searchQuery = '';
  T? _selectedItem;
  String _selectedFilter = 'New';

  var selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem;

    selectedColor=widget.backgroundColor;
    if (widget.filterNames.isNotEmpty) {
      _selectedFilter = widget.filterNames[0];
    }
  }

  List<T> _applyFilter(List<T> items) {
    if (_selectedFilter.toLowerCase() == 'new') {
      return items.reversed.toList();
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Apply search
    var displayedItems = widget.isSearchable && _searchQuery.isNotEmpty
        ? widget.items.where((item) {
      final title = widget.titleBuilder?.call(item) ?? item.toString();
      final subtitle = widget.subtitleBuilder?.call(item) ?? '';
      return title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          subtitle.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList()
        : [...widget.items];

    // Apply filter dynamically
    displayedItems = _applyFilter(displayedItems);

    return Column(
      children: [
        // Search field
        if (widget.isSearchable)
          Padding(
            padding: widget.searchPadding??EdgeInsets.only(top: 10,bottom:0),
            child: SizedBox(
              height: widget.searchHeight,
              child: TextField(
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                  widget.onSearchChanged?.call(value);
                },
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  hintStyle: widget.searchHintStyle ??
                      theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  filled: true,
                  fillColor: widget.searchFillColor,
                  prefixIcon: widget.searchLeadingIcon != null
                      ? Icon(widget.searchLeadingIcon,
                      color: widget.searchLeadingIconStyle?.color)
                      : null,
                  suffixIcon: widget.searchTrailingIcon != null
                      ? Icon(widget.searchTrailingIcon,
                      color: widget.searchTrailingIconStyle?.color)
                      : null,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: (widget.searchHeight - 24) / 2,
                    horizontal: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.searchBorderRadius ?? 12),
                    borderSide: BorderSide(
                        width: widget.searchBorderWidth,
                        color: widget.searchBorderColor ?? theme.dividerColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.searchBorderRadius ?? 12),
                    borderSide: BorderSide(
                        width: widget.searchBorderWidth,
                        color: widget.searchBorderColor ?? Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.searchBorderRadius ?? 12),
                    borderSide: BorderSide(
                        width: widget.searchBorderWidth,
                        color: widget.searchBorderColor ?? Colors.transparent),
                  ),
                ),
              ),
            ),
          ),

        // List Title + Filter
        if (widget.isShowTitle)
          Padding(
            padding:  EdgeInsets.only(top: 0,bottom: 5),
            child: Row(


              children: [
                Expanded(
                  child: Text(
                    widget.listTitle ?? '',
                    style: widget.listTitleStyle ?? theme.textTheme.titleMedium,
                  ),
                ),
                if (widget.isShowFilter)
                  PopupMenuButton<String>(
                    icon: Icon(widget.listFilterIcon, color: widget.listFilterIconStyle?.color),
                    onSelected: (filter) {
                      setState(() => _selectedFilter = filter);
                      widget.onFilterSelected?.call(filter);
                    },
                    itemBuilder: (context) => widget.filterNames
                        .map((filter) => PopupMenuItem(
                      value: filter,
                      child: Text(filter),
                    ))
                        .toList(),
                  ),
              ],
            ),
          ),

        // List items
        Expanded(
          child: displayedItems.isEmpty
              ? widget.noResultsWidget ?? const Center(child: Text('No results found'))
              : ListView.separated(
            itemCount: displayedItems.length,
            separatorBuilder: (_, __) => SizedBox(height: widget.dividerHeight ?? 8),
            itemBuilder: (context, index) {
              final item = displayedItems[index];
              final isSelected = widget.isSelectable && item == _selectedItem;

              return InkWell(
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
                onTap: () {
                  if (widget.isSelectable) setState(() => _selectedItem = item);
                  widget.onTap?.call(item);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: widget.padding,
                  decoration: BoxDecoration(
                    color: isSelected ? widget.selectedColor : widget.unselectedColor,
                    borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
                  ),
                  child: Row(
                    children: [
                      if (widget.leadingIconBuilder != null) ...[
                        Icon(
                          widget.leadingIconBuilder!(item),
                          size: widget.iconSize,
                          color: isSelected
                              ? widget.selectedLeadingIconStyle?.color
                              : widget.unselectedLeadingIconStyle?.color ?? widget.leadingIconColor,
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.titleBuilder?.call(item) ?? item.toString(),
                              style: isSelected
                                  ? widget.selectedTitleStyle
                                  : widget.unselectedTitleStyle ?? widget.titleStyle ?? theme.textTheme.bodyLarge,
                            ),
                            if (widget.subtitleBuilder != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.subtitleBuilder!(item),
                                style: isSelected
                                    ? widget.selectedSubtitleStyle
                                    : widget.unselectedSubtitleStyle ?? widget.subtitleStyle ?? theme.textTheme.bodySmall,
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (widget.trailingIconBuilder != null) ...[
                        const SizedBox(width: 12),
                        Icon(
                          widget.trailingIconBuilder!(item),
                          size: widget.iconSize,
                          color: isSelected
                              ? widget.selectedTrailingIconStyle?.color
                              : widget.unselectedTrailingIconStyle?.color ?? widget.trailingIconColor ?? theme.iconTheme.color,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
