// Flet Extension Development Guide’a uygun, 0.28.3 uyumlu minimal wrapper.
// - Sadece front/back çocukları
// - Dokununca flip
// - Python->Dart method çağrıları: flip, show_front, show_back
// - Event tetikleme örneği: "flipped"

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
  bool _showingFront = true;

  @override
  void initState() {
    super.initState();
    // Python->Dart method kayıt (Guide: subscribeMethods/unsubscribeMethods)
    widget.backend.subscribeMethods(widget.control.id, _onMethodCall);
  }

  @override
  void dispose() {
    widget.backend.unsubscribeMethods(widget.control.id);
    super.dispose();
  }

  // Guide: Method handler imzası
  Future<String?> _onMethodCall(String methodName, Map<String, String> args) async {
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
    }
  }

  void _showFront() {
    final st = _flipKey.currentState;
    if (st != null && !_showingFront) {
      st.toggleCard();
    }
  }

  void _showBack() {
    final st = _flipKey.currentState;
    if (st != null && _showingFront) {
      st.toggleCard();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Çocukları isimle bul (Guide: children + createControl)
    final frontCtrl = widget.children.where((c) => c.name == "front" && c.isVisible);
    final backCtrl = widget.children.where((c) => c.name == "back" && c.isVisible);

    final bool disabled = widget.control.isDisabled || widget.parentDisabled;
    final bool? adaptive = widget.control.attrBool("adaptive") ?? widget.parentAdaptive;

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

    final card = FlipCard(
      key: _flipKey,
      direction: FlipDirection.HORIZONTAL,
      flipOnTouch: true,
      speed: 400,
      onFlipDone: (isFront) {
        _showingFront = isFront;
        // Guide: triggerControlEvent(controlId, eventName, data)
        widget.backend.triggerControlEvent(
          widget.control.id,
          "flipped",
          isFront ? "front" : "back",
        );
      },
      front: front,
      back: back,
    );

    // Guide: constrainedControl ile sarmala
    return constrainedControl(context, card, widget.parent, widget.control);
  }
}
