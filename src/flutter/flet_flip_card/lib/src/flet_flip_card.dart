// Flet Flip Card widget sarmalayıcı.

import 'dart:async';

import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class FletFlipCardControl extends StatefulWidget {
  final Control? parent;
  final Control control;
  final List<Control> children;
  final FletControlBackend backend;

  const FletFlipCardControl({
    super.key,
    required this.parent,
    required this.control,
    required this.children,
    required this.backend,
  });

  @override
  State<FletFlipCardControl> createState() => _FletFlipCardControlState();
}

class _FletFlipCardControlState extends State<FletFlipCardControl> {
  final GlobalKey<FlipCardState> _flipKey = GlobalKey<FlipCardState>();

  Timer? _autoTimer;
  bool _showingFront = true;

  String get _cid => widget.control.id;

  @override
  void initState() {
    super.initState();

    final initialSide =
        (widget.control.attrString("initialSide", "front") ?? "front")
            .toLowerCase();
    _showingFront = initialSide != "back";

    // Python -> Flutter method handler
    widget.backend.registerMethodHandler(_cid, _onMethodCall);

    // Otomatik flip
    final autoMs = widget.control.attrInt("autoFlipIntervalMs");
    if (autoMs != null && autoMs > 0) {
      _autoTimer = Timer.periodic(Duration(milliseconds: autoMs), (_) {
        _toggle();
      });
    }
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    widget.backend.unregisterMethodHandler(_cid);
    super.dispose();
  }

  Future<Object?> _onMethodCall(
      String method, Map<String, Object?> args) async {
    switch (method) {
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
      _triggerFlippedEvent();
    }
  }

  void _showFront() {
    final st = _flipKey.currentState;
    if (st != null && !_showingFront) {
      st.toggleCard();
      _showingFront = true;
      _triggerFlippedEvent();
    }
  }

  void _showBack() {
    final st = _flipKey.currentState;
    if (st != null && _showingFront) {
      st.toggleCard();
      _showingFront = false;
      _triggerFlippedEvent();
    }
  }

  void _triggerFlippedEvent() {
    widget.backend.triggerControlEvent(
      widget.control.id,
      "flipped",
      value: _showingFront ? "front" : "back",
    );
  }

  @override
  Widget build(BuildContext context) {
    final dirStr =
        (widget.control.attrString("direction", "horizontal") ?? "horizontal")
            .toLowerCase();
    final flipOnTouch = widget.control.attrBool("flipOnTouch", false) ?? false;

    // front/back çocukları
    final Control? frontCtrl = widget.children
        .where((c) => c.name == "front" && c.isVisible)
        .cast<Control?>()
        .firstWhere((_) => true, orElse: () => null);

    final Control? backCtrl = widget.children
        .where((c) => c.name == "back" && c.isVisible)
        .cast<Control?>()
        .firstWhere((_) => true, orElse: () => null);

    Widget buildChild(Control? child) {
      if (child == null) return const SizedBox.shrink();
      final w = widget.backend.buildControl(
        context: context,
        control: child,
        parent: widget.control,
      );
      return w ?? const SizedBox.shrink();
    }

    final frontWidget = buildChild(frontCtrl);
    final backWidget = buildChild(backCtrl);

    // flip_card yön enumu (BÜYÜK harf)
    final direction =
        dirStr == "vertical" ? FlipDirection.VERTICAL : FlipDirection.HORIZONTAL;

    final onFlip = () {
      _showingFront = !_showingFront;
      _triggerFlippedEvent();
    };

    Widget card = FlipCard(
      key: _flipKey,
      direction: direction,
      onFlip: onFlip,
      front: AbsorbPointer(absorbing: !flipOnTouch, child: frontWidget),
      back: AbsorbPointer(absorbing: !flipOnTouch, child: backWidget),
      speed: 400,
    );

    // initialSide "back" ise ilk frame'de çevir
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_showingFront && mounted) {
        final st = _flipKey.currentState;
        if (st != null) {
          st.toggleCard();
        }
      }
    });

    return constrainedControl(context, card, widget.parent, widget.control);
  }
}
