import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
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
  void initState() {
    super.initState();
    widget.control.addEventListener(_handleEvent);
  }

  @override
  void dispose() {
    widget.control.removeEventListener(_handleEvent);
    super.dispose();
  }

  void _handleEvent(String eventName, String eventData) {
    switch (eventName) {
      case "flip":
        cardKey.currentState?.toggleCard();
        break;
      case "showFront":
        cardKey.currentState?.controller?.skewBack();
        break;
      case "showBack":
        cardKey.currentState?.controller?.skewFront();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var direction = widget.control.attrString("direction", "horizontal") == "vertical"
        ? FlipDirection.VERTICAL
        : FlipDirection.HORIZONTAL;

    var initialSide = widget.control.attrString("initialSide", "front") == "back"
        ? CardSide.BACK
        : CardSide.FRONT;

    var frontCtrl = widget.control.child("front");
    var backCtrl = widget.control.child("back");

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
}