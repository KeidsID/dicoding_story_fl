import 'package:chopper/chopper.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dicoding_story_fl/core/repos.dart';
import 'package:dicoding_story_fl/core/use_cases.dart';
import 'package:dicoding_story_fl/infrastructures/api/base_client.dart';
import 'package:dicoding_story_fl/infrastructures/repos.dart';

part '_res/register_services.dart';
part '_res/register_use_cases.dart';

/// Private to prevent direct dependency registration.
final _locator = GetIt.instance;

/// Get dependency from container.
T get<T extends Object>() => _locator();

/// Register dependecies from `lib/container/_res/`.
Future<void> init() async {
  _registerServices();
  _registerUseCases();

  await _locator.allReady();
}
