import 'package:flutter/material.dart';

class AlertPage extends StatelessWidget {
  const AlertPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert Page'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Mostrar alerta'),
          onPressed: () =>_mostrarAlerta(context),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            shape: const StadiumBorder()
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.backpack),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
    );
  }

  void _mostrarAlerta(BuildContext context){

    showDialog(
      context: context,
      //se puede cerrar haciendo click al rededor de la pantalla
      barrierDismissible: false,
      builder: (context){

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0)
          ),
          title: const Text('Título'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              Text('Este es el contenido de la caja de la alerta'),
              FlutterLogo( size: 100 )
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: ()=>Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: ()=>Navigator.of(context).pop(),
            )
          ],

        );
      }
    );
  }

}