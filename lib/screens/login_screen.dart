// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:recorridos_app/providers/login_form_provider.dart';
import 'package:recorridos_app/ui/input_decorations.dart';
import 'package:recorridos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:recorridos_app/screens/screens.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;
import 'package:get_mac/get_mac.dart';

bool? checar;
bool activobtn = false;

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData size = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AuthBackground(
          child: Column(children: [
        SizedBox(height: size.size.height / 4),
        CardContainer(
          child: Column(children: [
            const SizedBox(height: 10),
            Text('Login', style: Theme.of(context).textTheme.headline4),
            const SizedBox(height: 30),

// ChangeNotifierProvider fue importado del package provider
            ChangeNotifierProvider(
              create: (_) => LoginFormProvider(),
              child: const _LoginForm(),
            )
          ]),
        ),
        const SizedBox(height: 50),
      ])),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  String _message = "Not Authorized";

  Future<bool> checkingForBioMetrics() async {
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    return canCheckBiometrics;
  }

  Future<bool> _authenticateMe() async {
// 8. this method opens a dialog for fingerprint authentication.
//    we do not need to create a dialog nut it popsup from device natively.
    bool authenticated = false;

    authenticated = await _localAuthentication.authenticate(
      localizedReason: "Authenticate for Testing", // message for dialog
      useErrorDialogs: true, // show error in dialog
      stickyAuth: true,
    ); // native process

    checar = authenticated;
    return authenticated;
  }

  void _showToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.amber,
      content: Text(
        'Contraseña o Dispositivo incorrecto',
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 2),
    ));
  }

  Future<String> sacarmac() async {
    String mac = await GetMac.macAddress;
    return mac;
  }

  Future<String> checarusuario(authentificacion) async {
    String usuario;
    var url =
        Uri.parse("https://pruebasmatch.000webhostapp.com/buscar_usuario.php");

    var respuesta =
        await http.post(url, body: {"authentificacion": "$authentificacion"});
    usuario = respuesta.body;
    return usuario;
  }

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        //key enlazada a la clase login_form_provider que nos permite gestionar el estado de si está logueado o no (importar provider y configurarlo para poder hacer el enlace)
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Usuario',
                    labelText: 'Usuario',
                    prefixIcon: Icons.person_outline),
                onChanged: (value) => loginForm.usuario = value,
              ),
              const SizedBox(height: 30),
              TextFormField(
                autocorrect: false,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '******',
                    labelText: 'Contraseña',
                    prefixIcon: Icons.lock_outline),
                onChanged: (value) => loginForm.password = value,
                validator: (value) {
                  return (value != null && value.length >= 6)
                      ? null
                      : 'La contraseña debe ser de 6 caracteres';
                },
              ),
              const SizedBox(height: 30),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: activobtn ? Colors.grey : Colors.amber,
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    child: Text(activobtn ? 'Espere' : 'Ingresar',
                        style: const TextStyle(color: Colors.white))),
                onPressed: activobtn
                    ? null
                    : () async {
                        // FocusScope.of(context).unfocus();
                        setState(() {
                          activobtn = true;
                        });
                        await loginForm.isValidForms();
                        setState(() {
                          activobtn = false;
                        });
                        if (loginForm.isLoading == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeToursScreen(
                                usuario: loginForm.usuario,
                              ),
                            ),
                          );
                        } else {
                          _showToast(context);
                        }
                      },
              ),
              const SizedBox(height: 25),
              Align(
                alignment: Alignment.topRight,
                child: MaterialButton(
                  height: 60,
                  shape: const CircleBorder(),
                  disabledColor: Colors.grey,
                  elevation: 0,
                  color: Colors.amber,
                  child: Container(
                    child: const Icon(
                      Icons.fingerprint,
                      color: Colors.white,
                      size: 55.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                  ),
                  onPressed: () async {
                    await checkingForBioMetrics();
                    await _authenticateMe();

                    if (checar == true) {
                      String usuario = await checarusuario(await sacarmac());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeToursScreen(
                            usuario: usuario,
                          ),
                        ),
                      );
                    }

                    // if (_authenticateMe() == true) {
                    //   print(checarusuario(sacarmac()));
                    // }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
