import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/core.dart';
import '../../features.dart';

class CarManufacturersList extends ConsumerWidget {
  const CarManufacturersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manufacturers = ref
        .watch(carManufacturersControllerProvider)
        .carManufacturers
        .whenOrNull(data: (manufacturers) => manufacturers.values.toList());

    final isLoadingMore =
        ref.watch(carManufacturersControllerProvider).isLoadingMore;

    final hasReachedMax =
        ref.watch(carManufacturersControllerProvider).hasReachedMax;

    final isLoading = ref
        .watch(carManufacturersControllerProvider)
        .carManufacturers
        .maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

    final error = ref
        .watch(carManufacturersControllerProvider)
        .carManufacturers
        .whenOrNull(error: (error, _) => error);

    if (error != null) {
      return ErrorLoadingManufacturers(
        onRefresh: () => _onRefresh(ref),
        error: error,
      );
    }

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (manufacturers != null && manufacturers.isEmpty) {
      return OnRefreshManufacturersList(
        onRefresh: () => _onRefresh(ref),
      );
    }

    if (manufacturers == null) {
      return AppSpacing.emptySpace;
    }

    return ListView.separated(
      padding: AppConstants.padding12,
      itemCount: manufacturers.length + 1, // One extra item for load more card.
      separatorBuilder: (context, index) => AppSpacing.verticalSpacing8,
      itemBuilder: (context, index) {
        final isLoadMoreCard = index == manufacturers.length;
        if (isLoadMoreCard) {
          return LoadMoreManufacturers(
            onLoadMore: () => _onRefresh(ref),
            isLoadingMore: isLoadingMore,
            hasReachedMax: hasReachedMax,
          );
        }
        final manufacturer = manufacturers[index];
        return CarManufacturerCard(
          manufacturer: manufacturer,
          onTap: (manufacturer) => _onCarManufacturerTap(
            context,
            ref,
            manufacturer.id,
          ),
        );
      },
    );
  }

  void _onCarManufacturerTap(
    BuildContext context,
    WidgetRef ref,
    int carManufacturerId,
  ) {
    final controller = ref.read(carManufacturersControllerProvider.notifier);
    controller.selectManufacturer(carManufacturerId);
    context.push(CarManufacturerDetailsScreen.routeName);
  }

  Future<void> _onRefresh(WidgetRef ref) async {
    return await ref
        .read(carManufacturersControllerProvider.notifier)
        .fetchCarManufacturersRemotely();
  }
}

class ErrorLoadingManufacturers extends StatelessWidget {
  const ErrorLoadingManufacturers({
    super.key,
    required this.onRefresh,
    required this.error,
  });

  final Future<void> Function() onRefresh;
  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            errorMessage,
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalSpacing8,
          TextButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text(
              'Refresh',
              textAlign: TextAlign.center,
            ),
            onPressed: () => unawaited(onRefresh()),
          ),
        ],
      ),
    );
  }

  String get errorMessage {
    if (error is NHTSAApiRequestFailure) {
      return 'Something went wrong while loading manufacturers from NHTSA.';
    }

    return 'Error loading manufacturers';
  }
}

class OnRefreshManufacturersList extends StatelessWidget {
  const OnRefreshManufacturersList({
    super.key,
    required this.onRefresh,
  });

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No manufacturers found\n Pull to refresh',
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalSpacing8,
          TextButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text(
              'Refresh',
              textAlign: TextAlign.center,
            ),
            onPressed: () => unawaited(onRefresh()),
          ),
        ],
      ),
    );
  }
}

class LoadMoreManufacturers extends StatelessWidget {
  const LoadMoreManufacturers({
    super.key,
    required this.onLoadMore,
    required this.isLoadingMore,
    required this.hasReachedMax,
  });

  final Future<void> Function() onLoadMore;
  final bool isLoadingMore;
  final bool hasReachedMax;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: kThemeAnimationDuration,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _backgroundColor,
          shape: AppConstants.roundedRectangleBorder12,
        ),
        onPressed: (!hasReachedMax && !isLoadingMore) ? onLoadMore : null,
        child: AnimatedSize(
          duration: kThemeAnimationDuration,
          child: _LoadMoreButtonContent(
            hasReachedMax: hasReachedMax,
            isLoadingMore: isLoadingMore,
          ),
        ),
      ),
    );
  }

  Color get _backgroundColor {
    if (isLoadingMore) {
      return Colors.pink;
    }
    if (hasReachedMax) {
      return CustomTheme.errorRed;
    }
    return CustomTheme.primaryColor;
  }
}

class _LoadMoreButtonContent extends StatelessWidget {
  const _LoadMoreButtonContent({
    // ignore: unused_element
    super.key,
    required this.isLoadingMore,
    required this.hasReachedMax,
  });
  final bool isLoadingMore;
  final bool hasReachedMax;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (isLoadingMore) {
      return const SizedBox(
        width: AppConstants.spacing32,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Padding(
            padding: AppConstants.padding4,
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    if (hasReachedMax) {
      return Text(
        'No more manufacturers to load',
        style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      );
    }

    return Text(
      'Load more',
      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
      textAlign: TextAlign.center,
    );
  }
}
