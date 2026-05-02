import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../contracts/i_binding.dart';
import '../utils/ui_helper.dart';
import 'injection.dart';

class AppBinding implements IBinding {
  @override
  Future<void> call() async {
    WidgetsFlutterBinding.ensureInitialized();

    configureDependencies();

    setUpScreenOrientation();

    await initFirebase();
    await initFirebaseCrashlytics();
    await initFirebaseAnalytics();
    await initDatabase();
    initLoading();
  }

  @override
  void setUpScreenOrientation() {
    // Set Orientation mode to Portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Future<void> initFirebase() async {}

  @override
  Future<void> initFirebaseCrashlytics() async {}

  @override
  Future<void> initFirebaseAnalytics() async {}

  @override
  Future<void> initDatabase() async {}

  @override
  void initLoading() => UiHelper.initProgressDialog();
}
