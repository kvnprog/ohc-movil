import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recorridos_app/screens/screens.dart';
import 'package:recorridos_app/services/provider_listener_service.dart';

void main() => runApp(MyApp());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProviderListener())],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  String rute = '';

  @override
  Widget build(BuildContext context) {
    if (_readData() == 'none') {
      print("object");
      rute = 'deviceAuth';
    } else {
      print('vamos al login');
      rute = 'login';
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recorridos',
      initialRoute: rute,
      routes: {
        'login': (_) => const LoginScreen(),
        'home': (_) => const HomeToursScreen(),
        'deviceAuth': (_) => AlertPage()
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[850],
        appBarTheme: const AppBarTheme(backgroundColor: Colors.amber),
      ),
    );
  }

  whichIsTheScreen() {
    return AlertPage();
  }

  Future<String> _readData() async {
    final prefs = await SharedPreferences.getInstance();

    // Intenta leer datos de la clave del contador. Si no existe, retorna 0.
    final counter = prefs.getString('counter') ?? 'none';

    print('estoy leyendo');
    print(counter);

    return counter;
  }
}

class AlertPage extends StatelessWidget {
  AlertPage({Key? key}) : super(key: key);

  late String code;
  @override
  Widget build(BuildContext context) {
    // _readData();
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Image.asset(
                'assets/movil.png',
                color: Colors.white,
                height: 100,
                width: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                'Dispositvo Desconocido',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    code = value;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Por favor ingrese el código de desbloqueo',
                    hintStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w200),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: MaterialButton(
                        child: const Text('Aceptar'),
                        color: Colors.amber,
                        onPressed: () {
                          _saveData();
                        }),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  //guardar el código en el dispositivo
  _saveData() async {
    // obtener preferencias compartidas
    final prefs = await SharedPreferences.getInstance();

    // fijar valor
    prefs.setString('counter', code);
    print('ya di el valor');
  }
}
