import 'package:flutter/material.dart';

class GestureBounce extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPress;

  const GestureBounce({
    required this.child, Key? key, 
    required this.onPress
  }) : super(key: key);

  @override
  GestureBounceState createState() => GestureBounceState();
}

class GestureBounceState extends State<GestureBounce> with SingleTickerProviderStateMixin {
  Animation<double>? scale;
  AnimationController? controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    scale = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: controller!, curve: Curves.ease));
  }

  
  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails event) {
        controller!.forward();
      },
      onTapUp: (TapUpDetails event) {
        if (widget.onPress != null) {
          controller!.reverse();
          widget.onPress!();
        }
      },
      onTapCancel: () {
        controller!.reverse();
      },
      child: ScaleTransition(
        scale: scale!,
        child: widget.child,
      ),
    );
  }
}