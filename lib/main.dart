import 'package:flutter/material.dart';

import 'src/core/bindings/app_binding.dart';
import 'src/app.dart';
import 'src/core/widgets/bloc_wrapper.dart';

Future<void> main() async {
  await AppBinding().call();

  runApp(const BlocWrapper(child: App()));
}
