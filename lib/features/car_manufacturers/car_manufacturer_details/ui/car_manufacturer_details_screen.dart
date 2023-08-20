import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features.dart';

class CarManufacturerDetailsScreen extends ConsumerWidget {
  const CarManufacturerDetailsScreen({
    super.key,
  });

  static const routeName = '/carManufacturerDetails';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCarManufacturerId = ref.watch(
      carManufacturerDetailsProvider.select((state) => state.manufacturerId),
    );
    if (selectedCarManufacturerId == null) {
      return const NoSelectedCarManufacturer();
    }

    final carManufacturerDetails = ref.watch(
      carManufacturerDetailsProvider,
    );

    final manufacturerName = carManufacturerDetails.manufacturerName;

    if (manufacturerName == null) {
      return const NoSelectedCarManufacturer();
    }

    final carMakes = carManufacturerDetails.carMakes.maybeWhen(
      data: (makes) => makes.values.toList(),
      orElse: () => <CarMakeModel>[],
    );

    final isCarMakesListLoading = carManufacturerDetails.carMakes.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    if (isCarMakesListLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(manufacturerName),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return CarManufacturerDetails(
      manufacturerName: manufacturerName,
      carMakes: carMakes,
    );
  }
}
