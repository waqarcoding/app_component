import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

enum ImageSourceType { network, asset, file }

/// All supported SpinKit animation types
enum SpinKitAnimationType {
  rotatingPlain,
  doubleBounce,
  wave,
  wanderingCubes,
  fadingFour,
  fadingCube,
  pulse,
  chasingDots,
  threeBounce,
  circle,
  cubeGrid,
  fadingCircle,
  rotatingCircle,
  foldingCube,
  pumpingHeart,
  hourGlass,
  pouringHourGlass,
  pouringHourGlassRefined,
  fadingGrid,
  ring,
  ripple,
  spinningCircle,
  spinningLines,
  squareCircle,
  dualRing,
  pianoWave,
  dancingSquare,
  threeInOut,
  waveSpinner,
  pulsingGrid,
}

/// Reusable Image Widget with placeholder animations
class ImageWidget extends StatefulWidget {
  final String path;
  final ImageSourceType sourceType;
  final double width;
  final double height;
  final BoxFit fit;
  final double borderRadius;
  final Color? backgroundColor;
  final Widget? errorWidget;

  // Placeholder options
  final bool isShimmer; // true = shimmer, false = spinkit
  final SpinKitAnimationType spinKitType;
  final Color? placeholderColor;
  final double placeholderSize;

  const ImageWidget({
    super.key,
    required this.path,
    this.sourceType = ImageSourceType.network,
    this.width = double.infinity,
    this.height = 200,
    this.fit = BoxFit.cover,
    this.borderRadius = 14,
    this.backgroundColor,
    this.errorWidget,
    this.isShimmer = false,
    this.spinKitType = SpinKitAnimationType.doubleBounce,
    this.placeholderColor,
    this.placeholderSize = 40,
  });

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  bool _loaded = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Container(
        width: widget.width,
        height: widget.height,
        color: widget.backgroundColor ?? Colors.grey[200],
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildImage(),
            if (!_loaded) _buildPlaceholder(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    switch (widget.sourceType) {
      case ImageSourceType.network:
        return Image.network(
          widget.path,
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (!_loaded && (wasSynchronouslyLoaded || frame != null)) {
              // Schedule setState after build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() => _loaded = true);
              });
            }
            return child;
          },
          errorBuilder: (context, error, stackTrace) =>
              widget.errorWidget ?? _defaultError(),
        );
      case ImageSourceType.asset:
        return Image.asset(
          widget.path,
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
          errorBuilder: (context, error, stackTrace) =>
              widget.errorWidget ?? _defaultError(),
        );
      case ImageSourceType.file:
        return Image.file(
          File(widget.path),
          fit: widget.fit,
          width: widget.width,
          height: widget.height,
          errorBuilder: (context, error, stackTrace) =>
              widget.errorWidget ?? _defaultError(),
        );
    }
  }

  Widget _defaultError() => const Center(
        child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
      );

  Widget _buildPlaceholder(BuildContext context) {
    if (widget.isShimmer) {
      return Shimmer.fromColors(
        baseColor: widget.placeholderColor ?? Colors.grey[300]!,
        highlightColor:
            (widget.placeholderColor ?? Colors.grey[300]!).withOpacity(0.5),
        child: Container(color: widget.placeholderColor ?? Colors.grey[300]),
      );
    } else {
      final color =
          widget.placeholderColor ?? Theme.of(context).colorScheme.primary;
      switch (widget.spinKitType) {
        case SpinKitAnimationType.rotatingPlain:
          return Center(
              child: SpinKitRotatingPlain(
                  color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.doubleBounce:
          return Center(
              child: SpinKitDoubleBounce(
                  color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.wave:
          return Center(
              child: SpinKitWave(color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.wanderingCubes:
          return Center(
              child: SpinKitWanderingCubes(
                  color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.fadingFour:
          return Center(
              child: SpinKitFadingFour(
                  color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.fadingCube:
          return Center(
              child: SpinKitFadingCube(
                  color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.pulse:
          return Center(
              child: SpinKitPulse(color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.chasingDots:
          return Center(
              child: SpinKitChasingDots(
                  color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.threeBounce:
          return Center(
              child: SpinKitThreeBounce(
                  color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.circle:
          return Center(
              child: SpinKitCircle(color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.cubeGrid:
          return Center(
              child:
                  SpinKitCubeGrid(color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.fadingCircle:
          return Center(
              child: SpinKitFadingCircle(
                  color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.rotatingCircle:
          return Center(
              child: SpinKitRotatingCircle(
                  color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.foldingCube:
          return Center(
              child: SpinKitFoldingCube(
                  color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.pumpingHeart:
          return Center(
              child: SpinKitPumpingHeart(
                  color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.hourGlass:
          return Center(
              child:
                  SpinKitHourGlass(color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.pouringHourGlass:
          return Center(
              child: SpinKitPouringHourGlass(
                  color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.pouringHourGlassRefined:
          return Center(
              child: SpinKitPouringHourGlassRefined(
                  color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.fadingGrid:
          return Center(
              child: SpinKitFadingGrid(
                  color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.ring:
          return Center(
              child: SpinKitRing(color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.ripple:
          return Center(
              child: SpinKitRipple(color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.spinningCircle:
          return Center(
              child: SpinKitSpinningCircle(
                  color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.spinningLines:
          return Center(
              child: SpinKitSpinningLines(
                  color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.squareCircle:
          return Center(
              child: SpinKitSquareCircle(
                  color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.dualRing:
          return Center(
              child:
                  SpinKitDualRing(color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.pianoWave:
          return Center(
              child:
                  SpinKitPianoWave(color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.dancingSquare:
          return Center(
              child: SpinKitDancingSquare(
                  color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.threeInOut:
          return Center(
              child: SpinKitThreeInOut(
                  color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.waveSpinner:
          return Center(
              child: SpinKitWaveSpinner(
                  color: color, size: widget.placeholderSize));
        case SpinKitAnimationType.pulsingGrid:
          return Center(
              child: SpinKitPulsingGrid(
                  color: color, size: widget.placeholderSize));
      }
    }
  }
}
