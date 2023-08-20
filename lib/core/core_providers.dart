import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider that exposes the [Connectivity] instance.
final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

/// Provider that exposes the [Stream] of [ConnectivityResult].
final _onConnectivityChangedProvider =
    StreamProvider.autoDispose<ConnectivityResult>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.onConnectivityChanged;
});

final isNetworkConnectedProvider = Provider.autoDispose<bool>((ref) {
  final connectivityResult = ref.watch(_onConnectivityChangedProvider);
  return connectivityResult.when(
    data: (result) => result != ConnectivityResult.none,
    loading: () => true,
    error: (error, _) => false,
  );
});

/// Provider that exposes the [Dio] instance.
final dioProvider = Provider<Dio>((ref) {
  return Dio();
});
