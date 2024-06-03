part of '../container.dart';

void _registerServices() {
  // externals
  _locator
    ..registerSingleton<ChopperClient>(baseClient)
    ..registerSingletonAsync<SharedPreferences>(() {
      return SharedPreferences.getInstance();
    })
    ..registerSingletonAsync<PackageInfo>(() => PackageInfo.fromPlatform());

  // internals
  _locator
    ..registerLazySingleton<AuthRepo>(() {
      return AuthRepoImpl(client: get(), sharedPreferences: get());
    })
    ..registerLazySingleton<GMapsRepo>(() => GMapsRepoImpl())
    ..registerLazySingleton<StoriesRepo>(() => StoriesRepoImpl(get()));
}
