import 'dart:async';

abstract interface class UseCase<RequestDto, ResponseDto> {
  FutureOr<ResponseDto> execute(RequestDto requestDto);
}
