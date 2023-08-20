import 'package:flutter/material.dart';

import '../../../../../core/core.dart';

class EmptyCarMakes extends StatelessWidget {
  const EmptyCarMakes({
    super.key,
    required this.manufacturerName,
  });
  final String manufacturerName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppConstants.horizontalPadding8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning,
              size: 100,
            ),
            AppSpacing.verticalSpacing12,
            Text(
              'No car makes found for $manufacturerName',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
