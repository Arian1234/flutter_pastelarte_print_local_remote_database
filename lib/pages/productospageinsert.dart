import 'dart:developer';
import 'dart:io';

import 'package:firebase_orders_flutter/widgets/textformfieldcustom.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class productosPageInsert extends StatefulWidget {
  const productosPageInsert({Key? key}) : super(key: key);

  @override
  State<productosPageInsert> createState() => _productosPageInsertState();
}

class _productosPageInsertState extends State<productosPageInsert> {
  final _globalformkey = GlobalKey<FormState>();
  final _controllernombprod = TextEditingController();
  final _controllerdescripprod = TextEditingController();
  final _controllercantprod = TextEditingController();
  final _controllerstockminprod = TextEditingController();
  final _controllerpreciocostoprod = TextEditingController();
  final _controllerprecioventaprod = TextEditingController();

  dynamic _pickImageError;
  bool isVideo = false;
  List<XFile>? _imageFileList;
  final _formKey = GlobalKey<FormState>();
  String? _retrieveDataError;
  @override
  Widget build(BuildContext context) {
    double _ancho = MediaQuery.of(context).size.width;
    double _alto = MediaQuery.of(context).size.height;
    List<String> listado = ["Tortas", "pies"];
    final valores = [];
    final TextEditingController contr = TextEditingController();
    final ImagePicker _picker = ImagePicker();
    Text? _getRetrieveErrorWidget() {
      if (_retrieveDataError != null) {
        final Text result = Text(_retrieveDataError!);
        _retrieveDataError = null;
        return result;
      }
      return null;
    }

    Widget _previewImages() {
      // aqui hace la consulta si hay un error,
      // de acuerdo a ello escribe en el text()
      // error tal tal tal o null
      final Text? retrieveError = _getRetrieveErrorWidget();
      if (retrieveError != null) {
        // aqui pregunta que devolvio el metodo anterior
        return retrieveError;
      }
      // si _imageFileList es diferente de vacio
      // _imageFileList se supone que debe de haber sido
      // cargado en el anterior future
      // como una imagen o varias
      if (_imageFileList != null) {
        // un semantic es un widget
        // similar a un tooltip pero interno para el sistema
        return Form(
          key: _formKey,
          child: Semantics(
            label: 'image_picker_example_picked_images',
            child: ListView.builder(
              itemCount: _imageFileList!.length,
              key: UniqueKey(),
              itemBuilder: (BuildContext context, int index) {
                print('handlesPreview/_previewImages se acaba de ejecutar');

                // Why network for web?
                // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
                return Semantics(
                  label: 'image_picker_example_picked_image',
                  // devuelvo una imagen de acuerdo a si se
                  // esta ejecutando en una web o en android
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 12),
                    // width: (MediaQuery.of(context).size.width) * .4,
                    child: Column(
                      children: [
                        kIsWeb
                            ? Image.network(_imageFileList![index].path)
                            : Image.file(File(_imageFileList![index].path)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 42),
                          child: TextField(
                            controller: TextEditingController(),
                            keyboardType: TextInputType.text,
                          ),
                        )
                      ],
                    ),
                  ),
                );
                valores.add(contr.value);
              },
            ),
          ),
        );
      }
      // no hay imagenes
      // y hay un error que se haya registrado en _pickImageError
      // entonces

      else if (_pickImageError != null) {
        return Text(
          'Pick image error: $_pickImageError',
          textAlign: TextAlign.center,
        );
      }
      // y si no es asi,entonces no has elegido ninguna imagen
      else {
        return const Text(
          'Aun no haz elegido una imagen.',
          textAlign: TextAlign.center,
        );
      }
    }

    Widget _handlePreview() {
      if (isVideo) {
        // si es video el future
        return Text('nel... video.');
        // return _previewVideo();
      } else {
        // si es imagen el future
        return _previewImages();
      }
    }

    void _setImageFileListFromFile(XFile? value) {
      // capturamos el parametro y lo asignamos a _imageFileList
      // luego preguntamos si es null
      // si es null entonces devuelvo null
      // si no _imageFileList es el archivo value
      print(
          'Soy una imagen /se acaba de establecer una imagen con _setImageFileListFromFile');
      _imageFileList = value == null ? null : <XFile>[value];
    }

    Future<void> retrieveLostData() async {
      // retornamos los datos posibles perdidos al ser destruido el mainActivity
      final LostDataResponse response = await _picker.retrieveLostData();
      if (response.isEmpty) {
        print('Me ejecute pero no encontre ninguna imagen cargada');
        return;
      }
      if (response.file != null) {
        print('Ahora si files pero no se si es una o varias imagenes');
        // si hay algo perdidijirijillo
        // y si es un video
        if (response.type == RetrieveType.video) {
          print('Soy un video');
          isVideo = true;
          // await _playVideo(response.file);
        } else {
// a pero si no es video,es una imagen entonces :)
          isVideo = false;
          setState(() {
            //Hasta aqui se sabe que es una imagen,ahora queremos saber si es una o varias imagenes
            // y aqui preguntamos si son varios "archivos"
            if (response.files == null) {
              // es una imagen
              _setImageFileListFromFile(response.file);
            } else {
              // son varias imagencillas
              _imageFileList = response.files;

              print('cargo sobre mi lomo varias imagenes(plural)');
            }
          });
        }
      } else {
        // si no hay archivos que recuperar
        // y le mando una exception
        _retrieveDataError = response.exception!.code;
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
      ),
      body: SingleChildScrollView(
        key: _globalformkey,
        child: Form(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: _ancho,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: _ancho * .3,
                        height: _ancho * .3,
                        // color: Colors.pink[100],
                        decoration: BoxDecoration(
                            color: Colors.pink[100],
                            borderRadius: BorderRadius.circular(5)),
                        child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Seleccionar la fuente'),
                                      content: Container(
                                        width: _ancho * .5,
                                        height: _alto * .15,
                                        child: Column(
                                          children: const [
                                            ListTile(
                                              title: Text('Cámara'),
                                              trailing: Icon(Icons.camera),
                                              onTap: null,
                                            ),
                                            ListTile(
                                                title: Text('Galeria'),
                                                trailing: Icon(
                                                    Icons.image_search_rounded))
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: const FadeInImage(
                                placeholder: AssetImage('assets/logo.png'),
                                image: AssetImage('assets/camera.jpg'))),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textformfield(
                        ancho: _ancho * .75,
                        controllercategoria: _controllernombprod,
                        // hinttext: '',
                        textinputype: TextInputType.text,
                        habilitado: true,
                        label: 'Nombre del producto',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      textformfield(
                        ancho: _ancho * .9,
                        controllercategoria: _controllerdescripprod,
                        // hinttext: 'descripcion',
                        textinputype: TextInputType.text,
                        habilitado: true,
                        label: 'Descripción',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          width: _ancho * .6,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.teal[100],
                              border:
                                  Border.all(width: 1, color: Colors.black38),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: Row(
                            children: [
                              Container(
                                  width: _ancho * .25,
                                  margin: EdgeInsets.only(left: 9),
                                  child: const Text('Categoría:')),
                              DropdownButton(items: [], onChanged: null),
                            ],
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          textformfield(
                            ancho: _ancho * .44,
                            controllercategoria: _controllercantprod,
                            // hinttext: 'id',
                            textinputype: TextInputType.text,
                            habilitado: true,
                            label: 'Cant. del producto',
                          ),
                          SizedBox(
                            width: _ancho * .02,
                          ),
                          textformfield(
                            ancho: _ancho * .44,
                            controllercategoria: _controllerstockminprod,
                            // hinttext: 'id',
                            textinputype: TextInputType.text,
                            habilitado: true,
                            label: 'Cant. mínima',
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          textformfield(
                            ancho: _ancho * .44,
                            controllercategoria: _controllerpreciocostoprod,
                            // hinttext: 'id',
                            textinputype: TextInputType.text,
                            habilitado: true,
                            label: 'Precio costo',
                          ),
                          SizedBox(
                            width: _ancho * .02,
                          ),
                          textformfield(
                            ancho: _ancho * .44,
                            controllercategoria: _controllerprecioventaprod,
                            // hinttext: 'id',
                            textinputype: TextInputType.text,
                            habilitado: true,
                            label: 'Precio venta',
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          width: _ancho * .6,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.green[100],
                              border:
                                  Border.all(width: 1, color: Colors.black38),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: Row(
                            children: [
                              Container(
                                  width: _ancho * .25,
                                  margin: EdgeInsets.only(left: 9),
                                  child: const Text('Despacho inst.:')),
                              Switch(value: true, onChanged: null)
                            ],
                          )),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {},
            child: const Icon(
              Icons.bookmark_add_sharp,
              size: 30,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
