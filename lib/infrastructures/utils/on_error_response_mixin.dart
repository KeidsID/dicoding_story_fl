import 'package:chopper/chopper.dart';

import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/infrastructures/api/responses/common_response.dart';

mixin OnErrorResponseMixin {
  /// Converts [Response] into [SimpleException].
  ///
  /// Only call this when [Response.isSuccessful] is `false` or [Response.body]
  /// is `null`.
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

      return SimpleException(error: res, trace: StackTrace.current);
    } catch (err, trace) {
      return SimpleException(error: err, trace: trace);
    }
  }
}
