import 'dart:async';
import 'package:rxdart/rxdart.dart';

class SearchBloc
{
  final _rutController = BehaviorSubject<String>();
  final _periodoController = BehaviorSubject<String>();
  final _tipoPagoController = BehaviorSubject<String>();

  // Recuperar datos del stream
  Stream<String> get rutStream => _rutController.stream;
  Stream<String> get periodoStream => _periodoController.stream;
  Stream<String> get tipoPagoStream => _tipoPagoController.stream;

  Stream<bool> get formValidStream =>
      Rx.combineLatest3(rutStream, periodoStream, tipoPagoStream, (e, p, c) => true);

  // Insertar valores al stream
  Function(String) get changeRut => _rutController.sink.add;
  Function(String) get changePeriodo => _periodoController.sink.add;
  Function(String) get changeTipoPago => _tipoPagoController.sink.add;

  // Obtener el ultimo valor ingresado a los streams
  String get rut => _rutController.value;
  String get periodo => _periodoController.value;
  String get tipoPago => _tipoPagoController.value;

  dispose() {
    _rutController?.close();
    _periodoController?.close();
    _tipoPagoController?.close();
  }
}