import 'dart:async';

const String _kEmailRule = r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$";
class ValidatorException implements Exception {
  final String message;

  ValidatorException(this.message);
}

class EmailValidator {
  final StreamTransformer<String,String> validateEmail =
  StreamTransformer<String,String>.fromHandlers(handleData: (email, sink){
    final RegExp emailExp = new RegExp(_kEmailRule);

    if (!emailExp.hasMatch(email) || email.isEmpty){
      sink.addError(ValidatorException('Entre a valid email'));
    } else {
      sink.add(email);
    }
  });
}