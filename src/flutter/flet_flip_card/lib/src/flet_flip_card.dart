import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flet/flet_controls.dart';
import 'package:flet/flet.dart';

class FletFlipCardControl extends StatefulWidget {
  final Control? parent;
  final Control control;

  const FletFlipCardControl({super.key, required this.parent, required this.control});

  @override
  State<FletFlipCardControl> createState() => _FletFlipCardControlState();
}

class _FletFlipCardControlState extends State<FletFlipCardControl> {
  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    var direction = widget.control.attrString("direction", "horizontal") == "vertical"
        ? FlipDirection.VERTICAL
        : FlipDirection.HORIZONTAL;

    var initialSide = widget.control.attrString("initialSide", "front") == "back"
        ? CardSide.BACK
        : CardSide.FRONT;

    var frontCtrl = childControl(widget.control, "front");
    var backCtrl = childControl(widget.control, "back");

    var front = frontCtrl != null ? createControlWidget(context, frontCtrl, widget.parent)! : const SizedBox.shrink();
    var back = backCtrl != null ? createControlWidget(context, backCtrl, widget.parent)! : const SizedBox.shrink();

    return constrainedControl(
      context,
      FlipCard(
        key: cardKey,
        direction: direction,
        side: initialSide,
        front: front,
        back: back,
      ),
      widget.parent,
      widget.control,
    );
  }

  @override
  void didUpdateWidget(covariant FletFlipCardControl oldWidget) {
    super.didUpdateWidget(oldWidget);

    var events = widget.control.getAttrStringList("events");

    if (events.contains("flip")) {
      widget.control.onMethodCall("flip", (methodArgs) {
        cardKey.currentState?.toggleCard();
      });
    }

    if (events.contains("showFront")) {
      widget.control.onMethodCall("showFront", (methodArgs) {
        cardKey.currentState?.controller?.reset();
      });
    }

    if (events.contains("showBack")) {
      widget.control.onMethodCall("showBack", (methodArgs) {
        cardKey.currentState?.controller?.forward();
      });
    }
  }
}
