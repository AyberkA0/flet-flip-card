import 'package:flet/flet.dart';
import 'package:flutter/widgets.dart';

import 'flip_card_control.dart';

class Extension extends FletExtension {
  @override
  Widget? createWidget(Key? key, Control control) {
    switch (control.type) {
      case "flet_flip_card":
        return FlipCardControl(key: key, control: control);
      default:
        return null;
    }
  }
}
