import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_component/core/core.dart';

class SplashPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final Widget nextPage;

  final IconData? icon;
  final String? assetImage;

  const SplashPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.nextPage,
    this.icon,
    this.assetImage,
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
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              _buildIconOrImage(),
              const SizedBox(height: 20),
              AppText.headingWidget(
                text: widget.title,
                alignment: Alignment.center,
                size: 34,
              ),
              const SizedBox(height: 12),
              AppText.labelWidget(
                text: widget.subtitle,
                size: 13,
                color: AppColors.gray400,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconOrImage() {
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
      color: AppColors.primary,
    );
  }
}
