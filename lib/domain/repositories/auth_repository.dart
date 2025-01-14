import "../entities.dart" show User;

abstract interface class AuthRepository {
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<User> signIn({required String email, required String password});

  /// Get the user's session from app cache.
  Future<User?> getAuth();

  /// Remove the user's session from app cache.
  Future<void> signOut();
}
