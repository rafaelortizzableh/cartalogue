import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../core/core.dart';
import '../../car_manufacturer_details.dart';

class CarMakeTile extends StatefulWidget {
  const CarMakeTile({
    super.key,
    required this.carMake,
    required this.index,
  });
  final CarMakeModel carMake;
  final int index;

  static const cardAspectRatio = 0.75;

  @override
  State<CarMakeTile> createState() => _CarMakeTileState();
}

class _CarMakeTileState extends State<CarMakeTile> {
  late final MaterialColor _color = _assignColorFromIndexAndId(
    widget.index,
    widget.carMake.id,
  );

  late final _colorScheme = ColorScheme.fromSwatch(
    primarySwatch: _color,
  );

  static const _minRadius = 100.0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: CarMakeTile.cardAspectRatio,
      child: Tooltip(
        message: widget.carMake.name,
        child: Card(
          color: _colorScheme.primary,
          child: InkWell(
            onTap: _onTileOpened,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.spacing12,
                horizontal: AppConstants.spacing12,
              ),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: CarMakeTileContent(
                  colorScheme: _colorScheme,
                  minRadius: _minRadius,
                  carMake: widget.carMake,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTileOpened() {
    unawaited(
      CarMakeDetailBottomSheet.show(
        context: context,
        carMake: widget.carMake,
        colorScheme: _colorScheme,
        minRadius: _minRadius,
      ),
    );
  }

  MaterialColor _assignColorFromIndexAndId(int index, int id) {
    final primaryColors = Colors.primaries
        .where(
          (color) =>
              color != Colors.yellow &&
              color != Colors.lime &&
              color != Colors.amber,
        )
        .toList();

    final indexSeed = index + 1;

    final colorIndex = (indexSeed * id) % primaryColors.length;

    return primaryColors[colorIndex];
  }
}
