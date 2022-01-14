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
  

  @override
  Widget build(BuildContext context) {
    MediaQueryData size = MediaQuery.of(context);
    if (_opcionSeleccionada != 'Recorrido') {
      _distance = 80.50;
    } else {
      _distance = 120.0;
    }

    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => ProviderListener())],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Material App',
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('Recorridos'),
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  _dropDownOptions(),
                  const SizedBox(height: 35),
                  if (_opcionSeleccionada == 'Recorrido' && isCanceled != null)
                    _insertPlaces(),
                  const SizedBox(height: 10),
                  SizedBox(
                    child: Container(
                      height: size.size.height / 1.8,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          for (var menu in interactionMenuArray) menu,
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton: ExpandableFab(
              distance: _distance,
              children: [
                //finalizar el recorrido
                if (_opcionSeleccionada == 'Recorrido')
                  ActionButton(
                    onPressed: () {
                      setState(() {});
                      if (iconData.icon == const Icon(Icons.play_arrow).icon) {
                        _mostrarAlerta(context);
                      } else {
                        //botón de detener
                        iconData = const Icon(Icons.play_arrow);
                        getTimeValue;
                        isCanceled = true;
                      }
                    },
                    icon: iconData,
                  ),

                //eliminar un campo de incidencia
                ActionButton(
                  icon: const Icon(Icons.delete_forever),
                  onPressed: () {
                    setState(() {});
                    int index = interactionMenuArray.length - 1;
                    if (index != -1) {
                      interactionMenuArray.removeAt(index);
                      contador -= 1;
                    }
                  },
                ),

                //agregar nuevo campo de crear incidencia
                ActionButton(
                  onPressed: () {
                    setState(() {});
                    if (contador != 9) {
                      contador += 1;
                      interactionMenuArray.add(InteractionMenu(
                        index: contador,
                        usuario: widget.usuario,
                      ));
                    } else {}
                  }, //_sh_showAction(context, 0),
                  icon: const Icon(Icons.new_label_sharp),
                ),
              ],
            ),
          ),
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.grey[850],
            appBarTheme: const AppBarTheme(backgroundColor: Colors.amber),
          ),
        ));
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
                Text(
                    'Si aceptas, el tiempo empezará a contar inmediatamente y finalizará hasta que detengas el recorrido.'),
                FlutterLogo(
                  size: 100.0,
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text(message),
                onPressed: () {
                  String time =
                      "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}";
                  setState(() {});
                  Navigator.of(context).pop();
                  iconData = const Icon(Icons.stop);
                  isCanceled = false;
                  setTimeValue = time;
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
