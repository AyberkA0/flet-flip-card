import 'package:flet/flet.dart';
import 'flet_flip_card.dart';

CreateControlFactory createControl = (CreateControlArgs args) {
  return FletFlipCard(
    control: args.control,
    parent: args.parent,
    children: args.children,
    backend: args.backend,
  );
};
