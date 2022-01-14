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
<<<<<<< HEAD
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
=======
  Widget build(BuildContext context){
    if(_opcionSeleccionada != 'Recorrido'){
      _distance = 80.50;
    }else{
      _distance = 120.0;
    }

    return MultiProvider(
    providers: [
        ChangeNotifierProvider(create: ( _ ) => ProviderListener()
        )
    ],

    child: 
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Recorridos'),
          elevation: 0,
        ),
        body: Padding(

          padding: const EdgeInsets.all(10),
          child: Column(
            children: [

               _dropDownOptions(),

              const SizedBox( height: 35 ),

              if(_opcionSeleccionada == 'Recorrido' && isCanceled!=null)
              _insertPlaces(),

              const SizedBox( height: 35 ),

              SizedBox(
                height: 450,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                     //InteractionMenu(),
                    for(var menu in interactionMenuArray)
                    menu,
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
          if(_opcionSeleccionada == 'Recorrido')
          ActionButton(
            onPressed: (){
              setState(() {});
              if(iconData.icon == const Icon(Icons.play_arrow).icon){
              _mostrarAlerta(context);
              }
              else{
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
            onPressed: (){
              setState(() {});
              int index = interactionMenuArray.length - 1;
              if (index != 0) {
               interactionMenuArray.removeAt(index); 
              }
            },
          ),

          //agregar nuevo campo de crear incidencia
          ActionButton(
            onPressed: (){
              setState((){});
              interactionMenuArray.add(InteractionMenu());
            },//_showAction(context, 0),
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

>>>>>>> 4d74ac102c3e4e1efd58783db6a12fc801044d4d
}
