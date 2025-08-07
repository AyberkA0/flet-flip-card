import 'package:flet/flet.dart';

import 'flet_flip_card.dart';

CreateControlFactory createControl = (CreateControlArgs args) {
  switch (args.control.type) {
    case "flet_flip_card":
      return FletFlipCardControl(control: args.control, parent: args.parent);
    default:
      return null;
  }
};

void ensureInitialized() {
  // Nothing to initialize
}
