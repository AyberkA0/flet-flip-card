
import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class FletFlipCardControl extends StatelessWidget {
  final Control? parent;
  final Control control;

  const FletFlipCardControl({super.key, required this.parent, required this.control});

  @override
  Widget build(BuildContext context) {
    debugPrint("FletFlipCard build: \${control.id}");

    var frontCtrl = childControl(control, "front");
    var backCtrl = childControl(control, "back");

    var cardKey = GlobalKey<FlipCardState>();

    control.state["_cardKey"] = cardKey;

    var front = frontCtrl != null ? createControlWidget(context, frontCtrl, parent)! : const SizedBox.shrink();
    var back = backCtrl != null ? createControlWidget(context, backCtrl, parent)! : const SizedBox.shrink();

    FlipDirection direction = control.attrString("direction") == "VERTICAL"
        ? FlipDirection.VERTICAL
        : FlipDirection.HORIZONTAL;

    bool isInitiallyFlipped = control.attrBool("flipped", false)!;

    var flipCard = FlipCard(
      key: cardKey,
      direction: direction,
      flipOnTouch: control.attrBool("flipOnTouch", true)!,
      front: front,
      back: back,
    );

    return constrainedControl(context, flipCard, parent, control);
  }
}
