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

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(height: 30),
                  if (_opcionSeleccionada == 'Recorrido') _insertPlaces(),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 375,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        //InteractionMenu(),
                        for (var menu in interactionMenuArray) menu,
                      ],
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
                    onPressed: () {},
                    icon: const Icon(Icons.stop),
                  ),

                //eliminar un campo de incidencia
                ActionButton(
                  icon: const Icon(Icons.delete_forever),
                  onPressed: () {
                    setState(() {});
                    int index = interactionMenuArray.length - 1;
                    if (index != 0) {
                      interactionMenuArray.removeAt(index);
                    }
                  },
                ),

                //agregar nuevo campo de crear incidencia
                ActionButton(
                  onPressed: () {
                    setState(() {});
                    contador += 1;

                    interactionMenuArray.add(InteractionMenu(
                      index: contador,
                      usuario: widget.usuario,
                    ));
                  }, //_showAction(context, 0),
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
    List<Places> placesArray = dataList.arrayPlaces;

    return Column(children: [
      Container(
          width: double.infinity,
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: placesArray.length,
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
    int counter = 1;

    if(counter == 1){
      counter = 2;
    }
    
    int mIndex = index;
    List<Places> arrayList = dataList.arrayPlaces;
    Map arrayListMap = arrayList.asMap();
    Places thisItem = arrayListMap[mIndex];
    return thisItem;
  }
}
