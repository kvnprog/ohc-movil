import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recorridos_app/screens/screens.dart';
import 'package:recorridos_app/services/provider_listener_service.dart';
import 'package:splashscreen/splashscreen.dart';

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

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  String rute = '';
  String mData = '';

  @override
  void initState() {
    super.initState();
    _justStringValue();
    _waitForValue();
  }
 
  @override
  Widget build(BuildContext context){
      return MaterialApp (
      debugShowCheckedModeBanner: false,
      title: 'Recorridos',
      home: SplashScreen(
        backgroundColor: Colors.amber,
        loaderColor: Colors.black,
        navigateAfterFuture: _waitForValue(),
        title: const Text('Splash Screen'),
        image: Image.asset('assets/walker.png'),
      ),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[850],
        appBarTheme: const AppBarTheme(backgroundColor: Colors.amber),
      ),
    );
  }

    Future<String> _readData() async{
      print('estoy leyendo');
      final prefs = await SharedPreferences.getInstance();

      // Intenta leer datos de la clave del contador. Si no existe, retorna 0.
      final counter = prefs.getString('counter') ?? 'none';

      mData = counter;
      return mData;
    }

    _deleteData()async{
      final prefs = await SharedPreferences.getInstance();

      prefs.remove('counter');
    }

    _waitForValue() async{
      if(rute == ''){
        print('espero');
        await _justStringValue();
      }else{
        print('no espero');
      }

      await Future.delayed(const Duration(seconds: 2));
      print('la rute $rute');

      switch(rute){
        case 'deviceAuth':{
         return AlertPage();
        }
        case 'login':{
         return  const LoginScreen();
        }
      }
    }

    _justStringValue(){
       _readData().then((value){
         setState(() {
        if(value == 'none'){
          rute = 'deviceAuth';
        }else{
          rute = 'login';
        }
        });
        return rute;
      });
    }
}

class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Welcome In SplashScreen Package"),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child:  Text(
          "Succeeded!",
          style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
        ),
      ),
    );
  }
}


// ignore: must_be_immutable
class AlertPage extends StatelessWidget {
  AlertPage({Key? key}) : super(key: key);
  
  late String code;
  @override
  Widget build(BuildContext context) {
   // _readData();
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: Column(children: [
          const SizedBox(height: 50),
          Image.asset('assets/movil.png', color: Colors.white, height: 100, width: 200,),

          const SizedBox(height: 20),
          const Text('Dispositvo Desconocido', style: TextStyle(
            color: Colors.white,
            fontSize: 15
          ),),

          Container(
            margin: const EdgeInsets.all(10),
            child: TextField(
              keyboardType: TextInputType.number,
              onChanged: (value){
                code = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                hintText: 'Por favor ingrese el código de desbloqueo',
                hintStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w200
                ),
                
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
                onPressed: (){
                  _saveData();
                }),
              ),
            ],
          )
        ],
        ),
      )
    );
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
