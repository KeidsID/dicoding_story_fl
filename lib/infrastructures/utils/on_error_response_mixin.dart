import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';

import 'package:dicoding_story_fl/common/utils.dart';
import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/infrastructures/api/responses/common_response.dart';

mixin OnErrorResponseMixin {
  /// Converts [Response] into [SimpleException].
  ///
  /// Only call this when [Response.isSuccessful] is `false` or [Response.body]
  /// is `null`.
  @protected
  Exception onErrorResponse(Response<Map<String, dynamic>> res) {
    try {
      final error = res.error;

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

      return res.toSimpleException(trace: StackTrace.current);
    } catch (err, trace) {
      return err.toSimpleException(trace: trace);
    }
  }
}
