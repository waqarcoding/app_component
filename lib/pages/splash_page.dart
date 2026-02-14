import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final Widget nextPage;

  // Icon or image
  final IconData? icon;
  final Color? iconColor;
  final String? assetImage;

  // Optional styles
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  // Optional background
  final Color? backgroundColor;

  const SplashPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.nextPage,
    this.icon,
    this.iconColor,
    this.assetImage,
    this.titleStyle,
    this.subtitleStyle,
    this.backgroundColor,
  }) : assert(
          icon != null || assetImage != null,
          'Either icon or assetImage must be provided',
        );

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _slideAnimation = Tween<double>(begin: 20, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? _buildSplashContent() : widget.nextPage;
  }

  Widget _buildSplashContent() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: widget.backgroundColor ?? theme.scaffoldBackgroundColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIconOrImage(colorScheme),
              const SizedBox(height: 20),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: widget.titleStyle ??
                    GoogleFonts.poppins(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.subtitle,
                textAlign: TextAlign.center,
                style: widget.subtitleStyle ??
                    GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconOrImage(ColorScheme colorScheme) {
    if (widget.assetImage != null) {
      return Image.asset(
        widget.assetImage!,
        width: 90,
        height: 90,
      );
    }

    return Icon(
      widget.icon,
      size: 90,
      color: widget.iconColor ?? colorScheme.primary,
    );
  }
}
