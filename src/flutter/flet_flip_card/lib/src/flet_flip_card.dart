import 'dart:async';
import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

/// Flet 0.28.3 için: çocukları `control.buildWidget("front"/"back")` ile al.
/// Method çağrıları için `control.addInvokeMethodListener(...)` kullan.
class FletFlipCardControl extends StatefulWidget {
  final Control? parent;
  final Control control;

  const FletFlipCardControl({
    super.key,
    required this.parent,
    required this.control,
  });

  @override
  State<FletFlipCardControl> createState() => _FletFlipCardState();
}

class _FletFlipCardState extends State<FletFlipCardControl> {
  final GlobalKey<FlipCardState> _flipKey = GlobalKey<FlipCardState>();
  Timer? _autoTimer;
  bool _showingFront = true;

  @override
  void initState() {
    super.initState();

    // Başlangıç yüzü
    final initialSide = widget.control.getString("initial_side", "front")!;
    _showingFront = initialSide != "back";

    // Python -> Flutter method dinleyici
    widget.control.addInvokeMethodListener(_onInvokeMethod);

    // Otomatik flip
    final autoMs = widget.control.getInt("auto_flip_interval_ms");
    if (autoMs != null && autoMs > 0) {
      _autoTimer = Timer.periodic(Duration(milliseconds: autoMs), (_) {
        _toggle();
      });
    }

    // initial_side="back" ise ilk frame'de çevir
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_showingFront && mounted) {
        _flipKey.currentState?.toggleCard();
      }
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    widget.control.removeInvokeMethodListener(_onInvokeMethod);
    super.dispose();
  }

  Future<dynamic> _onInvokeMethod(String name, dynamic args) async {
    switch (name) {
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
      widget.control.triggerEvent("flipped", _showingFront ? "front" : "back");
    }
  }

  void _showFront() {
    final st = _flipKey.currentState;
    if (st != null && !_showingFront) {
      st.toggleCard();
      _showingFront = true;
      widget.control.triggerEvent("flipped", "front");
    }
  }

  void _showBack() {
    final st = _flipKey.currentState;
    if (st != null && _showingFront) {
      st.toggleCard();
      _showingFront = false;
      widget.control.triggerEvent("flipped", "back");
    }
  }

  @override
  Widget build(BuildContext context) {
    final dirStr = widget.control.getString("direction", "horizontal")!;
    final flipOnTouch = widget.control.getBool("flip_on_touch", false)!;

    // front/back widget'ları
    final frontWidget = widget.control.buildWidget("front") ?? const SizedBox.shrink();
    final backWidget = widget.control.buildWidget("back") ?? const SizedBox.shrink();

    final direction = dirStr.toLowerCase() == "vertical"
        ? FlipDirection.VERTICAL
        : FlipDirection.HORIZONTAL;

    final card = FlipCard(
      key: _flipKey,
      direction: direction,
      flipOnTouch: flipOnTouch,
      onFlipDone: (isFront) {
        _showingFront = isFront;
        widget.control.triggerEvent("flipped", isFront ? "front" : "back");
      },
      front: frontWidget,
      back: backWidget,
      speed: 400,
    );

    return constrainedControl(context, card, widget.parent, widget.control);
  }
}
