import 'package:flutter/foundation.dart';

class ErrorHandler implements Exception {
  final dynamic _message;
  final dynamic _title;
  dynamic get message => _message;
  dynamic get title => _title;
  @override
  String toString() {
  //  if (kDebugMode) {
      print("Error Handler : $_message");
  //  }
    return '$_title$_message';
  }

  ErrorHandler(this._message, this._title);
}

class NoConnectionException extends ErrorHandler {
  NoConnectionException(message) : super(message, 'No internet Connection');
}

class FetchDataError extends ErrorHandler {
  FetchDataError(message) : super(message, 'Failed to get data');
}

class BadRequestError extends ErrorHandler {
  BadRequestError(message) : super(message, 'Invalid request');
}

class UnauthorisedError extends ErrorHandler {
  UnauthorisedError(message) : super(message, 'Unauthorised');
}

class InvalidInputError extends ErrorHandler {
  InvalidInputError(message) : super(message, 'Invalid input');
}

class DataParsingException extends ErrorHandler {
  DataParsingException(message) : super(message, 'Invalid Data');
}
