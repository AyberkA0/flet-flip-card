import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart' as fc;

class FlipCardControl extends StatefulWidget {
  final Control control;

  const FlipCardControl({super.key, required this.control});

  @override
  State<FlipCardControl> createState() => _FlipCardControlState();
}

class _FlipCardControlState extends State<FlipCardControl> {
  final GlobalKey<fc.FlipCardState> _flipKey = GlobalKey<fc.FlipCardState>();

  @override
  void initState() {
    super.initState();
    widget.control.addInvokeMethodListener(_invokeMethod);
  }

  @override
  void dispose() {
    widget.control.removeInvokeMethodListener(_invokeMethod);
    super.dispose();
  }

  Future<dynamic> _invokeMethod(String name, dynamic args) async {
    switch (name) {
      case "flip":
        _flipKey.currentState?.toggleCard();
        return null;
      default:
        throw Exception("Unknown FlipCard method: $name");
    }
  }

  @override
  Widget build(BuildContext context) {
    final direction =
        widget.control.getString("direction", "horizontal") == "vertical"
            ? fc.FlipDirection.VERTICAL
            : fc.FlipDirection.HORIZONTAL;

    final speed = widget.control.getDouble("duration", 500)!.round();

    final initialSide =
        widget.control.getString("initial_side", "front") == "back"
            ? fc.CardSide.BACK
            : fc.CardSide.FRONT;

    final card = fc.FlipCard(
      key: _flipKey,
      direction: direction,
      flipOnTouch: false,
      speed: speed,
      side: initialSide,
      onFlipDone: (isFront) {
        final newSide = isFront ? "front" : "back";
        if (widget.control.hasEventHandler("flip_done")) {
          widget.control.triggerEvent("flip_done", newSide);
        }
      },
      front: widget.control.buildWidget("front") ?? const SizedBox.shrink(),
      back: widget.control.buildWidget("back") ?? const SizedBox.shrink(),
    );

    return LayoutControl(control: widget.control, child: card);
  }
}
