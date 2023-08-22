import 'dart:async';

import 'package:flutter/cupertino.dart';
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

    final isNetworkDisconnected =
        ref.watch(networkConnectivityStatusProvider) ==
            NetworkConnectivityStatus.disconnected;

    if (error != null) {
      return SliverFillRemaining(
        child: ErrorLoadingManufacturers(
          onRefresh: () => _onRefresh(ref),
          error: error,
        ),
      );
    }

    if (isLoading) {
      return const SliverFillRemaining(child: Center(child: GenericLoader()));
    }

    if (manufacturers != null && manufacturers.isEmpty) {
      return SliverFillRemaining(
        child: ErrorLoadingManufacturers(
          error: 'No manufacturers found',
          onRefresh: () => _onRefresh(ref),
        ),
      );
    }

    if (manufacturers == null) {
      return const SliverFillRemaining(child: AppSpacing.emptySpace);
    }

    final preferredColor = ref.watch(preferredColorControllerProvider);

    return SliverPadding(
      padding: AppConstants.padding12,
      sliver: SliverList.separated(
        itemCount:
            manufacturers.length + 1, // One extra item for load more card.
        separatorBuilder: (context, index) => AppSpacing.verticalSpacing8,
        itemBuilder: (context, index) {
          final isLoadMoreCard = index == manufacturers.length;
          if (isLoadMoreCard) {
            return LoadMoreManufacturers(
              isNetworkDisconnected: isNetworkDisconnected,
              onLoadMore: () => _onRefresh(ref),
              isLoadingMore: isLoadingMore,
              hasReachedMax: hasReachedMax,
              preferredColor: preferredColor,
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
      ),
    );
  }

  void _onCarManufacturerTap(
    BuildContext context,
    WidgetRef ref,
    int carManufacturerId,
  ) {
    final controller = ref.read(carManufacturersControllerProvider.notifier);
    controller.selectManufacturer(carManufacturerId);
    context.pushNamed(CarManufacturerDetailsScreen.routeName);
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
          const Icon(
            CupertinoIcons.wifi_slash,
          ),
          AppSpacing.verticalSpacing8,
          Text(
            errorMessage,
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalSpacing8,
          ElevatedButton.icon(
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

class LoadMoreManufacturers extends StatelessWidget {
  const LoadMoreManufacturers({
    super.key,
    required this.onLoadMore,
    required this.isLoadingMore,
    required this.hasReachedMax,
    required this.isNetworkDisconnected,
    required this.preferredColor,
  });

  final Future<void> Function() onLoadMore;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final bool isNetworkDisconnected;
  final Color preferredColor;

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled =
        !hasReachedMax && !isLoadingMore && !isNetworkDisconnected;

    return AnimatedSize(
      duration: kThemeAnimationDuration,
      child: ElevatedButton(
        onPressed: isButtonEnabled ? onLoadMore : null,
        child: AnimatedSize(
          duration: kThemeAnimationDuration,
          child: _LoadMoreButtonContent(
            hasReachedMax: hasReachedMax,
            isLoadingMore: isLoadingMore,
            isNetworkDisconnected: isNetworkDisconnected,
          ),
        ),
      ),
    );
  }
}

class _LoadMoreButtonContent extends StatelessWidget {
  const _LoadMoreButtonContent({
    // ignore: unused_element
    super.key,
    required this.isLoadingMore,
    required this.hasReachedMax,
    required this.isNetworkDisconnected,
  });
  final bool isLoadingMore;
  final bool hasReachedMax;
  final bool isNetworkDisconnected;

  @override
  Widget build(BuildContext context) {
    if (isNetworkDisconnected) {
      return const Text(
        'No internet connection',
        textAlign: TextAlign.center,
      );
    }

    if (isLoadingMore) {
      return const SizedBox(
        width: AppConstants.spacing32,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Padding(
            padding: AppConstants.padding4,
            child: GenericLoader(color: Colors.white),
          ),
        ),
      );
    }

    if (hasReachedMax) {
      return const Text(
        'No more manufacturers to load',
        textAlign: TextAlign.center,
      );
    }

    return const Text(
      'Load more',
      textAlign: TextAlign.center,
    );
  }
}
