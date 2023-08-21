import 'package:flutter/material.dart';

import '../../car_manufacturer_details.dart';

class CarMakeTileContent extends StatelessWidget {
  const CarMakeTileContent({
    super.key,
    required this.colorScheme,
    required this.minRadius,
    required this.carMake,
  });

  final ColorScheme colorScheme;
  final double minRadius;
  final CarMakeModel carMake;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final circleAvatarTextStyle = theme.textTheme.headlineLarge?.copyWith(
      color: colorScheme.primary,
      fontSize: minRadius * _circleAvatarTextWidthFactor,
    );
    final textStyle = theme.textTheme.titleMedium?.copyWith(
      color: _onPrimaryColor,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: CircleAvatar(
            backgroundColor: _onPrimaryColor,
            minRadius: minRadius,
            child: Text(
              _circleAvatarText,
              style: circleAvatarTextStyle,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Text(
          carMake.name,
          style: textStyle,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  String get _circleAvatarText => carMake.name[0].toUpperCase();
  static const _circleAvatarTextWidthFactor = 0.5;
  static const _onPrimaryColor = Colors.white;
}
