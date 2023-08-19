import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider that exposes the [Connectivity] instance.
final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

/// Provider that exposes the [Dio] instance.
final dioProvider = Provider<Dio>((ref) {
  return Dio();
});
