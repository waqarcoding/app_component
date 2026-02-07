import 'package:flutter/material.dart';

/// ---------------------------
/// AppDrawer: reusable drawer
/// ---------------------------
class AppDrawer extends StatelessWidget {
  final String headerTitle;
  final String? headerSubtitle;
  final Widget? headerIcon;

  final Color? itemBackgroundColor;
  final Color? headerBackgroundColor;

  final TextStyle? headerTitleStyle;
  final TextStyle? headerSubtitleStyle;

  final List<DrawerItem> items;

  // Drawer corner radius
  final double topRightRadius;
  final double bottomRightRadius;

  // Padding controls
  final EdgeInsetsGeometry? headerPadding;
  final EdgeInsetsGeometry? itemPadding;

  const AppDrawer({
    super.key,
    required this.headerTitle,
    required this.items,
    this.headerSubtitle,
    this.headerIcon,
    this.itemBackgroundColor,
    this.headerBackgroundColor,
    this.headerTitleStyle,
    this.headerSubtitleStyle,
    this.topRightRadius = 5,
    this.bottomRightRadius = 5,
    this.headerPadding,
    this.itemPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(topRightRadius),
        bottomRight: Radius.circular(bottomRightRadius),
      ),
      child: Drawer(
        backgroundColor: itemBackgroundColor ?? theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            _buildHeader(theme),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: items.map((item) {
                  // If custom widget is provided → use it
                  if (item.customBuilder != null) {
                    return item.customBuilder!(context);
                  }

                  // Default item UI
                  return Container(
                    margin: item.margin,
                    decoration: BoxDecoration(
                      color: item.itemBackgroundColor,
                      borderRadius: item.borderRadius,
                    ),
                    child: ListTile(
                      contentPadding: itemPadding ??
                          const EdgeInsets.symmetric(horizontal: 16),
                      leading: Icon(
                        item.icon,
                        color: item.iconColor ?? theme.colorScheme.primary,
                      ),
                      title: Text(
                        item.title,
                        style: item.titleStyle ??
                            theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      subtitle: item.subtitle != null
                          ? Text(
                              item.subtitle!,
                              style: item.subtitleStyle ??
                                  theme.textTheme.bodySmall,
                            )
                          : null,
                      onTap: item.onTap,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Drawer header
  Widget _buildHeader(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: headerPadding ?? const EdgeInsets.fromLTRB(20, 48, 20, 20),
      decoration: BoxDecoration(
        color: headerBackgroundColor ?? theme.colorScheme.primary,
      ),
      child: Row(
        children: [
          if (headerIcon != null) ...[
            headerIcon!,
            const SizedBox(width: 12),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headerTitle,
                style: headerTitleStyle ??
                    theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (headerSubtitle != null)
                Text(
                  headerSubtitle!,
                  style: headerSubtitleStyle ??
                      theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ---------------------------
/// Drawer item
/// ---------------------------
class DrawerItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  // Optional customization
  final Color? iconColor;
  final Color? itemBackgroundColor;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  /// Optional fully custom widget for this item
  final Widget Function(BuildContext context)? customBuilder;

  const DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.iconColor,
    this.itemBackgroundColor,
    this.margin,
    this.borderRadius,
    this.titleStyle,
    this.subtitleStyle,
    this.customBuilder,
  });
}
