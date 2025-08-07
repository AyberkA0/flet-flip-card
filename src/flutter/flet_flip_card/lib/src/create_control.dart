import 'package:flet/flet.dart';

import 'flet_flip_card.dart';

CreateControlFactory createControl = (CreateControlArgs args) {
  switch (args.control.type) {
    case "flet_flip_card":
      return FletFlipCardControl(
        parent: parent, 
        control: control
      );
    default:
      return null;
  }
};

void ensureInitialized() {
  // nothing to initialize
}