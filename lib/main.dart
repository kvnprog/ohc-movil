import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recorridos_app/screens/screens.dart';
import 'package:recorridos_app/services/provider_listener_service.dart';

void main() => runApp(const MyApp());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProviderListener())],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('prueba');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recorridos',
      initialRoute: 'login',
      routes: {
        'login': (_) => const LoginScreen(),
        'home': (_) => const HomeToursScreen()
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[850],
        appBarTheme: const AppBarTheme(backgroundColor: Colors.amber),
      ),
    );
  }
}
