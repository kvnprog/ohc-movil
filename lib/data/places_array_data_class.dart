//here are all places available in array form
import 'package:flutter/material.dart';
import 'package:recorridos_app/data/data.dart';

class PlacesArrayAvailableData{
  List<Places> arrayPlaces = [];

  PlacesArrayAvailableData(){
    arrayPlaces.add(Places(icon: Icons.fastfood, name: 'Cocina', isActive: false, timeStart: null, timeEnd: null));
    arrayPlaces.add(Places(icon: Icons.monitor_sharp, name: 'Oficina', isActive: false, timeStart: null, timeEnd: null));
    arrayPlaces.add(Places(icon: Icons.filter_alt_sharp, name: 'Filtro', isActive: false, timeStart: null, timeEnd: null));
    arrayPlaces.add(Places(icon: Icons.medical_services_rounded, name: 'Consultorio', isActive: false, timeStart: null, timeEnd: null));
    arrayPlaces.add(Places(icon: Icons.auto_awesome, name: 'Calidad', isActive: false, timeStart: null, timeEnd: null));
    arrayPlaces.add(Places(icon: Icons.commute_sharp, name: 'Estacionamiento', isActive: false, timeStart: null, timeEnd: null));

    showValuesArray();
  }

  List<Places> showValuesArray(){
    return arrayPlaces;
  }

}