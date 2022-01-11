import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recorridos_app/data/data.dart';
import 'package:recorridos_app/data/places_data_class.dart';
import 'package:recorridos_app/services/provider_listener_service.dart';
import 'package:recorridos_app/widgets/widgets.dart';

// ignore: must_be_immutable
class PlacesInteraction extends StatefulWidget {
  Places item;
  Places Function()? fun;
  Function()? func;
  int numeroDeIncidencias;

  PlacesInteraction({Key? key, 
    required this.item,
    required this.numeroDeIncidencias,
    this.fun,
    this.func
  }) : super(key: key);

  
    @override
  _PlacesInteractionState createState() => _PlacesInteractionState();
}

class _PlacesInteractionState extends State<PlacesInteraction> {
  late Color color;
  Color? colorActive = Colors.amber;
  Color colorEnabled = Colors.grey;

  @override
  Widget build(BuildContext context) {
    final changeItemConfiguration = Provider.of<ProviderListener>(context, listen: false);
    if(widget.func != null){
      widget.func!();
    }

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProviderListener())],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          itemClickeable(changeItemConfiguration),
          Text(
            widget.item.name,
            maxLines: null,
            style: const TextStyle(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
   
    Stack itemClickeable(ProviderListener changeItemConfiguration) {
    return Stack(
            children: [
              Container(
                child: ClipOval(
                  child: Material(
                    color: colorEnabled,
                    child: InkWell(
                      splashColor: colorActive,
    
                      child: SizedBox(
                        width: 65,
                        height: 65,
                        child: Icon(widget.item.icon),
                      ),

                      onTap: (){
                        setState(() {});
                        final time = '${TimeOfDay.now().hour}:${TimeOfDay.now().minute}';
                        
                        //verifica si hay un item seleccionado para así no seleccionar otros sin antes haber finalizado el actual
                          if(changeItemConfiguration.itemIsReady == null){
                            print("if 1");
                            colorActive = Colors.amber;
                            //colorEnabled = Colors.grey;
                            changeItemConfiguration.setBoolValue = widget.item;
                            widget.fun!();
                            changeItemConfiguration.placeAffected;
                            widget.item.timeStart = time;
                          }else{
                            //se activa para darle una hora final a un item 
                            if(changeItemConfiguration.itemIsReady!.name == widget.item.name){
                                print("if 2");
                                widget.fun!();
                                widget.item.timeEnd = time;
                                
                                changeItemConfiguration.placeAffected;
                                setState(() {
                                  colorActive = Colors.transparent;
                                  color = Colors.blue;
                                  //colorEnabled = Colors.white10;
                                });
                                if(widget.item.numeroDeIncidencias == 0){
                                  widget.item.numeroDeIncidencias = widget.numeroDeIncidencias;
                                }else{
                                  print('ya tiene incidencias generadas así que no se guardan');
                                }
                                print('hay ${widget.numeroDeIncidencias} incidencias hechas en ${widget.item.name}');
                                
                             
                            }else{
                              //agrega un valor de inicio a un item que no ha sido inicializado
                              if(changeItemConfiguration.itemIsReady!.timeEnd != null){
                                print("if 3");
                                changeItemConfiguration.setBoolValue = widget.item;
                                widget.fun!();
                                changeItemConfiguration.placeAffected;
                                widget.item.timeStart = time;
                              }
                            }
                          }
                      },
                    ),
                  ),
                ),
        ),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              color: isIconActive(),
              border: Border.all(
                color: Colors.grey[850]!,
                width: 2.5,
              ),
              shape: BoxShape.circle),
        ),
      ],
    );
  }

    //metodo que dibuja el color del icono mostrando si está activo o no
    Color isIconActive(){
     if (widget.item.isActive) {
      color = Colors.greenAccent[400]!;
    }else{
        color = Colors.grey;
    }
      if(widget.item.timeEnd != null){
      color = Colors.blue;
    }
  
    return color;
  }

}