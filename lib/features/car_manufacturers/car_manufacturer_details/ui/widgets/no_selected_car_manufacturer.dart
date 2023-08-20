import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

@visibleForTesting
class NoSelectedCarManufacturer extends StatelessWidget {
  const NoSelectedCarManufacturer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('No car manufacturer selected'),
        leading: BackButton(
          onPressed: () => _goToHome(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning,
              size: 100,
            ),
            AppSpacing.verticalSpacing12,
            const Text('Please select a car manufacturer'),
            AppSpacing.verticalSpacing16,
            ElevatedButton(
              onPressed: () => _goToHome(context),
              child: const Text('Go to home'),
            ),
          ],
        ),
      ),
    );
  }

  void _goToHome(BuildContext context) {
    context.replaceNamed(HomeScreen.routeName);
  }
}
