import 'package:equatable/equatable.dart';

class SimpleException extends Equatable implements Exception {
  const SimpleException({
    this.name = 'Internal App Error',
    this.message = 'Sorry for the inconvenience',
    this.error,
    this.trace,
  });

  final String name;
  final String message;

  /// Raw error instance.
  final Object? error;

  /// Stack trace of the [error].
  final StackTrace? trace;

  @override
  List<Object?> get props => [name, message, error];
}

class SimpleHttpException extends SimpleException {
  SimpleHttpException({
    int? statusCode,
    super.message,
    super.error,
    super.trace,
  })  : statusCode =
            _httpErrorResponses.containsKey(statusCode) ? statusCode : null,
        super(
          name: statusCode == null
              ? 'Internal App Error'
              : _httpErrorResponses[statusCode] ?? 'Internal App Error',
        );

  /// HTTP response status code.
  ///
  /// Will be `null` if not an HTTP error.
  final int? statusCode;

  static Map<int, String> get _httpErrorResponses =>
      {..._clientErrorResponses, ..._serverErrorResponses};

  /// HTTP
  /// [Client Error Responses](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#client_error_responses)
  /// names map.
  static const _clientErrorResponses = {
    400: 'Bad Request',
    401: 'Unauthorized',
    403: 'Forbidden',
    404: 'Not Found',
    405: 'Method Not Allowed',
    406: 'Not Acceptable',
    407: 'Proxy Authentication Required',
    408: 'Request Timeout',
    409: 'Conflict',
    410: 'Gone',
    411: 'Length Required',
    412: 'Precondition Failed',
    413: 'Payload Too Large',
    414: 'URI Too Long',
    415: 'Unsupported Media Type',
    416: 'Range Not Satisfiable',
    417: 'Expectation Failed',
    418: "I'm a teapot",
    421: 'Misdirected Request',
    422: 'Unprocessable Content',
    423: 'Locked',
    424: 'Failed Dependency',
    426: 'Upgrade Required',
    428: 'Precondition Required',
    429: 'Too Many Requests',
    431: 'Request Header Fields Too Large',
    451: 'Unavailable For Legal Reasons',
  };

  /// HTTP
  /// [Server Error Responses](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#server_error_responses)
  /// names map.
  static const _serverErrorResponses = {
    500: 'Internal Server Error',
    501: 'Not Implemented',
    502: 'Bad Gateway',
    503: 'Service Unavailable',
    504: 'Gateway Timeout',
    505: 'HTTP Version Not Supported',
    506: 'Variant Also Negotiates',
    507: 'Insufficient Storage',
    508: 'Loop Detected',
    510: 'Not Extended',
    511: 'Network Authentication Required',
  };

  @override
  List<Object?> get props => [statusCode, ...super.props];
}
