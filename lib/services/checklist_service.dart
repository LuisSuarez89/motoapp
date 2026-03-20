import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main');
});

final checklistStateProvider = StateNotifierProvider<ChecklistStateNotifier, Map<String, bool>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ChecklistStateNotifier(prefs);
});

class ChecklistStateNotifier extends StateNotifier<Map<String, bool>> {
  ChecklistStateNotifier(this.prefs) : super(_loadInitialState(prefs));

  final SharedPreferences prefs;

  static Map<String, bool> _loadInitialState(SharedPreferences prefs) {
    final Map<String, bool> state = {};
    final keys = prefs.getKeys().where((k) => k.startsWith('chk_'));
    for (final key in keys) {
      final id = key.substring(4); // Remove 'chk_'
      state[id] = prefs.getBool(key) ?? false;
    }
    return state;
  }

  void toggleItem(String id) {
    final newState = !isChecked(id);
    prefs.setBool('chk_$id', newState);
    state = {...state, id: newState};
  }

  bool isChecked(String id) {
    return state[id] ?? false;
  }
}
