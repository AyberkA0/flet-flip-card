import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flet/flet.dart';

class FletFlipCardControl extends StatelessWidget {
  final Control? parent;
  final Control control;

  const FletFlipCardControl({
    super.key,
    required this.parent,
    required this.control,
  });

  @override
  Widget build(BuildContext context) {
    var directionStr = control.attrString("direction", "horizontal")!.toLowerCase();
    var direction = directionStr == "vertical" ? FlipDirection.VERTICAL : FlipDirection.HORIZONTAL;

    Widget front = SizedBox.shrink();
    Widget back = SizedBox.shrink();

    var frontCtrl = control.children.where((c) => c.name == "front").toList();
    var backCtrl = control.children.where((c) => c.name == "back").toList();

    if (frontCtrl.isNotEmpty) front = childControl(context, frontCtrl.first, parent);
    if (backCtrl.isNotEmpty) back = childControl(context, backCtrl.first, parent);

    Widget flipCard = FlipCard(
      direction: direction,
      front: front,
      back: back,
    );

    return constrainedControl(context, flipCard, parent, control);
  }
}
