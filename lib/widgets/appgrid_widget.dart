import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppGridView<T> extends StatelessWidget {
  const AppGridView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.onTap,
    this.selectedItem,
    this.crossAxisCount = 2,
    this.selectedColor,
    this.unselectedColor,
    this.borderRadius = 12,
    this.borderWidth = 1,
    this.borderColor,
    this.iconBuilder,
  });

  final List<T> items;
  final T? selectedItem;
  final int crossAxisCount;
  final Widget Function(BuildContext, T) itemBuilder;
  final ValueChanged<T>? onTap;
  final IconData Function(T)? iconBuilder;

  final Color? selectedColor;
  final Color? unselectedColor;
  final double borderRadius;
  final double borderWidth;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isSelected = item == selectedItem;

        return InkWell(
          onTap: onTap == null ? null : () => onTap!(item),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? selectedColor ?? theme.colorScheme.primary.withOpacity(.1)
                  : unselectedColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                width: borderWidth,
                color: borderColor ??
                    (isSelected
                        ? theme.colorScheme.primary
                        : theme.dividerColor),
              ),
            ),
            child: Stack(
              children: [
                Center(child: itemBuilder(context, item)),
                if (iconBuilder != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(iconBuilder!(item), size: 18),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
