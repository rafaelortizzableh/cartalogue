import 'package:flutter/material.dart';

import '../../../../features.dart';

class CarManufacturerDetails extends StatelessWidget {
  const CarManufacturerDetails({
    super.key,
    required this.manufacturerName,
    required this.carMakes,
  });
  final String manufacturerName;
  final List<CarMakeModel> carMakes;

  @override
  Widget build(BuildContext context) {
    final isCarMakesEmpty = carMakes.isEmpty;
    return isCarMakesEmpty
        ? EmptyCarMakes(manufacturerName: manufacturerName)
        : CarMakesList(carMakes: carMakes);
  }
}
