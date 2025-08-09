import 'dart:async';
import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class FletFlipCardControl extends StatefulWidget {
  final Control? parent;
  final Control control;
  final List<Control> children;
  final bool parentDisabled;
  final bool? parentAdaptive;
  final FletControlBackend backend;

  const FletFlipCardControl({
    super.key,
    required this.parent,
    required this.control,
    required this.children,
    required this.parentDisabled,
    required this.parentAdaptive,
    required this.backend,
  });

  @override
  State<FletFlipCardControl> createState() => _FletFlipCardControlState();
}

class _FletFlipCardControlState extends State<FletFlipCardControl> {
  final GlobalKey<FlipCardState> _flipKey = GlobalKey<FlipCardState>();
  late bool _showingFront;

  @override
  void initState() {
    super.initState();

    final String? initialSide =
        widget.control.attrString("initialSide", "front");
    _showingFront = initialSide != "back";

    widget.backend.subscribeMethods(widget.control.id, _onMethodCall);
  }

  @override
  void dispose() {
    widget.backend.unsubscribeMethods(widget.control.id);
    super.dispose();
  }

  Future<String?> _onMethodCall(
      String methodName, Map<String, String> args) async {
    switch (methodName) {
      case "flip":
        _toggle();
        break;
      case "show_front":
        _showFront();
        break;
      case "show_back":
        _showBack();
        break;
    }
    return null;
  }

  void _toggle() {
    final st = _flipKey.currentState;
    if (st != null) {
      st.toggleCard();
      _showingFront = !_showingFront;
    }
  }

  void _showBack() {
    final st = _flipKey.currentState;
    if (st != null && _showingFront) {
      st.toggleCard();
      _showingFront = false;
    }
  }

  void _showFront() {
    final st = _flipKey.currentState;
    if (st != null && !_showingFront) {
      st.toggleCard();
      _showingFront = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final frontCtrl =
        widget.children.where((c) => c.name == "front" && c.isVisible);
    final backCtrl =
        widget.children.where((c) => c.name == "back" && c.isVisible);

    final bool disabled = widget.control.isDisabled || widget.parentDisabled;
    final bool? adaptive =
        widget.control.attrBool("adaptive") ?? widget.parentAdaptive;

    Widget front = const SizedBox.shrink();
    if (frontCtrl.isNotEmpty) {
      front = createControl(
        widget.control,
        frontCtrl.first.id,
        disabled,
        parentAdaptive: adaptive,
      )!;
    }

    Widget back = const SizedBox.shrink();
    if (backCtrl.isNotEmpty) {
      back = createControl(
        widget.control,
        backCtrl.first.id,
        disabled,
        parentAdaptive: adaptive,
      )!;
    }

    final String? dirStr =
        widget.control.attrString("direction", "horizontal");
    final FlipDirection direction =
        dirStr == "vertical" ? FlipDirection.VERTICAL : FlipDirection.HORIZONTAL;

    final int speed = widget.control.attrInt("speed", 400) ?? 400;

    final String? initialSide =
        widget.control.attrString("initialSide", "front");
    final CardSide side =
        initialSide == "back" ? CardSide.BACK : CardSide.FRONT;

    final card = FlipCard(
      key: _flipKey,
      direction: direction,
      flipOnTouch: false,
      speed: speed,
      side: side,
      onFlipDone: (isFront) {
        _showingFront = isFront;
        if (widget.control.attrBool("hasOnFlipDone", false) ?? false) {
          widget.backend.triggerControlEvent(
            widget.control.id,
            "flip_done",
            isFront ? "front" : "back",
          );
        }
      },
      front: front,
      back: back,
    );

    return constrainedControl(context, card, widget.parent, widget.control);
  }
}
