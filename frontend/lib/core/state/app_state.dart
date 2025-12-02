import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class AppState {
  final bool darkMode;

  AppState({
    this.darkMode = false,
  });

  AppState copyWith({bool? darkMode}) {
    return AppState(
      darkMode: darkMode ?? this.darkMode,
    );
  }
}

final appStateProvider =
    StateNotifierProvider<AppStateController, AppState>(
  (ref) => AppStateController(),
);

class AppStateController extends StateNotifier<AppState> {
  AppStateController() : super(AppState());

  void toggleTheme() {
    state = state.copyWith(darkMode: !state.darkMode);
  }
}
