part of '../container.dart';

void _registerUseCases() {
  // auth
  _locator
    ..registerLazySingleton(() => LoginCase(get()))
    ..registerLazySingleton(() => RegisterCase(get()));
}
