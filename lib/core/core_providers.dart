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

enum NetworkConnectivityStatus {
  connected,
  loading,
  disconnected,
}

final networkConnectivityStatusProvider =
    Provider.autoDispose<NetworkConnectivityStatus>((ref) {
  final connectivityResult = ref.watch(_onConnectivityChangedProvider);
  return connectivityResult.when(
    data: (result) {
      if (result == ConnectivityResult.none) {
        return NetworkConnectivityStatus.disconnected;
      }
      return NetworkConnectivityStatus.connected;
    },
    loading: () => NetworkConnectivityStatus.loading,
    error: (error, _) => NetworkConnectivityStatus.disconnected,
  );
});

/// Provider that exposes the [Dio] instance.
final dioProvider = Provider<Dio>((ref) {
  return Dio();
});
