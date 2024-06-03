import '../entities.dart';

abstract interface class AuthRepo {
  const AuthRepo();

  Future<void> register({
    required String username,
    required String email,
    required String password,
  });

  Future<UserCreds> login({required String email, required String password});
  UserCreds? getLoginSession();
  Future<void> logout();
}
