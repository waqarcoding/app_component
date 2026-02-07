import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:http/http.dart' as http;



class AppBarWidget<T> extends StatefulWidget
    implements PreferredSizeWidget {
  final String title;
  final SearchBarConfig<T>? Function()? isShowSearchBar;

  final bool isShowSearchIcon;
  final Color backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;
  final Color iconColor;
  final TextStyle? titleStyle;
  final double height;
  final Widget? loadingWidget;

  /// A highly customizable SearchBar widget with overlay results.
  ///
  /// Example usage:
  /// ```dart
  /// AppBarWidget<User>(
  ///   title: "Users",
  ///   isShowSearchBar: () => SearchBarConfig<User>(
  ///     url: "https://jsonplaceholder.typicode.com/users",
  ///     fromJson: User.fromJson,
  ///     searchBackgroundColor: Colors.white,
  ///     searchBy: (user) => user.name,
  ///     itemBuilder: (user) => ListTile(
  ///       leading: CircleAvatar(child: Text(user.name[0])),
  ///       title: Text(user.name),
  ///       subtitle: Text(user.email),
  ///       onTap: () => debugPrint("Selected: ${user.name}"),
  ///     ),
  ///   ),
  /// )
  ///
  ///
  /// class User {
  ///   final int id;
  ///   final String name;
  ///   final String email;
  ///
  ///   User({required this.id, required this.name, required this.email});
  ///
  ///   factory User.fromJson(Map<String, dynamic> json) {
  ///     return User(
  ///       id: json['id'],
  ///       name: json['name'],
  ///       email: json['email'],
  ///     );
  ///   }
  /// }
  /// ```
  const AppBarWidget({
    super.key,
    required this.title,
    this.isShowSearchBar,
    this.isShowSearchIcon = true,
    this.backgroundColor = Colors.blue,


    this.iconColor = Colors.white,
    this.titleStyle,
    this.height = kToolbarHeight,
    this.loadingWidget,
    this.borderRadius = const BorderRadius.all(Radius.circular(0))
    ,  this.padding=const EdgeInsets.all(0),
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  State<AppBarWidget<T>> createState() => _AppBarWidgetState<T>();
}
/// ==================== SEARCH BAR CONFIG ====================
class SearchBarConfig<T> {
  final String url;
  final T Function(Map<String, dynamic>) fromJson;
  final Widget Function(T) itemBuilder;
  final String Function(T) searchBy;
  final Color? searchBackgroundColor;
  final double searchItemHeight;
  final double searchErrorHeight;
  final Color searchCursorColor;
  SearchBarConfig(  {
    required this.url,
    required this.fromJson,
    required this.itemBuilder,
    required this.searchBy,
    this.searchItemHeight=300.0,
    this.searchErrorHeight=100,
    this.searchCursorColor = Colors.white38,
    this.searchBackgroundColor,
  });
}
/// ==================== STATE ====================
class _AppBarWidgetState<T> extends State<AppBarWidget<T>> {
  final TextEditingController _controller = TextEditingController();
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;

  bool _isSearching = false;
  bool _loading = false;
  String _searchText = "";

  List<T> _items = [];

  SearchBarConfig<T>? get _config => widget.isShowSearchBar?.call();

  @override
  void initState() {
    super.initState();
    if (_config != null) {
      _loadItems();
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    super.dispose();
  }

  /// ==================== API ====================
  Future<void> _loadItems() async {
    setState(() => _loading = true);
    try {
      final res = await http.get(Uri.parse(_config!.url));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        _items = data.map<T>((e) => _config!.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("API Error: $e");
    }
    setState(() => _loading = false);
  }

  /// ==================== OVERLAY ====================
  void _showOverlay() {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final filtered = _items.where((item) {
          return _config!
              .searchBy(item)
              .toLowerCase()
              .contains(_searchText.toLowerCase());
        }).toList();

        return Positioned(

          width: MediaQuery.of(context).size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, widget.height),
            child: Material(
              elevation: 10,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              color: _config?.searchBackgroundColor ?? Colors.white,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: filtered.isEmpty
                      ? (_config?.searchErrorHeight ?? 100)
                      : (_config?.searchItemHeight ?? 300),
                ),                child: _loading
                    ? widget.loadingWidget ??
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                          child: CircularProgressIndicator()),
                    )
                    : filtered.isEmpty
                    ? const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                      child: Text("No results found")),
                )
                    : ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: filtered.map((item) {
                    return InkWell(
                      onTap: () {
                        clear(closeSearch: true);
                      },
                      child: _config!.itemBuilder(item),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// ==================== CLEAR ====================
  void clear({bool closeSearch = false}) {
    _controller.clear();
    _searchText = "";
    _removeOverlay();

    if (closeSearch) {
      _isSearching = false;
    }

    setState(() {});
  }

  /// ==================== UI ====================
  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Padding(padding: widget.padding,child: ClipRRect(
        borderRadius: widget.borderRadius, // 🔥 round corners
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: widget.backgroundColor,
          elevation: 0,

          title: _isSearching
              ? TextField(
            controller: _controller,
            cursorColor: _config?.searchCursorColor, // 👈 cursor color
            autofocus: true,
            style: TextStyle(color: widget.iconColor),
            decoration: InputDecoration(

              hintText: "Search...",
              hintStyle: TextStyle(
                  color: widget.iconColor.withOpacity(0.6)),
              border: InputBorder.none,
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                icon: Icon(EvaIcons.backspace,
                    color: widget.iconColor),
                onPressed: () => clear(),
              )
                  : null,
            ),
            onChanged: (v) {
              _searchText = v;
              if (v.isNotEmpty) {
                _showOverlay();
              } else {
                _removeOverlay();
              }
            },
          )
              : Text(
            widget.title,
            style: widget.titleStyle ??
                TextStyle(
                    color: widget.iconColor,
                    fontWeight: FontWeight.bold),
          ),

          leading: IconButton(
            icon: Icon(EvaIcons.menu2, color: widget.iconColor),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),

          actions: [
            if (_config != null && widget.isShowSearchIcon)
              IconButton(
                icon: Icon(
                  _isSearching ? EvaIcons.close : EvaIcons.search,
                  color: widget.iconColor,
                ),
                onPressed: () {
                  if (_isSearching) {
                    clear(closeSearch: true);
                  } else {
                    setState(() => _isSearching = true);
                  }
                },
              ),
          ],
        ),
      ),));
  }
}
