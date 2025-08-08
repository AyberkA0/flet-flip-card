import 'dart:math' as math;
import 'package:flet/flet.dart';
import 'package:flutter/material.dart';

// Basit FlipCardControl
class FletFlipCardControl extends StatefulWidget {
  final Control? parent;
  final Control control;
  final List<Control> children;

  const FletFlipCardControl({
    super.key,
    required this.parent,
    required this.control,
    required this.children,
  });

  @override
  State<FletFlipCardControl> createState() => _FletFlipCardControlState();
}

class _FletFlipCardControlState
    extends State<FletFlipCardControl>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final front = widget.children
        .where((c) => c.name == 'front')
        .map((c) => createControl(widget.control, c.id, false))
        .firstOrNull;
    final back = widget.children
        .where((c) => c.name == 'back')
        .map((c) => createControl(widget.control, c.id, false))
        .firstOrNull;

    final animation = Tween<double>(begin: 0, end: math.pi / 2).animate(_controller);

    return constrainedControl(
      context,
      AnimatedBuilder(
        animation: animation,
        builder: (_, __) {
          final angle = animation.value;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(angle),
            child: angle < math.pi / 4 ? front ?? SizedBox() : back ?? SizedBox(),
          );
        },
      ),
      widget.parent,
      widget.control,
    );
  }
}
