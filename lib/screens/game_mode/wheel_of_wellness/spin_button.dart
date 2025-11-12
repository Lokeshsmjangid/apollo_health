/*
import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SpinButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isSpine;
  SpinButton({required this.onTap, required this.isSpine, Key? key}) : super(key: key);

  @override
  _SpinButtonState createState() => _SpinButtonState();
}

class _SpinButtonState extends State<SpinButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale; // Animation with tween

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant SpinButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSpine) {
      _controller.stop();  // Stop animation on tap
    } else {
      if (!_controller.isAnimating) {
        _controller.repeat(reverse: true);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) {
        return GestureDetector(
          onTap: widget.isSpine ? null : widget.onTap,
          child: Transform.scale(
            scale: widget.isSpine ? 1.0 : _scale.value,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: widget.isSpine
                    ? [] // No glow after tap
                    : [
                  BoxShadow(
                    color: AppColors.whiteColor.withOpacity(0.7),
                    blurRadius: 8,
                    spreadRadius: 2,
                    // offset: Offset(0.2, 0.3)
                  ),
                ],
              ),
              child: SvgPicture.asset(AppAssets.spinIndicatorImg),
            ),
          ),
        );
      },
    );
  }
}
*/


import 'package:apollo/resources/app_assets.dart';
import 'package:apollo/resources/app_color.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class SpinButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isSpine;
  SpinButton({required this.onTap, required this.isSpine, Key? key}) : super(key: key);

  @override
  _SpinButtonState createState() => _SpinButtonState();
}

class _SpinButtonState extends State<SpinButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant SpinButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSpine) {
      _controller.stop();  // Stop animation on tap
    } else {
      if (!_controller.isAnimating) {
        _controller.repeat(reverse: true);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) {
        return GestureDetector(
          onTap: widget.isSpine ? null : widget.onTap,
          child: Transform.scale(
            scale: widget.isSpine ? 1.0 : _scale.value,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // The bottom-only bright white shadow:
                boxShadow: widget.isSpine
                    ? []
                    : [
                  BoxShadow(
                    color: AppColors.whiteColor.withOpacity(0.91),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: Offset(0, 18), // Major bottom shadow!
                  ),
                ],
              ),
              child: SvgPicture.asset(AppAssets.spinIndicatorImg),
            ),
          ),
        );
      },
    );
  }
}
