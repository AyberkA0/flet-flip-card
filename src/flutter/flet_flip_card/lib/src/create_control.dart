import 'package:flet/flet.dart';

import 'flet_flip_card.dart';

/// Flet 0.28.3 uyumlu factory
CreateControlFactory createControl = (CreateControlArgs args) {
  switch (args.control.type) {
    case "flet_flip_card":
      return FletFlipCardControl(
        parent: args.parent,
        control: args.control,
      );
    default:
      return null;
  }
};

/// Eski sürümlerde opsiyonel; boş bırakılabilir.
void ensureInitialized() {
  // init yok
}
