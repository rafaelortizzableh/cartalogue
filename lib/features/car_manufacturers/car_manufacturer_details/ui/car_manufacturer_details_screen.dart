import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class CarManufacturerDetailsScreen extends ConsumerWidget {
  const CarManufacturerDetailsScreen({
    super.key,
  });

  static const routeName = '/carManufacturerDetails';

  static const _networkErrorLabel = 'Network error';
  static const _somethingWentWrongLabel = 'Something went wrong';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCarManufacturerId = ref.watch(
      carManufacturerDetailsProvider.select((state) => state.manufacturerId),
    );
    if (selectedCarManufacturerId == null) {
      return const ErrorGettingCarManufacturerDetails();
    }

    final carManufacturerDetails = ref.watch(
      carManufacturerDetailsProvider,
    );

    final manufacturerName = carManufacturerDetails.manufacturerName;

    if (manufacturerName == null) {
      return const ErrorGettingCarManufacturerDetails();
    }

    final error = carManufacturerDetails.carMakes.whenOrNull(
      error: (error, _) => error,
    );

    if (error != null) {
      final errorLabel = error is NHTSAApiRequestFailure
          ? _networkErrorLabel
          : _somethingWentWrongLabel;
      return ErrorGettingCarManufacturerDetails(
        errorText: errorLabel,
        icon: error is NHTSAApiRequestFailure
            ? CupertinoIcons.wifi_slash
            : Icons.warning,
      );
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
