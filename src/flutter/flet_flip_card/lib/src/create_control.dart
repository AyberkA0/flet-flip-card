import 'package:flet/flet.dart';

import 'flet_flip_card.dart';

@pragma('vm:entry-point')
void ensureInitialized() {

}

@pragma('vm:entry-point')
CreateControlFactory createControl = (CreateControlArgs args) {
  if (args.control.type == "flet_flip_card") {
    return FletFlipCardControl(
      parent: args.parent,
      control: args.control,
      children: args.children,
      parentDisabled: args.parentDisabled,
      parentAdaptive: args.parentAdaptive,
      backend: args.backend,
    );
  }
  return null;
};
