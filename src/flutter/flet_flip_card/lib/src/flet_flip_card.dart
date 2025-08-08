import 'dart:async';
import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class FletFlipCard extends StatefulWidget {
  final Control control;
  final Control? parent;
  final List<Control> children;
  final FletControlBackend backend;

  const FletFlipCard({
    super.key,
    required this.control,
    required this.parent,
    required this.children,
    required this.backend,
  });

  @override
  State<FletFlipCard> createState() => _FletFlipCardState();
}

class _FletFlipCardState extends State<FletFlipCard> {
  late final String _cid;
  late final bool _flipOnTouch;
  late final FlipDirection _flipDirection;
  late bool _showingFront;
  Timer? _autoFlipTimer;

  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();

  @override
  void initState() {
    super.initState();
    widget.control.methodCallHandler = _onMethodCall;
  }

  @override
  void dispose() {
    widget.control.methodCallHandler = null;
    super.dispose();
  }

  Future<String?> _onMethodCall(String method, Map<String, dynamic> params) async {
    switch (method) {
      case "flip":
        _cardKey.currentState?.toggleCard();
        break;
      case "show_front":
        if (!_showingFront) _cardKey.currentState?.toggleCard();
        break;
      case "show_back":
        if (_showingFront) _cardKey.currentState?.toggleCard();
        break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Widget? front = widget.children
        .where((c) => c.name == "front")
        .map((c) => ControlHost(
              control: c,
              parent: widget.control,
              backend: widget.backend,
            ))
        .firstOrNull;

    Widget? back = widget.children
        .where((c) => c.name == "back")
        .map((c) => ControlHost(
              control: c,
              parent: widget.control,
              backend: widget.backend,
            ))
        .firstOrNull;

    return constrainedControl(
      context,
      FlipCard(
        key: _cardKey,
        flipOnTouch: _flipOnTouch,
        direction: _flipDirection,
        fill: Fill.fillBack,
        onFlipDone: (isFront) {
          _showingFront = isFront;
          if (widget.control.attrBool("on_flipped", false) ?? false) {
            widget.backend.triggerControlEvent(
              _cid,
              "flipped",
              _showingFront ? "front" : "back",
            );
          }
        },
        front: front ?? const SizedBox.shrink(),
        back: back ?? const SizedBox.shrink(),
      ),
      widget.parent,
      widget.control,
    );
  }
}
