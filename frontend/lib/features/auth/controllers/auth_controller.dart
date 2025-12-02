import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/auth_repo.dart';

final authRepoProvider = Provider((ref) => AuthRepo());

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(ref.read(authRepoProvider));
});

class AuthController extends StateNotifier<bool> {
  final AuthRepo _repo;

  AuthController(this._repo) : super(false);

  Future<bool> login(String email, String password) async {
    state = true;
    final result = await _repo.login(email, password);
    state = false;
    return result;
  }

  Future<bool> register(String name, String email, String password) async {
    state = true;
    final result = await _repo.register(name, email, password);
    state = false;
    return result;
  }
}
