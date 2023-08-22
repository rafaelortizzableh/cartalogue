import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core.dart';

/// Provider for the [NetworkConnectivityController] instance.
final networkConnectivityStatusProvider = StateNotifierProvider.autoDispose<
    NetworkConnectivityController, NetworkConnectivityStatus>((ref) {
  return NetworkConnectivityController(
    NetworkConnectivityStatus.loading,
    ref,
  );
});

enum NetworkConnectivityStatus {
  connected,
  loading,
  disconnected,
}

/// Controller that checks the network connectivity status.
/// It exposes the [NetworkConnectivityStatus] state.
/// It also periodically checks the network connectivity status.
class NetworkConnectivityController
    extends StateNotifier<NetworkConnectivityStatus> {
  NetworkConnectivityController(
    super.state,
    this._ref,
  ) {
    unawaited(
      _checkConnectivity(),
    );
    _periodicallyCheckConnectivity();
    _listenToNetworkConnectivityChanges();
  }

  final Ref _ref;

  static const _periodicCheckConnectivityDuration = Duration(seconds: 10);

  static const _tag = 'NetworkConnectivityController';

  /// Periodically checks the network connectivity status.
  void _periodicallyCheckConnectivity() {
    Timer.periodic(_periodicCheckConnectivityDuration, (_) {
      unawaited(_checkConnectivity());
    });
  }

  /// Manually checks the network connectivity status.
  Future<void> _checkConnectivity() async {
    try {
      final result = await _ref.read(connectivityProvider).checkConnectivity();
      if (result == ConnectivityResult.none) {
        state = NetworkConnectivityStatus.disconnected;
        return;
      }

      if (state == NetworkConnectivityStatus.connected) return;

      state = NetworkConnectivityStatus.connected;
    } catch (e, stackTrace) {
      _ref.read(loggerServiceProvider).captureException(
            e,
            stackTrace: stackTrace,
            tag: _tag,
          );
      state = NetworkConnectivityStatus.disconnected;
    }
  }

  /// Listens to network connectivity changes.
  void _listenToNetworkConnectivityChanges() {
    _ref.read(connectivityProvider).onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        state = NetworkConnectivityStatus.disconnected;
        return;
      }

      if (state == NetworkConnectivityStatus.connected) return;

      state = NetworkConnectivityStatus.connected;
    });
  }
}
