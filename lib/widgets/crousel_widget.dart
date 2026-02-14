import 'dart:async';
import 'package:flutter/material.dart';

enum CarouselScrollMode {
  standard,
  cardStack,
  centerZoom,
  parallax,
  carousel3D,
}

enum CarouselIndicatorType {
  dot,
  line,
  oval,
  none,
}

class CarouselWidget extends StatefulWidget {
  final List<Widget> items;
  final double height;
  final bool autoScroll;
  final Duration autoScrollInterval;
  final double itemSpacing;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final CarouselScrollMode scrollMode;

  // Indicator
  final CarouselIndicatorType indicatorType;
  final bool showIndicator;
  final Widget Function(int index, bool isActive)? indicatorBuilder;
  final double indicatorSpacing;
  final double indicatorWidthFactor;
  final double? indicatorHeight;
  final double dotSize;
  final double? indicatorOvalBorder;

  const CarouselWidget({
    super.key,
    required this.items,
    this.height = 220,
    this.autoScroll = true,
    this.autoScrollInterval = const Duration(seconds: 3),
    this.itemSpacing = 5,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.borderRadius = 16,
    this.borderWidth = 0,
    this.borderColor = Colors.transparent,
    this.scrollMode = CarouselScrollMode.standard,
    this.indicatorType = CarouselIndicatorType.dot,
    this.showIndicator = true,
    this.indicatorBuilder,
    this.indicatorSpacing = 6,
    this.indicatorWidthFactor = 0.6,
    this.indicatorHeight = 4,
    this.dotSize = 8,
    this.indicatorOvalBorder,
  });

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  late final PageController _pageController;
  Timer? _autoTimer;

  // Use large virtual count for infinite loop
  late final int _virtualItemCount;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _virtualItemCount = widget.items.length * 100000;
    final initialPage = _virtualItemCount ~/ 2;
    _currentIndex = initialPage % widget.items.length;

    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: initialPage,
    );

    if (widget.autoScroll) {
      _autoTimer =
          Timer.periodic(widget.autoScrollInterval, (_) => _nextPage());
    }
  }

  void _nextPage() {
    if (_pageController.hasClients && widget.items.isNotEmpty) {
      final nextPage = _pageController.page!.toInt() + 1;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
      setState(() => _currentIndex = nextPage % widget.items.length);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: SizedBox(
        height: widget.height + (widget.showIndicator ? 25 : 0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemBuilder: (context, index) {
                  final realIndex = index % widget.items.length;
                  return _buildAnimatedItem(context, realIndex, index);
                },
              ),
            ),
            if (widget.showIndicator) _buildIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedItem(
      BuildContext context, int realIndex, int virtualIndex) {
    final child = widget.items[realIndex];

    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, _) {
        double value = 1.0;
        if (_pageController.hasClients &&
            _pageController.position.haveDimensions) {
          value = ((_pageController.page ?? _pageController.initialPage)
                  .toDouble()) -
              virtualIndex;
        }

        // scale & transform
        double scale = 1.0;
        Matrix4 transform = Matrix4.identity();
        double opacity = 1.0;

        switch (widget.scrollMode) {
          case CarouselScrollMode.standard:
            scale = 1 - (value.abs() * 0.15);
            opacity = (1 - value.abs()).clamp(0.5, 1.0);
            break;

          case CarouselScrollMode.cardStack:
            scale = 1 - (value.abs() * 0.18);
            transform = Matrix4.identity()
              ..translate(value * -20)
              ..scale(scale);
            opacity = (1 - value.abs()).clamp(0.4, 1.0);
            break;

          case CarouselScrollMode.centerZoom:
            scale = (1 - (value.abs() * 0.3)).clamp(0.7, 1.0);
            opacity = (1 - value.abs()).clamp(0.5, 1.0);
            break;

          case CarouselScrollMode.parallax:
            transform = Matrix4.identity()
              ..translate(value * 50); // slower horizontal offset
            scale = 1 - (value.abs() * 0.1);
            opacity = (1 - value.abs()).clamp(0.7, 1.0);
            break;

          case CarouselScrollMode.carousel3D:
            transform = Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(value * 0.25);
            scale = 0.9 + (0.1 * (1 - value.abs()));
            opacity = (1 - value.abs()).clamp(0.5, 1.0);
            break;
        }

        return Transform(
          alignment: Alignment.center,
          transform: transform,
          child: Opacity(
            opacity: opacity,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: widget.itemSpacing / 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  color: widget.borderColor,
                  width: widget.borderWidth,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: Transform.scale(
                  scale: scale,
                  child: child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.items.length, (index) {
        final active = index == _currentIndex;

        // Use custom builder if provided
        if (widget.indicatorBuilder != null) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.indicatorSpacing),
            child: widget.indicatorBuilder!(index, active),
          );
        }

        final color = Theme.of(context).colorScheme.primary;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.indicatorSpacing),
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: _buildDefaultIndicator(active, color),
          ),
        );
      }),
    );
  }

  Widget _buildDefaultIndicator(bool active, Color color) {
    switch (widget.indicatorType) {
      case CarouselIndicatorType.dot:
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: active ? widget.dotSize * 1.5 : widget.dotSize,
          height: widget.dotSize,
          decoration: BoxDecoration(
            color: active ? color : Colors.grey,
            borderRadius: BorderRadius.circular(widget.dotSize / 2),
          ),
        );

      case CarouselIndicatorType.line:
        return Container(
          width: 40 * widget.indicatorWidthFactor,
          height: widget.indicatorHeight ?? 4,
          decoration: BoxDecoration(
            color: active ? color : Colors.grey,
            borderRadius:
                BorderRadius.circular((widget.indicatorHeight ?? 4) / 2),
          ),
        );

      case CarouselIndicatorType.oval:
        return Container(
          width: 24,
          height: widget.indicatorHeight ?? 4,
          decoration: BoxDecoration(
            color: active ? color : Colors.grey,
            borderRadius: BorderRadius.circular(
                widget.indicatorOvalBorder ?? widget.borderRadius),
          ),
        );

      case CarouselIndicatorType.none:
        return const SizedBox.shrink();
    }
  }
}
