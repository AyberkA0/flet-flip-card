// Flet Flip Card widget sarmalayıcı.
// - front/back adlı çocukları alır.
// - yöntem çağrıları: flip, show_front, show_back
// - otomatik periyodik flip (Timer.periodic)
// - dokununca flip (flip_on_touch)
// - constrainedControl ile boyutlandırma
//
// Not: Bu dosya Flet 0.28.3+ uzantı API'lerine göre yazılmıştır.

import 'dart:async';

import 'package:flet/flet.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class FletFlipCardControl extends StatefulWidget {
  final Control? parent;
  final Control control;

  // Flet createControl args'tan gelir
  final List<Control> children;

  // Backend'e method handler ve event tetiklemek için ihtiyaç var
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

  // Method call handler id (kontrol id'si zaten unique)
  String get _cid => widget.control.id;

  @override
  void initState() {
    super.initState();

    // Başlangıç yüzünü oku
    final initialSide =
        (widget.control.attrString("initialSide", "front") ?? "front")
            .toLowerCase();
    _showingFront = initialSide != "back";

    // Python -> Flutter method handler
    widget.backend.addMethodCallHandler(_cid, _onMethodCall);

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
    widget.backend.removeMethodCallHandler(_cid);
    super.dispose();
  }

  Future<Object?> _onMethodCall(String method, Map<String, Object?> args) async {
    switch (method) {
      case "flip":
        _toggle();
        return null;
      case "show_front":
        _showFront();
        return null;
      case "show_back":
        _showBack();
        return null;
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
    // İsteğe bağlı geri bildirim (temel akışa bağımlı değil)
    widget.backend.triggerControlEvent(
      widget.control.id,
      "flipped",
      data: _showingFront ? "front" : "back",
    );
  }

  @override
  Widget build(BuildContext context) {
    final dirStr =
        (widget.control.attrString("direction", "horizontal") ?? "horizontal")
            .toLowerCase();
    final flipOnTouch = widget.control.attrBool("flipOnTouch", false) ?? false;

    // front/back çocuklarını ayıkla
    final frontCtrl = widget.children
        .where((c) => c.name == "front" && c.isVisible)
        .cast<Control?>()
        .firstWhere((_) => true, orElse: () => null);
    final backCtrl = widget.children
        .where((c) => c.name == "back" && c.isVisible)
        .cast<Control?>()
        .firstWhere((_) => true, orElse: () => null);

    // Çocuk kontrol -> Widget dönüştür
    Widget _buildChild(Control? child) {
      if (child == null) {
        return const SizedBox.shrink();
      }
      // createChildControl: Flet'in dahili mekanizması (args.createControl ile aynı zincir)
      final w = widget.backend.buildControlWidget(
        context: context,
        control: child,
        parent: widget.control,
      );
      return w ?? const SizedBox.shrink();
    }

    final frontWidget = _buildChild(frontCtrl);
    final backWidget = _buildChild(backCtrl);

    // FlipCard yön seçimi
    final direction =
        dirStr == "vertical" ? FlipDirection.vertical : FlipDirection.horizontal;

    // Kullanıcı dokunmasıyla flip kapatılabiliyor
    final onFlip = () {
      _showingFront = !_showingFront;
      _triggerFlippedEvent();
    };

    Widget card = FlipCard(
      key: _flipKey,
      direction: direction,
      // flipOnTouch false ise gesture devre dışı
      onFlip: onFlip,
      // FlipCard kendi gesture'ını kullanır; flip_on_touch=false ise devre dışı sarmalarız
      front: AbsorbPointer(
        absorbing: !flipOnTouch,
        child: frontWidget,
      ),
      back: AbsorbPointer(
        absorbing: !flipOnTouch,
        child: backWidget,
      ),
      speed: 400,
      // initial side (FlipCard doğrudan desteklemiyorsa, initState sonrası gerekirse toggle)
    );

    // Eğer initialSide "back" ise, ilk frame'de arka yüze çevir
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_showingFront && mounted) {
        final st = _flipKey.currentState;
        if (st != null && _showingFront) {
          st.toggleCard();
          _showingFront = false;
        }
      }
    });

    // Boyut/ortak özellikler için sargı
    return constrainedControl(context, card, widget.parent, widget.control);
  }
}
