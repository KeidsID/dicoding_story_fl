import "package:injectable/injectable.dart";
import "package:shared_preferences/shared_preferences.dart";

export "modules/auth_local_data.dart";

@module
abstract class LocalDataModules {
  @singleton
  @preResolve
  Future<SharedPreferences> getSharedPreferences() {
    return SharedPreferences.getInstance();
  }
}
