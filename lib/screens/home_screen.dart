import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:recorridos_app/services/provider_listener_service.dart';
import 'package:recorridos_app/widgets/timer_counter.dart';
import 'package:recorridos_app/widgets/widgets.dart';

void main() => runApp(const HomeToursScreen());
var contador = 0;

class HomeToursScreen extends StatefulWidget {
  final String? usuario;
  const HomeToursScreen({Key? key, this.usuario}) : super(key: key);

  @override
  State<HomeToursScreen> createState() => _HomeToursScreenState();
}

class _HomeToursScreenState extends State<HomeToursScreen> {
  final List<String> _actionType = ['Registrar caso especial', 'Recorrido'];
  dynamic _opcionSeleccionada = 'Recorrido';
  double _distance = 120.0;
  List<InteractionMenu> interactionMenuArray = [];
  final dataList = PlacesArrayAvailableData();

  Places? itemSelected;

  Chronometer chrono = Chronometer();
  bool isAvailable = false;

 
