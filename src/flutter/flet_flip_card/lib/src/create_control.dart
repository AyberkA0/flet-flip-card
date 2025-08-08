// ignore_for_file: depend_on_referenced_packages
// Flet 0.28.3+ uzantı fabrikası.
//
// Bu dosya, Python tarafındaki Control._get_control_name() ile aynı
// "type" ismine göre widget oluşturur ve paketi initialize eder.

import 'package:flet/flet.dart';
import 'package:flutter/widgets.dart';

import 'flet_flip_card.dart';

@pragma('vm:entry-point')
void ensureInitialized() {
  // Gerekirse global/tek seferlik kurulumlar.
}

/// Flet'in uzantımızı yüklerken çağırdığı fabrika.
/// args.control.type == "flet_flip_card" olduğunda widget döndürür.
@pragma('vm:entry-point')
CreateControlFactory createControl = (CreateControlArgs args) {
  if (args.control.type == "flet_flip_card") {
    return FletFlipCardControl(
      parent: args.parent,
      control: args.control,
      children: args.children,
      backend: args.backend,
    );
  }
  return null;
};
