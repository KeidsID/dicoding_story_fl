part of '../container.dart';

void _registerUseCases() {
  // auth
  _locator
    ..registerLazySingleton(() => LoginCase(get()))
    ..registerLazySingleton(() => RegisterCase(get()))
    ..registerLazySingleton(() => GetLoginSessionCase(get()))
    ..registerLazySingleton(() => LogoutCase(get()));
}
