import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core.dart';
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

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: Text(
              manufacturerName,
              textAlign: TextAlign.center,
            ),
            floating: true,
            centerTitle: true,
          ),
          const SliverPadding(padding: AppConstants.verticalPadding4),
          CarManufacturerDetailsContent(
            manufacturerName: manufacturerName,
            carMakes: carMakes,
            isCarMakesListLoading: isCarMakesListLoading,
          ),
        ],
      ),
    );
  }
}
