import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:recorridos_app/services/provider_listener_service.dart';
import 'package:recorridos_app/widgets/widgets.dart';

void main() => runApp(HomeToursScreen());

class HomeToursScreen extends StatefulWidget {  
  @override
  State<HomeToursScreen> createState() => _HomeToursScreenState();
  
}

class _HomeToursScreenState extends State<HomeToursScreen> {
  final List<String> _actionType = ['Registrar caso especial', 'Recorrido'];
  dynamic _opcionSeleccionada = 'Recorrido';
  double _distance = 120.0;

  Icon iconData = const Icon(Icons.play_arrow);

  PlacesArrayAvailableData dataList = PlacesArrayAvailableData(); 

  List<InteractionMenu> interactionMenuArray = [InteractionMenu(), ];
  List<Places> mainArray = [];
  List<Places> mainArrayReset = [];

  String timeValue = '-1';
  bool? isCanceled;
  bool hasBeenCanceled = false;
}
