// ignore_for_file: prefer_const_constructors

import 'package:cartalogue/core/core.dart';
import 'package:cartalogue/features/features.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './helpers.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    SharedPreferencesService? sharedPreferencesService,
    LoggerService? loggerService,
    NetworkConnectivityController? networkConnectivityController,
    List<Override> overrides = const [],
  }) async {
    // Set up mocked [SharedPreferencesService].
    SharedPreferences.setMockInitialValues({});
    SharedPreferences mockPreferences = await SharedPreferences.getInstance();
    final mockSharedPreferencesService =
        sharedPreferencesService ?? SharedPreferencesService(mockPreferences);

    // Set up mocked [NetworkConnectivityController].
    final mockNetworkConnectivityController = networkConnectivityController ??
        MockNetworkConnectivityController(
          NetworkConnectivityStatus.connected,
        );

    // Set up mocked [LoggerService].
    final mockLoggerService = MockLoggerService();
    when(
      () => mockLoggerService.captureException(
        any(),
        stackTrace: any(named: 'stackTrace'),
        tag: any(named: 'tag'),
      ),
    ).thenAnswer((_) async {});
    final mockLogger = loggerService ?? mockLoggerService;
    const preferredColor = Colors.deepPurple;
    final customTheme = CustomTheme(primaryColor: preferredColor);

    return await pumpWidget(
      MaterialApp(
        home: Theme(
          data: customTheme.darkTheme(preferredColor),
          child: Scaffold(
            body: ProviderScope(
              overrides: [
                sharedPreferencesServiceProvider.overrideWithValue(
                  mockSharedPreferencesService,
                ),
                loggerServiceProvider.overrideWithValue(
                  mockLogger,
                ),
                networkConnectivityStatusProvider.overrideWith(
                  (_) => mockNetworkConnectivityController,
                ),
                ...overrides,
              ],
              child: widget,
            ),
          ),
        ),
      ),
    );
  }
}
