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

    widget.control.addInvokeMethodListener(_handleMethod);
  }

  Future<void> _handleMethod(String name, dynamic args) async {
    switch (name) {
      case "flip":
        cardKey.currentState?.toggleCard();
        break;
      case "showFront":
        if (cardKey.currentState?.isFront == false) {
          cardKey.currentState?.toggleCard();
        }
        break;
      case "showBack":
        if (cardKey.currentState?.isFront == true) {
          cardKey.currentState?.toggleCard();
        }
        break;
      default:
        throw Exception("Unknown method: $name");
    }
  }

  @override
  void dispose() {
    widget.control.removeInvokeMethodListener(_handleMethod);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FlipDirection direction =
        widget.control.attrString("direction", "horizontal") == "vertical"
            ? FlipDirection.VERTICAL
            : FlipDirection.HORIZONTAL;
    final bool showFront = widget.control.attrString("initialSide", "front") == "front";

    final frontCtrl = widget.control.child("front");
    final backCtrl = widget.control.child("back");

    final front = frontCtrl != null
        ? createControlWidget(context, frontCtrl, widget.parent)!
        : const SizedBox.shrink();
    final back = backCtrl != null
        ? createControlWidget(context, backCtrl, widget.parent)!
        : const SizedBox.shrink();

    return constrainedControl(
      context,
      FlipCard(
        key: cardKey,
        direction: direction,
        side: showFront ? CardSide.FRONT : CardSide.BACK,
        front: front,
        back: back,
      ),
      widget.parent,
      widget.control,
    );
  }
}
