import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';

List<String> fotopreview = ['', '', '', '', '', '', '', '', '', ''];
List<int>? imageBytes;
String? base64Image;

class InteractionMenu extends StatefulWidget {
  final String? usuario;
  final index;
  const InteractionMenu({Key? key, this.usuario, this.index}) : super(key: key);

  @override
  _InteractionMenuState createState() => _InteractionMenuState();
}

class _InteractionMenuState extends State<InteractionMenu> {
  final comentario = TextEditingController();
  double height = 15;
  bool btnsave = true;
  bool btnload = true;
  //lista de acciones disponibles
  final List<String> _actionType = [
    'Acción',
    'Acción 1',
    'Acción 2',
    'Acción 3',
    'Acción 4',
    'Acción 5',
  ];
  dynamic _opcionSeleccionada = 'Acción';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25, left: 25, right: 25),
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: comentario,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Ingrese un comentario',
                icon: Icon(
                  Icons.comment_sharp,
                  color: Colors.amber,
                ),
                hintMaxLines: 3,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber, width: 2)),
              ),
            ),
            SizedBox(height: height),
            const Divider(),
            (fotopreview[widget.index] == '')
                ? (const Text(''))
                : (Transform.rotate(
                    angle: 0,
                    child: Transform.scale(
                        scale: 0.70,
                        child: Image.file(
                          File(fotopreview[widget.index]),
                        )))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /*  //acciones a mostrar
                MaterialButton(
                  onPressed: (){
                    
                  },
                  color: Colors.amber,
                  elevation: 1,
                  child: Row(
                    children: const [
                      Icon(Icons.warning_outlined),
                      SizedBox(width: 5),
                      Text('Acción')
                    ],
                  ),
                ), */
                _dropDownOptions(),
                // capturar foto de la incidencia
                MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DisplayPictureScreen(),
                      ),
                    ).then((value) {
                      if (value == null) {
                        if (fotopreview[widget.index] != '') {
                          print("imagen ${fotopreview[widget.index]}");
                        }
                      } else {
                        fotopreview[widget.index] = value;
                      }

                      print(widget.index);

                      setState(() {});
                    });
                  },
                  color: Colors.amber,
                  elevation: 1,
                  child: Row(
                    children: const [
                      Icon(Icons.camera_alt_sharp),
                      SizedBox(width: 5),
                      Text('Foto'),
                    ],
                  ),
                ),

                //guardar la incidencia
                MaterialButton(
                  onPressed: btnsave
                      ? () async {
                          print(widget.usuario);
                          print(widget.key);
                          // print(base64Image);
                          var url = Uri.parse(
                              "https://pruebasmatch.000webhostapp.com/crear_incidencia_recorrido.php");

                          Future<void> pedirdatos() async {
                            await http.post(url, body: {
                              "comentario": "${comentario.text}",
                              "imagen": base64Image,
                              "usuario": widget.usuario,
                            });
                            // final List json = jsonDecode(respuesta.body.toString());
                          }

                          imageBytes =
                              File(fotopreview[widget.index]).readAsBytesSync();
                          base64Image = base64Encode(imageBytes!);
                          btnload = false;
                          setState(() {});
                          await pedirdatos();
                          btnload = true;
                          btnsave = false;
                          setState(() {});
                        }
                      : (null),
                  disabledColor: Colors.greenAccent[400],
                  color: Colors.amber,
                  elevation: 1,
                  child: Row(
                    children: [
                      btnsave
                          ? btnload
                              ? const Icon(Icons.save_sharp)
                              : const SizedBox(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                    color: Colors.black,
                                  ),
                                  height: 15,
                                  width: 15,
                                )
                          : const Text('Guardado'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropDownOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          height: 38,
          decoration: const BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.all(Radius.circular(3.0))),
          child: DropdownButton(
              value: _opcionSeleccionada,
              items: getItemsDropDown(),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              dropdownColor: Colors.amber[200],
              icon: const Icon(
                Icons.warning_outlined,
                color: Colors.black,
                size: 25.0,
              ),
              underline: Container(
                color: Colors.white,
              ),
              onChanged: (opt) {
                setState(() {
                  _opcionSeleccionada = opt;
                });
              }),
        ),
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
}

class DisplayPictureScreen extends StatefulWidget {
  const DisplayPictureScreen({Key? key}) : super(key: key);

  @override
  _DisplayPictureScreen createState() => _DisplayPictureScreen();
}

class _DisplayPictureScreen extends State<DisplayPictureScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  Future<void> iniciar() async {
    final cameras = await availableCameras();

    _controller = CameraController(
      // Obtén una cámara específica de la lista de cámaras disponibles
      cameras.first,
      // Define la resolución a utilizar
      ResolutionPreset.medium,
    );

    // A continuación, debes inicializar el controlador. Esto devuelve un Future!
    _initializeControllerFuture = _controller!.initialize();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    iniciar();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // La imagen se almacena como un archivo en el dispositivo. Usa el
      // constructor `Image.file` con la ruta dada para mostrar la imagen
      body: Column(
        children: [
          SizedBox(
            width: 410,
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // Si el Future está completo, muestra la vista previa

                  return Transform.rotate(
                      angle: 0, child: CameraPreview(_controller!));
                } else {
                  // De lo contrario, muestra un indicador de carga
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          FloatingActionButton(
            child: const Icon(Icons.camera_alt),
            // Agrega un callback onPressed
            onPressed: () async {
              try {
                await _initializeControllerFuture;
                XFile foto = await _controller!.takePicture();
                // fotopreview = foto.path;
                // fotopreview = '';
                Navigator.pop(context, foto.path);
              } catch (e) {
                // Si se produce un error, regístralo en la consola.
                print(e);
              }
            },
          ),
        ],
      ),
    );
  }
}
