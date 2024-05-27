import 'package:chopper/chopper.dart';
import 'package:dicoding_story_fl/common/constants.dart';
import 'package:flutter/foundation.dart';

import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/infrastructures/api/responses/common_response.dart';

mixin OnErrorResponseMixin {
  /// Converts fail [Response] into [SimpleHttpException].
  ///
  /// Only call this when [Response.isSuccessful] is `false` or [Response.body]
  /// is `null`.
  @protected
  SimpleHttpException onErrorResponse(Response<Map<String, dynamic>> res) {
    final error = res.error;

    try {
      if (error != null) {
        final errorBody =
            CommonResponse.fromJson(error as Map<String, dynamic>);

        return SimpleHttpException(
          statusCode: res.statusCode,
          message: errorBody.message,
          error: errorBody,
          trace: StackTrace.current,
        );
      }

      return SimpleHttpException(
        statusCode: res.statusCode,
        error: res,
        trace: StackTrace.current,
      );
    } catch (err, trace) {
      kLogger.w('onErrorResponse mixin ', error: err, stackTrace: trace);

      return SimpleHttpException(
        statusCode: res.statusCode,
        error: error,
        trace: StackTrace.current,
      );
    }
  }
}
