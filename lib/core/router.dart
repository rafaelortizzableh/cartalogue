import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/features.dart';
import 'core.dart';

/// The [Provider] for the [RouterNotifier].
final _routerNotifierProvider = ChangeNotifierProvider(
  (_) => RouterNotifier(),
);

/// The [Provider] for the [GoRouter].
final routerProvider = Provider(
  (ref) => ref.watch(_routerNotifierProvider).router,
);

class RouterNotifier extends ChangeNotifier {
  RouterNotifier();

  static final navigatorKey = GlobalKey<NavigatorState>();

  GoRouter get router => GoRouter(
        debugLogDiagnostics: true,
        navigatorKey: navigatorKey,
        refreshListenable: this,
        routes: _routes,
        errorPageBuilder: (context, state) => _fadeTransition(
          UnknownRouteScreen(name: state.name),
        ),
      );

  final _routes = [
    GoRoute(
      path: HomeScreen.routeName,
      name: HomeScreen.routeName,
      pageBuilder: (context, state) => const MaterialPage(
        child: HomeScreen(),
      ),
    ),
    GoRoute(
      path: ThemeScreen.routeName,
      name: ThemeScreen.routeName,
      pageBuilder: (context, state) => const MaterialPage(
        fullscreenDialog: true,
        child: ThemeScreen(),
      ),
    ),
    GoRoute(
      path: CarManufacturerDetailsScreen.routeName,
      name: CarManufacturerDetailsScreen.routeName,
      pageBuilder: (context, state) => const MaterialPage(
        child: CarManufacturerDetailsScreen(),
      ),
      routes: const [],
    ),
    GoRoute(
      path: LikedCarMakesScreen.routeName,
      name: LikedCarMakesScreen.routeName,
      pageBuilder: (context, state) => const MaterialPage(
        child: LikedCarMakesScreen(),
      ),
    ),
  ];

  static CustomTransitionPage _fadeTransition(Widget child) {
    return CustomTransitionPage<void>(
      child: child,
      transitionsBuilder: (_, animation, ___, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
