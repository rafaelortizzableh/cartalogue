import 'package:flutter/material.dart';

import '../../../../../core/core.dart';
import '../../../car_manufacturers.dart';

class CarMakesList extends StatelessWidget {
  const CarMakesList({
    super.key,
    required this.carMakes,
  });

  final List<CarMakeModel> carMakes;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: _gridDelegate,
      padding: AppConstants.padding12,
      itemCount: carMakes.length,
      itemBuilder: (context, index) {
        final carMake = carMakes[index];
        return CarMakeTile(
          key: _generateKey(carMake),
          carMake: carMake,
          index: index,
        );
      },
    );
  }

  ObjectKey _generateKey(CarMakeModel carMake) {
    return ObjectKey('car_make_${carMake.id}');
  }

  static const _gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    childAspectRatio: _carMakeTileAspectRatio,
    crossAxisSpacing: AppConstants.spacing8,
    mainAxisSpacing: AppConstants.spacing8,
    maxCrossAxisExtent: _maxCrossAxisExtent,
  );

  static const _carMakeTileAspectRatio = CarMakeTile.cardAspectRatio;
  static const _maxCrossAxisExtent = 200.0;
}
