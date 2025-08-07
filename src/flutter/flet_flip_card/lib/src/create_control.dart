import 'package:flet/flet.dart';
import 'flet_flip_card.dart';
import 'flip_card_service.dart';

CreateControlFactory createControl = (CreateControlArgs args) {
  if (args.control.type == "flet_flip_card") {
    return FletFlipCardControl(parent: args.parent, control: args.control);
  }
  return null;
};

CreateServiceFactory? createService = (CreateServiceArgs args) {
  if (args.control.type == "flet_flip_card") {
    return FlipCardService(control: args.control);
  }
  return null;
};

void ensureInitialized() {
  // extension init code (none needed here)
}
