import 'package:cartalogue/core/core.dart';
import 'package:cartalogue/features/features.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockLoggerService extends Mock implements LoggerService {}

class MockSharedPreferencesService extends Mock
    implements SharedPreferencesService {}

enum ConnectivityCase { error, success }

class MockConnectivity extends Mock implements Connectivity {
  MockConnectivity({required this.connectivityCase});
  final ConnectivityCase connectivityCase;

  @override
  Future<ConnectivityResult> checkConnectivity() {
    if (connectivityCase == ConnectivityCase.success) {
      return Future.value(ConnectivityResult.wifi);
    }
    return Future.value(ConnectivityResult.none);
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    if (connectivityCase == ConnectivityCase.success) {
      return Stream.value(ConnectivityResult.wifi);
    }
    return Stream.value(ConnectivityResult.none);
  }
}

class MockCarManufacturersService extends Mock
    implements CarManufacturersService {}

class MockCarManufacturersController
    extends StateNotifier<CarManufacturersState>
    with Mock
    implements CarManufacturersController {
  MockCarManufacturersController(super.state);

  void setState(CarManufacturersState state) => this.state = state;
}

class MockCarManufacturerDetailsController
    extends StateNotifier<CarManufacturerDetailsState>
    with Mock
    implements CarManufacturerDetailsController {
  MockCarManufacturerDetailsController(super.state);

  void setState(CarManufacturerDetailsState state) => this.state = state;
}

class MockLikedCarMakesController extends StateNotifier<Set<CarMakeModel>>
    with Mock
    implements LikedCarMakesController {
  MockLikedCarMakesController(super.state);

  void setState(Set<CarMakeModel> state) => this.state = state;
}

class MockNetworkConnectivityController
    extends StateNotifier<NetworkConnectivityStatus>
    with Mock
    implements NetworkConnectivityController {
  MockNetworkConnectivityController(super.state);

  void setState(NetworkConnectivityStatus state) => this.state = state;
}
