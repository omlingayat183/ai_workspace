import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/analytics_repo.dart';

final analyticsRepoProvider = Provider((ref) => AnalyticsRepo());

final analyticsControllerProvider = StateNotifierProvider<AnalyticsController, AsyncValue<Map<String, dynamic>>>(
  (ref) => AnalyticsController(ref.read(analyticsRepoProvider)),
);

class AnalyticsController extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final AnalyticsRepo _repo;
  AnalyticsController(this._repo) : super(const AsyncValue.loading()) {
    loadAll();
  }

  Future<void> loadAll() async {
    state = const AsyncValue.loading();
    try {
      final summary = await _repo.getSummary();
      final recent = await _repo.getRecentNotes();
      final usage = await _repo.getAiUsage();
      state = AsyncValue.data({
        "summary": summary,
        "recent": recent,
        "usage": usage,
      });
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => loadAll();
}
