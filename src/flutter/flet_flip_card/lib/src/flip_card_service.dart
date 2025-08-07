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

  Future<void> _invokeMethod(String name, dynamic args) async {
    switch (name) {
      case "flip":
        _cardKey?.currentState?.toggleCard();
        break;
      // showFront/back logic if needed
      default:
        throw Exception("Unknown FlipCard method: $name");
    }
  }

  @override
  void dispose() {
    control.removeInvokeMethodListener(_invokeMethod);
    super.dispose();
  }
}
