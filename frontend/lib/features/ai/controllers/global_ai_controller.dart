import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/global_ai_repo.dart';

final globalAiRepoProvider = Provider((ref) => GlobalAiRepo());

final globalAiControllerProvider =
    StateNotifierProvider<GlobalAiController, AsyncValue<String>>(
  (ref) => GlobalAiController(ref.read(globalAiRepoProvider)),
);

class GlobalAiController extends StateNotifier<AsyncValue<String>> {
  final GlobalAiRepo _repo;

  GlobalAiController(this._repo) : super(const AsyncValue.data(""));

  Future<void> ask(String question) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repo.ask(question);
      state = AsyncValue.data(result);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> search(String query) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repo.search(query);
      state = AsyncValue.data(result);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> summarizeAll() async {
    state = const AsyncValue.loading();
    try {
      final result = await _repo.summarizeAll();
      state = AsyncValue.data(result);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
