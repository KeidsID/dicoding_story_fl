import "package:chopper/chopper.dart";
import "package:injectable/injectable.dart";

part "auth_remote_data.chopper.dart";

@lazySingleton
@chopperApi
abstract class AuthRemoteData extends ChopperService {
  @factoryMethod
  static AuthRemoteData create([ChopperClient? client]) =>
      _$AuthRemoteData(client);

  /// https://story-api.dicoding.dev/v1/#/?id=register
  @POST(path: "/register")
  Future<Response<Map<String, dynamic>>> signUp({
    @body required Map<String, dynamic> body,
  });

  /// https://story-api.dicoding.dev/v1/#/?id=login
  @POST(path: "/login")
  Future<Response<Map<String, dynamic>>> signIn({
    @body required Map<String, dynamic> body,
  });
}
