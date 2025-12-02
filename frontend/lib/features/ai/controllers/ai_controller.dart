import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/ai_repo.dart';

final aiRepoProvider = Provider((ref) => AiRepo());

final aiControllerProvider =
    StateNotifierProvider<AiController, AsyncValue<String>>(
  (ref) => AiController(ref.read(aiRepoProvider)),
);

class AiController extends StateNotifier<AsyncValue<String>> {
  final AiRepo _repo;

  AiController(this._repo) : super(const AsyncValue.data(""));

  Future<void> summarize(String content) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repo.summarize(content);
      state = AsyncValue.data(result);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> improve(String content) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repo.improve(content);
      state = AsyncValue.data(result);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> tasks(String content) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repo.tasks(content);
      state = AsyncValue.data(result);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> actions(String content) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repo.actions(content);
      state = AsyncValue.data(result);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> transform(String content, String format) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repo.transform(content, format);
      state = AsyncValue.data(result);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> knowledge(String content) async {
    state = const AsyncValue.loading();
    try {
      final result = await _repo.knowledge(content);
      state = AsyncValue.data(result);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
