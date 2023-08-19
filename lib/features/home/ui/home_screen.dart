import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartalogue'),
        actions: const [_ThemeLinkIcon()],
      ),
      body: const CarManufacturersList(),
    );
  }
}

class _ThemeLinkIcon extends ConsumerWidget {
  const _ThemeLinkIcon();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final icon = _assignIcon(themeMode);

    return IconButton(
      icon: Icon(icon),
      onPressed: () => context.push(ThemeModeScreen.routeName),
    );
  }

  IconData _assignIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return Icons.brightness_auto;
      case ThemeMode.light:
        return Icons.brightness_high;
      case ThemeMode.dark:
        return Icons.brightness_3;
    }
  }
}
