import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

@visibleForTesting
class ErrorGettingCarManufacturerDetails extends StatelessWidget {
  const ErrorGettingCarManufacturerDetails({
    super.key,
    this.errorText = 'Please select a car manufacturer',
    this.icon = Icons.warning,
  });

  final String errorText;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error getting car manufacturer details'),
        leading: BackButton(
          onPressed: () => _goToHome(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 100,
            ),
            AppSpacing.verticalSpacing12,
            Text(errorText),
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
