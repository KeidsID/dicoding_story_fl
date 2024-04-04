import 'package:equatable/equatable.dart';

/// {@template dicoding_story_fl.core.entities.UserCreds}
/// User credentials from login session.
/// {@endtemplate}
class UserCreds extends Equatable {
  /// {@macro dicoding_story_fl.core.entities.UserCreds}
  const UserCreds({
    required this.id,
    required this.name,
    required this.token,
  });

  /// Unique identifier.
  final String id;

  /// Username.
  final String name;

  /// Token for fetching stories from API.
  final String token;

  @override
  List<Object?> get props => [id, name, token];

  factory UserCreds.fromCache(Map<String, dynamic> map) =>
      UserCreds(id: map['id'], name: map['name'], token: map['token']);

  Map<String, dynamic> toCache() => {'id': id, 'name': name, 'token': token};
}
