import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class ExtendedAppBarTitle extends StatelessWidget {
  const ExtendedAppBarTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Colors.white,
        );
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: AppConstants.spacing8,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.25),
            borderRadius: AppConstants.borderRadius8,
          ),
          child: Padding(
            padding: AppConstants.horizontalPadding8,
            child: Text(
              title,
              style: textStyle,
            ),
          ),
        ),
      ),
    );
  }
}
