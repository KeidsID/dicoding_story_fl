import "package:chopper/chopper.dart";
import "package:dicoding_story_fl/domain/entities.dart";

AppException handleApiErrorResponse(
  ChopperHttpException exception, [
  StackTrace? trace,
]) {
  final errorBody = exception.response.error! as Map<String, dynamic>;

  return AppException(
    error: exception,
    trace: trace,
    message: errorBody["message"] ?? "Unknown Error",
  );
}
