part of '../container.dart';

void _registerServices() {
  // externals
  _locator.registerSingleton<ChopperClient>(baseClient);

  // internals
  _locator.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(get()));
}
