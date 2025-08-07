import 'dart:async';
import 'dart:math' as math;

import 'package:flet/flet.dart';
import 'package:flutter/material.dart';

class FletFlipCardControl extends StatefulWidget {
  final Control? parent;
  final Control control;

  const FletFlipCardControl({super.key, required this.parent, required this.control});

  @override
  State<FletFlipCardControl> createState() => _FletFlipCardControlState();
}

class _FletFlipCardControlState extends State<FletFlipCardControl> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _autoTimer;
  bool _showFront = true;
  int _lastActionTs = -1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _applyAutoTimer(int? ms) {
    _autoTimer?.cancel();
    if (ms != null && ms > 0) {
      _autoTimer = Timer.periodic(Duration(milliseconds: ms), (_) => _flip());
    }
  }

  void _flip() {
    setState(() {
      _showFront = !_showFront;
    });
    if (_controller.isAnimating) return;
    if (_controller.value == 0 || _controller.status == AnimationStatus.dismissed) {
      _controller.forward(from: 0);
    } else {
      _controller.reverse(from: 1);
    }
  }

  void _show(bool front) {
    if (_showFront == front) return;
    _flip();
  }

  @override
  Widget build(BuildContext context) {
    final control = widget.control;

    final initialSide = control.attrString("initialSide", "front")!.toLowerCase();
    final flipDirection = control.attrString("flipDirection", "horizontal")!.toLowerCase();
    final autoFlipMs = control.attrInt("autoFlipMs");

    // initialize once depending on initialSide
    _showFront = initialSide != "back";
    _applyAutoTimer(autoFlipMs);

    final action = control.attrString("action");
    final actionTs = control.attrInt("actionTs") ?? -1;

    if (actionTs != _lastActionTs) {
      _lastActionTs = actionTs;
      switch (action) {
        case "flip":
          _flip();
          break;
        case "front":
          _show(true);
          break;
        case "back":
          _show(false);
          break;
      }
    }

    final frontCtrls = widget.children.where((c) => c.name == "front" && c.isVisible).toList();
    final backCtrls = widget.children.where((c) => c.name == "back" && c.isVisible).toList();

    Widget frontChild = frontCtrls.isNotEmpty
        ? createControl(frontCtrls.first, context, widget.backend, widget.pageStore, widget.theme)
        : const SizedBox.shrink();

    Widget backChild = backCtrls.isNotEmpty
        ? createControl(backCtrls.first, context, widget.backend, widget.pageStore, widget.theme)
        : const SizedBox.shrink();

    // flip animation
    final animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Widget card = AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final isHorizontal = flipDirection != "vertical";
        final angle = animation.value * math.pi;
        final isUnder = angle > math.pi / 2;

        Widget display = _showFront
            ? (isUnder
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(isHorizontal ? math.pi : 0)
                      ..rotateX(isHorizontal ? 0 : math.pi),
                    child: backChild,
                  )
                : frontChild)
            : (isUnder
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(isHorizontal ? math.pi : 0)
                      ..rotateX(isHorizontal ? 0 : math.pi),
                    child: frontChild,
                  )
                : backChild);

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(isHorizontal ? angle : 0)
            ..rotateX(isHorizontal ? 0 : angle),
          child: display,
        );
      },
    );

    return constrainedControl(context, card, widget.parent, widget.control);
  }
}