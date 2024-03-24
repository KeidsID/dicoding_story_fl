/// {@template dicoding_story_fl.domain.entities.UserCreds}
/// User credentials from login session.
/// {@endtemplate}
class UserCreds {
  /// {@macro dicoding_story_fl.domain.entities.UserCreds}
  const UserCreds({
    required this.name,
    required this.token,
  });

  /// Logged username.
  final String name;

  /// Token for fetching stories from API.
  final String token;
}
