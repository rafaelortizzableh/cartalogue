import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/core.dart';
import '../../car_manufacturer_details.dart';

class CarMakeDetailBottomSheet extends StatelessWidget {
  const CarMakeDetailBottomSheet({
    super.key,
    required this.colorScheme,
    required this.contentWidth,
    required this.minRadius,
    required this.carMake,
  });

  final ColorScheme colorScheme;
  final double contentWidth;
  final double minRadius;
  final CarMakeModel carMake;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppConstants.spacing16),
            ),
            color: colorScheme.primary,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                SizedBox(
                  width: _contentWidth,
                  child: AspectRatio(
                    aspectRatio: CarMakeTile.cardAspectRatio,
                    child: CarMakeTileContent(
                      colorScheme: colorScheme,
                      minRadius: minRadius,
                      carMake: carMake,
                    ),
                  ),
                ),
                const Spacer(flex: 3),
                // This is a temporary solution to avoid the like button
                // being shown in the test environment.
                //
                // This is because of a limitation
                // when getting the right [ProviderScope]
                // after pumping a widget with [showModalBottomSheet].
                if (!_isTestEnvironment) ...[
                  Flexible(
                    child: LikeCarMakeIconButton(
                      carMake: carMake,
                      colorScheme: colorScheme,
                    ),
                  ),
                ],
                const Spacer(),
              ],
            ),
          ),
        ),
        const Align(
          alignment: Alignment.topLeft,
          child: CloseButton(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  double get _contentWidth {
    final maxRadius = minRadius * 1.5;
    return math.min(contentWidth, maxRadius);
  }

  static final _isTestEnvironment = AppConstants.isTestEnvironment;

  static Future<dynamic> show({
    required BuildContext context,
    required CarMakeModel carMake,
    required ColorScheme colorScheme,
    required double minRadius,
  }) async {
    final verticalPadding = MediaQuery.paddingOf(context).top;
    final viewPortHeight = MediaQuery.of(context).size.height;
    final boxConstraints = BoxConstraints.tightFor(
      height: viewPortHeight - verticalPadding - AppConstants.spacing16,
    );
    final contentWidth = MediaQuery.of(context).size.width * 0.33;

    return await showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      shape: AppConstants.roundedRectangleVerticalBorder16,
      constraints: boxConstraints,
      context: context,
      builder: (_) {
        return CarMakeDetailBottomSheet(
          colorScheme: colorScheme,
          contentWidth: contentWidth,
          minRadius: minRadius,
          carMake: carMake,
        );
      },
    );
  }
}
