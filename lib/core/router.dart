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
      // pageBuilder: (context, state) => _modalBottomSheetRoute(
      //   const ThemeScreen(),
      // ),
    ),
    // GoRoute(
    //   path: LoadingScreen.routeName,
    //   name: LoadingScreen.routeName,
    //   pageBuilder: (context, state) => _fadeTransition(const LoadingScreen()),
    // ),
    // GoRoute(
    //   name: ImageViewer.routeName,
    //   path: ImageViewer.routeName,
    //   builder: (context, state) {
    //     final imageUrl =
    //         state.uri.queryParameters[ImageViewer.imageUrlQueryParam];
    //     final heroTag =
    //         state.uri.queryParameters[ImageViewer.heroTagQueryParam];
    //     return ImageViewer(
    //       heroTag: heroTag,
    //       imageUrl: imageUrl,
    //     );
    //   },
    // ),
    // GoRoute(
    //   path: ManufacturersScreen.routeName,
    //   name: ManufacturersScreen.routeName,
    //   pageBuilder: (context, state) =>
    //       _fadeTransition(const ManufacturersScreen()),
    //   routes: [
    //     GoRoute(
    //       path: ManufacturerDetailScreen.routeName,
    //       name: ManufacturerDetailScreen.routeName,
    //       pageBuilder: (context, state) {
    //         final manufacturerId = state.uri.queryParameters[
    //             ManufacturerDetailScreen.manufacturerIdQueryParam];
    //         return _materialPageRoute(
    //           ManufacturerDetailScreen(
    //             manufacturerId: manufacturerId,
    //           ),
    //         );
    //       },
    //     ),
    //   ],
    // ),
  ];

  static CustomTransitionPage _fadeTransition(Widget child) {
    return CustomTransitionPage<void>(
      child: child,
      transitionsBuilder: (_, animation, ___, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static _materialPageRoute(Widget child) {
    return MaterialPageRoute(builder: (context) => child);
  }

  static _modalBottomSheetRoute(
    Widget child, {
    bool isScrollControlled = true,
  }) {
    return ModalBottomSheetRoute(
      builder: (context) => child,
      isScrollControlled: isScrollControlled,
    );
  }
}
