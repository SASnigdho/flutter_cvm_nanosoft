abstract class IBinding {
  Future<void> call();
  void setUpScreenOrientation();
  Future<void> initFirebase();
  Future<void> initFirebaseCrashlytics();
  Future<void> initFirebaseAnalytics();
  Future<void> initDatabase();
  void initLoading();

  // Initialize Theme.
  // Initialize localization.
  // Initialize Observer [If Bloc].
}
