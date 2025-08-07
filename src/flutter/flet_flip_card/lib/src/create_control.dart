
import 'package:flet/flet.dart';

import 'src/flet_flip_card.dart';
import 'src/flip_card_service.dart';

CreateControlFactory createControl = (CreateControlArgs args) {
  switch (args.control.type) {
    case "flet_flip_card":
      return FletFlipCardControl(parent: args.parent, control: args.control);
  }
  return null;
};

void ensureInitialized() {}
