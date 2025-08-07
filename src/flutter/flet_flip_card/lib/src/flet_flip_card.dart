import 'dart:async';

import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class FletFlipCardControl extends StatefulWidget {
  final Control control;
  final Control? parent;

  const FletFlipCardControl({super.key, required this.control, this.parent});

  @override
  State<FletFlipCardControl> createState() => _FletFlipCardControlState();
}

class _FletFlipCardControlState extends State<FletFlipCardControl> {
  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _cardKey.currentState?.toggleCard();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final frontCtrl = widget.control.child("front");
    final backCtrl = widget.control.child("back");

    final front = frontCtrl != null
        ? createControlWidget(context, frontCtrl, widget.parent)!
        : const SizedBox.shrink();

    final back = backCtrl != null
        ? createControlWidget(context, backCtrl, widget.parent)!
        : const SizedBox.shrink();

    return FlipCard(
      key: _cardKey,
      flipOnTouch: false,
      direction: FlipDirection.HORIZONTAL,
      front: front,
      back: back,
    );
  }
}
