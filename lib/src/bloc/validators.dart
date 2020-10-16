import 'dart:async';

class Validators {
  final validarPassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.length >= 8) {
        sink.add(password);
      } else {
        sink.addError('Debe tener mas de 8 caracteres');
      }
    }
  );
}