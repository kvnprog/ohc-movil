import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get_mac/get_mac.dart';

class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String usuario = '';
  String password = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isloading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  var url =
      Uri.parse("https://pruebasmatch.000webhostapp.com/checar_login.php");

  Future<String> pedirdatos() async {
    String direccion = await GetMac.macAddress;

    print("direcion mac: $direccion");

    var respuesta = await http.post(url, body: {
      "usuario": usuario,
      "contraseña": password,
      "direccion": direccion
    });
    // final List json = jsonDecode(respuesta.body.toString());
    print(respuesta.body);
    return respuesta.body;
  }

  Future<bool> isValidForms() async {
    String respuesta = await pedirdatos();
    if (respuesta == 'encontre contraseña y usuario') {
      return _isLoading = true;
    } else {
      return _isLoading = false;
    }
  }
}
