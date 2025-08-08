import 'package:flet/flet.dart';
import 'flet_flip_card.dart';

CreateControlFactory createControl = (CreateControlArgs args) {
  if (args.control.type == 'flip_card') {
    return FletFlipCardControl(
      parent: args.parent,
      control: args.control,
      children: args.children,
    );
  }
  return null;
};
