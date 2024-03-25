part of '../container.dart';

void _registerServices() {
  // externals
  _locator
    ..registerSingleton<ChopperClient>(baseClient)
    ..registerSingletonAsync(() => SharedPreferences.getInstance());

  // internals
  _locator
    ..registerLazySingleton<AuthRepo>(() {
      return AuthRepoImpl(client: get(), sharedPreferences: get());
    })
    ..registerLazySingleton<StoriesRepo>(() => StoriesRepoImpl(get()));
}
