import 'package:flet/flet.dart';
import 'package:flutter/widgets.dart';

import 'flet_flip_card.dart';

// ÖNEMLİ: createControl ismi ve imzası
CreateControlFactory createControl = (CreateControlArgs args) {
  if (args.control.type == "flip_card") {
    return FletFlipCardControl(parent: args.parent, control: args.control);
  }
  return null; // bu paketin tipi değilse diğer extension'lara sıra verilir
};