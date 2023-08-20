import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

final likedCarMakesControllerProvider = StateNotifierProvider.autoDispose<
    LikedCarMakesController, Set<CarMakeModel>>(
  (ref) => LikedCarMakesController(ref),
);

class LikedCarMakesController extends StateNotifier<Set<CarMakeModel>> {
  LikedCarMakesController(this._ref) : super(_loadInitialState(_ref)) {
    addListener(_saveLikedCarMakeIdsToSharedPreferences);
  }

  final Ref _ref;

  static const _likedCarMakeIdsKey = 'liked_car_make_ids';

  static Set<CarMakeModel> _loadInitialState(Ref ref) {
    final savedCarMakes = ref
        .read(sharedPreferencesServiceProvider)
        .getListOfStringsFromSharedPreferences(_likedCarMakeIdsKey);
    if (savedCarMakes == null) {
      return {};
    }

    final likedCarMakes = savedCarMakes.map(
      (json) => CarMakeModel.fromJson(json),
    );
    return {...likedCarMakes};
  }

  void onCarMakeLiked(CarMakeModel carMake) {
    final likedCarMakes = state.map((e) => e.id);
    final isLiked = likedCarMakes.contains(carMake.id);
    if (!isLiked) {
      state = {...state, carMake};
      return;
    }
    state = {...state.where((id) => id != carMake)};
  }

  Future<void> _saveLikedCarMakeIdsToSharedPreferences(
      Set<CarMakeModel> state) async {
    final sharedPreferencesService = _ref.read(
      sharedPreferencesServiceProvider,
    );
    final newValues = [
      ...state.map((carMake) => carMake.toJson()),
    ];
    await sharedPreferencesService.saveListOfStringsToSharedPreferences(
      _likedCarMakeIdsKey,
      newValues,
    );
  }
}
