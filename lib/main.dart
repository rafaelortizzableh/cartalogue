import 'package:cartalogue/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initialDependencies =
      await AppConfiguration.configureInitialDependencies();
  final sharedPreferences = initialDependencies.sharedPreferences;

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesServiceProvider.overrideWithValue(
          SharedPreferencesService(sharedPreferences),
        ),
      ],
      child: const CartalogueApp(),
    ),
  );
}
