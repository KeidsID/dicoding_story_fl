import '../entities.dart';

abstract interface class AuthRepo {
  Future<void> register({
    required String username,
    required String email,
    required String password,
  });

  Future<UserCreds> login({required String email, required String password});
  Future<UserCreds?> getLoginSession();
  Future<void> logout();
}
