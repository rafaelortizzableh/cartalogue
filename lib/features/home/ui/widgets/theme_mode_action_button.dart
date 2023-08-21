import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../features.dart';

class ThemeLinkIcon extends ConsumerWidget {
  const ThemeLinkIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeControllerProvider);
    final icon = _assignIcon(themeMode);

    return IconButton(
      icon: Icon(icon),
      onPressed: () => context.push(ThemeScreen.routeName),
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
