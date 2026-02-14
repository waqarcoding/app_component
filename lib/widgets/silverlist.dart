import 'package:flutter/material.dart';

/// 1️⃣ GradientMask - reusable ShaderMask for gradients or masking effects
class GradientMask extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final BlendMode blendMode;

  const GradientMask({
    super.key,
    required this.child,
    this.gradient = const LinearGradient(
      colors: [Colors.transparent, Colors.black],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    this.blendMode = BlendMode.srcIn,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      blendMode: blendMode,
      child: child,
    );
  }
}

/// 2️⃣ FractionalBox - reusable FractionallySizedBox
class FractionalBox extends StatelessWidget {
  final Widget child;
  final double? widthFactor;
  final double? heightFactor;
  final Alignment alignment;

  const FractionalBox({
    super.key,
    required this.child,
    this.widthFactor,
    this.heightFactor,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      alignment: alignment,
      child: child,
    );
  }
}

/// 3️⃣ SliverListGrid - reusable CustomScrollView with SliverList or SliverGrid
enum SliverType { list, grid }

class SliverListGrid<T> extends StatelessWidget {
  final SliverType type;
  final List<T> items;
  final Widget Function(BuildContext, int, T) itemBuilder;
  final int gridCrossAxisCount;
  final double gridMainAxisSpacing;
  final double gridCrossAxisSpacing;
  final double gridChildAspectRatio;
  final EdgeInsetsGeometry padding;

  // New border customization
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;

  const SliverListGrid.list({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.padding = EdgeInsets.zero,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.borderRadius = 8,
  })  : type = SliverType.list,
        gridCrossAxisCount = 1,
        gridMainAxisSpacing = 0,
        gridCrossAxisSpacing = 0,
        gridChildAspectRatio = 1;

  const SliverListGrid.grid({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.gridCrossAxisCount = 2,
    this.gridMainAxisSpacing = 8,
    this.gridCrossAxisSpacing = 8,
    this.gridChildAspectRatio = 1,
    this.padding = EdgeInsets.zero,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
    this.borderRadius = 8,
  }) : type = SliverType.grid;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (type == SliverType.list)
          SliverPadding(
            padding: padding,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildItem(context, index),
                childCount: items.length,
              ),
            ),
          ),
        if (type == SliverType.grid)
          SliverPadding(
            padding: padding,
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridCrossAxisCount,
                mainAxisSpacing: gridMainAxisSpacing,
                crossAxisSpacing: gridCrossAxisSpacing,
                childAspectRatio: gridChildAspectRatio,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildItem(context, index),
                childCount: items.length,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: itemBuilder(context, index, items[index]),
      ),
    );
  }
}
