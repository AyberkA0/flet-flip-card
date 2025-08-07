
import 'package:flet/flet.dart';
import 'package:flutter/widgets.dart';
import 'package:flip_card/flip_card.dart';

class FlipCardService extends FletService {
  FlipCardService({required super.control});

  GlobalKey<FlipCardState>? _cardKey;

  @override
  void init() {
    super.init();
    _cardKey = control.state["_cardKey"] as GlobalKey<FlipCardState>?;
    control.addInvokeMethodListener(_invokeMethod);
  }

  Future<dynamic> _invokeMethod(String name, dynamic args) async {
    switch (name) {
      case "flip":
        _cardKey?.currentState?.toggleCard();
        return null;
      case "showFront":
        if (_cardKey?.currentState?.isFront == false) {
          _cardKey?.currentState?.toggleCard();
        }
        return null;
      case "showBack":
        if (_cardKey?.currentState?.isFront == true) {
          _cardKey?.currentState?.toggleCard();
        }
        return null;
      default:
        throw Exception("Unknown FlipCard method: \$name");
    }
  }

  @override
  void dispose() {
    control.removeInvokeMethodListener(_invokeMethod);
    super.dispose();
  }
}
