import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/customer/presentation/pages/customer_list_page.dart';
import '../features/error/presentation/pages/route_error_page.dart';
import '../features/intro/presentation/pages/splash_page.dart';
import '../routes/app_route_observer.dart';

// Create keys for `root` & `section` navigator avoiding unnecessary rebuilds
final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter._();

  static const String splash = '/splash';
  static const String customers = '/customers';

  static final context = _rootNavigatorKey.currentContext;

  static final routerConfig = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: splash,
    observers: [AppRouteObserver()],
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        name: splash,
        path: splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        name: customers,
        path: customers,
        builder: (context, state) => const CustomerListScreen(),
      ),
    ],
    errorBuilder: (context, state) => RouteErrorPage(error: state.error),
  );

  static Future<T?> push<T>(BuildContext context, Widget child) {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (BuildContext context) => child));
  }

  static void removeOffAll(BuildContext context, String path) {
    while (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
    }

    GoRouter.of(context).go(path);
  }

  static CustomTransitionPage animatePage({
    required GoRouterState state,
    required Widget page,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: page,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}
