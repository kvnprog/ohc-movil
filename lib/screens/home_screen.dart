import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:recorridos_app/services/provider_listener_service.dart';
import 'package:recorridos_app/widgets/timer_counter.dart';
import 'package:recorridos_app/widgets/widgets.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const HomeToursScreen());
var contador = 0;
var recorrido;

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

  Icon iconData = const Icon(Icons.play_arrow);

  PlacesArrayAvailableData dataList = PlacesArrayAvailableData();

  Places? itemSelected;

  Chronometer chrono = Chronometer();
  bool isAvailable = false;

  List<Places> mainArray = [];
  List<Places> mainArrayReset = [];

  String timeValue = '-1';
  bool? isCanceled;
  bool hasBeenCanceled = false;

  bool isActive = false;
  bool tourIsActive = false;

  @override
  Widget build(BuildContext context) {
    MediaQueryData size = MediaQuery.of(context);
    if (_opcionSeleccionada != 'Recorrido') {
      _distance = 80.50;
    } else {
      _distance = 120.0;
    }

    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: ChangeNotifierProvider(
        create: (_) => ProviderListener(),
        child: Consumer<ProviderListener>(
          builder: (context, provider, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Material App',
            home: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: const Text('Recorridos'),
                elevation: 0,
                actions: <Widget>[
                   IconButton(onPressed: ()=> Navigator.of(context).pop('login'), 
                  icon: const Icon(Icons.login_outlined, color: Colors.black, size: 30,)),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [

                    //menú desplegable para elegir recorrido o incidencia normal
                    if(!tourIsActive)
                    _dropDownOptions(),
                    
                    const SizedBox(height: 35),

                  //lista de lugares disponibles para recorrer
                    if (_opcionSeleccionada == 'Recorrido' && isCanceled != null)
                    _insertPlaces(),

                    const SizedBox(height: 10),

                  //menú de interacción para generar incidencias
                    _deleteIncidenceOptions(provider, size)
                  ],
                ),
              ),
              floatingActionButton: _floatingActionButtonOptions(provider),
            ),
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.grey[850],
              appBarTheme: const AppBarTheme(backgroundColor: Colors.amber),
            ),
          ),
        ),
      ),
    );
  }

  Widget _deleteIncidenceOptions(ProviderListener provider, MediaQueryData size){
    if (provider.itemIsReady?.timeEnd != null) {
      if (interactionMenuArray.isNotEmpty) {
        interactionMenuArray.removeRange(0, interactionMenuArray.length);
        contador = 0;
      }
    }
    return SizedBox(
      child: Container(
        height: size.size.height / 1.8,
        child: ListView(
          shrinkWrap: true,
          children: [
            for (var menu in interactionMenuArray) menu,
          ],
        ),
      ),
    );
  }

  Widget _floatingActionButtonOptions(ProviderListener provider) {
    return ExpandableFab(
      distance: _distance,
      children: [
        //finalizar el recorrido
        if (_opcionSeleccionada == 'Recorrido')
          ActionButton(
            onPressed: () async {
              setState(() {});
              if (iconData.icon == const Icon(Icons.play_arrow).icon) {
                _mostrarAlerta(context);
              } else {
                //botón de detener
                await terminarrecorrido();
                iconData = const Icon(Icons.play_arrow);
                getTimeValue;
                isCanceled = true;
                tourIsActive = false;
                setState(() {});
                provider.itemIsReady = null;
              }
            },
            icon: iconData,
          ),

        //eliminar un campo de incidencia
        if (isActive == true && isCanceled == false || _opcionSeleccionada != 'Recorrido')
          ActionButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              setState(() {});
              int index = interactionMenuArray.length - 1;
              if (index != -1) {
                if (interactionMenuArray[index].btnsave == true) {
                  interactionMenuArray.removeAt(index);
                  contador -= 1;
                }
              }
            },
          ),

        //agregar nuevo campo de crear incidencia
        if (isActive == true && isCanceled == false || _opcionSeleccionada != 'Recorrido')
          ActionButton(
            onPressed: () {
              setState(() {});
              if (contador != 9) {
                contador += 1;
                interactionMenuArray.add(InteractionMenu(
                    index: contador,
                    recorrido: recorrido,
                    usuario: widget.usuario,
                    btnsave: true));
              } else {
                // _showToast(context, 'Solo se puede Agregar 10 Incidencias');
              }
            }, //_sh_showAction(context, 0),
            icon: const Icon(Icons.new_label_sharp),
          ),
      ],
    );
  }

  Widget _insertPlaces() {
    final lenghtData = dataList.arrayPlaces.length;

    placesArray();
    return Column(children: [
      Container(
          width: double.infinity,
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,

            itemCount: lenghtData,
            //itemCount: whichIndex(),

            itemBuilder: (BuildContext context, int index) => ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 33.0),
              children: [
                PlacesInteraction(
                  fun: () {
                    setState(() {});
                    ProviderListener changeItemConfiguration =
                        Provider.of<ProviderListener>(context, listen: false);
                    Places itemUpdated = changeItemConfiguration.placeSelected =
                        verMasListas(index);
                    return itemUpdated;
                  },
                  item: verMasListas(index),
                  func: () {
                    if (hasBeenCanceled == true) {
                      ProviderListener changeItemConfiguration =
                          Provider.of<ProviderListener>(context, listen: false);
                      return changeItemConfiguration.setBoolValue = null;
                    }
                  },
                  numeroDeIncidencias: interactionMenuArray.length,
                ),
              ],
            ),
          )),
    ]);
  }

  Widget _dropDownOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        //const Icon(Icons.select_all),
        const SizedBox(width: 30.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
          child: DropdownButton(
              value: _opcionSeleccionada,
              items: getItemsDropDown(),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              underline: Container(
                color: Colors.white,
              ),
              onChanged: (opt) {
                setState(() {
                  _opcionSeleccionada = opt;
                });
              }),
        )
      ],
    );
  }

  List<DropdownMenuItem<String>> getItemsDropDown() {
    List<DropdownMenuItem<String>> lista = [];

    for (var element in _actionType) {
      lista.add(DropdownMenuItem(
        child: Text(element),
        value: element,
      ));
    }

    return lista;
  }

  verMasListas(int index) {
    int mIndex = index;
    List<Places> arrayList = dataList.arrayPlaces;
    Map arrayListMap = arrayList.asMap();
    Places thisItem = arrayListMap[mIndex];
    return thisItem;
  }

  Future<String> crearrecorrido() async {
    var url =
        Uri.parse("https://pruebasmatch.000webhostapp.com/crear_recorrido.php");
    var respuesta = await http.post(url, body: {
      "quien_capturo": widget.usuario,
    });

    return respuesta.body;
  }

  Future<String> terminarrecorrido() async {
    var url = Uri.parse(
        "https://pruebasmatch.000webhostapp.com/terminar_recorrido.php");
    var respuesta = await http.post(url, body: {
      "index": recorrido,
    });
    print('existo');
    return respuesta.body;
  }

  //llena un arreglo local con los valores de la dataClass
  List<Places> placesArray() {
    if (isCanceled!) {
      mainArray.clear();
      for (var item in dataList.arrayPlaces) {
        item.isActive = false;
        item.timeEnd = null;
        item.timeStart = null;

        mainArray.add(item);
        hasBeenCanceled = true;
      }
    } else {
      for (var item in dataList.arrayPlaces) {
        mainArray.add(item);
      }
      hasBeenCanceled = false;
    }
    return mainArray;
  }

  void _mostrarAlerta(BuildContext context) {
    late String message;

    if (iconData.icon == const Icon(Icons.stop).icon) {
      message = 'Detener recorrido';
    } else {
      message = 'Iniciar recorrido';
    }

    showDialog(
        context: context,
        //se puede cerrar haciendo click al rededor de la pantalla
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: const Text('Estás por iniciar un nuevo recorrido'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                 Text('Si aceptas, el tiempo empezará a contar inmediatamente y finalizará hasta que detengas el recorrido.'),
                  
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(message),
                onPressed: () async {
                  String time =
                      "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}";
                  recorrido = await crearrecorrido();
                  setState(() {});
                  Navigator.of(context).pop();
                  iconData = const Icon(Icons.stop);
                  isCanceled = false;
                  setTimeValue = time;
                  isActive = true;
                  tourIsActive = true;
                },
              ),
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  set setTimeValue(String newTimeValue) {
    timeValue = newTimeValue;
  }

  get getTimeValue {
    return timeValue;
  }

}
