import "package:flutter/foundation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/libs/extensions.dart";
import "package:dicoding_story_fl/service_locator.dart";
import "package:dicoding_story_fl/use_cases.dart";

part "story_detail_provider.g.dart";

@protected
@riverpod
FutureOr<Story> storyDetail(StoryDetailRef ref, String storyId) async {
  try {
    return await ServiceLocator.find<GetStoryByIdUseCase>().execute(storyId);
  } catch (err, trace) {
    final exception = err.toAppException(trace: trace);

    throw exception;
  }
}
