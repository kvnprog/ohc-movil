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
                  const SizedBox(height: 35),
                  SizedBox(
                    height: 450,
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
    return Column(
      children: [
        Container(
        width: double.infinity,
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          
          itemCount: lenghtData,
          //itemCount: whichIndex(),
    
            itemBuilder: (BuildContext context, int index)=>ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 33.0),
              children: [
                 PlacesInteraction( 
                  fun: (){
                    setState(() {});
                    ProviderListener changeItemConfiguration = Provider.of<ProviderListener>(context, listen: false);
                    Places itemUpdated = changeItemConfiguration.placeSelected = verMasListas(index);                  
                    return  itemUpdated;
                  },
                  item: verMasListas(index),
                  func: (){
                    if(hasBeenCanceled == true){
                        ProviderListener changeItemConfiguration = Provider.of<ProviderListener>(context, listen: false);
                        return  changeItemConfiguration.setBoolValue = null;                 
                    }
                  },
                ),
              ],
            ),
        )
      ),
      ]
    );
  }

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
