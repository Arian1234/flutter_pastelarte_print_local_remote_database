// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';

import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker_example/pages/page_cargarimagen.dart';
// import 'package:image_picker_example/widgets/widget_drawer_main.dart';
import 'package:video_player/video_player.dart';
import '../firebase_options.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pasteleria pasteles rosas',
      home: MyHomePage(title: 'Panel de administración'),
      // routes: {'add_image': (context) => pageCargarImagen()},
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<XFile>? _imageFileList;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController contr = TextEditingController();
  final valores = [];
  void _setImageFileListFromFile(XFile? value) {
    // capturamos el parametro y lo asignamos a _imageFileList
    // luego preguntamos si es null
    // si es null entonces devuelvo null
    // si no _imageFileList es el archivo value
    print(
        'Soy una imagen /se acaba de establecer una imagen con _setImageFileListFromFile');
    _imageFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  bool isVideo = false;
  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  Future<void> onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    if (_controller != null) {
      await _controller!.setVolume(0.0);
    }
    if (isVideo) {
      // final XFile? file = await _picker.pickVideo(
      //     source: source, maxDuration: const Duration(seconds: 10));
      // await _playVideo(file);
    } else if (isMultiImage) {
      await _displayPickImageDialog(context!,
          (double? maxWidth, double? maxHeight, int? quality) async {
        try {
          final List<XFile>? pickedFileList = await _picker.pickMultiImage(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: quality,
          );
          setState(() {
            _imageFileList = pickedFileList;
          });
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
      });
    } else {
      await _displayPickImageDialog(context!,
          (double? maxWidth, double? maxHeight, int? quality) async {
        try {
          final XFile? pickedFile = await _picker.pickImage(
            source: source,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: quality,
          );
          setState(() {
            _setImageFileListFromFile(pickedFile);
          });
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
      });
    }
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Agregar parametros opcionales'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: maxWidthController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      hintText: 'Puede establecer un ancho maximo.'),
                ),
                TextField(
                  controller: maxHeightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      hintText: 'Puede establecer un alto maximo.'),
                ),
                TextField(
                  controller: qualityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Ingrese la calidad de la imagen'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('Cargar'),
                  onPressed: () {
                    final double? width = maxWidthController.text.isNotEmpty
                        ? double.parse(maxWidthController.text)
                        : null;
                    final double? height = maxHeightController.text.isNotEmpty
                        ? double.parse(maxHeightController.text)
                        : null;
                    final int? quality = qualityController.text.isNotEmpty
                        ? int.parse(qualityController.text)
                        : null;
                    onPick(width, height, quality);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller!.setVolume(0.0);
      _controller!.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text("widget.title!"),
          actions: [
            IconButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final storageRef = FirebaseStorage.instance.ref();
                    FirebaseDatabase database = FirebaseDatabase.instance;
                    for (var i = 0; i < _imageFileList!.length; i++) {
                      var now = new DateTime.now();

                      Reference? imagesRef = storageRef.child(now.toString());
                      await imagesRef
                          .putFile(File(_imageFileList!.elementAt(i).path));

                      String opinion = await imagesRef.getDownloadURL();
                      DatabaseReference ref =
                          FirebaseDatabase.instance.ref('referencia');
                      ref.child('suenio');
                      await ref.set({
                        "url": opinion,
                        "fecha": now.toString(),
                        "comentario": "Lorem ipsum"
                      });

                      // print(contr.value);
                    }
                  }
                },
                icon: const Icon(Icons.save_alt))
          ],
        ),
        // drawer: const WidgetDrawermain(),
        body: Widget_BodyContain(),
        floatingActionButton: Widget_floatingactionbutton(context));
  }

  Center Widget_BodyContain() {
    return Center(
      child: Center(
        //Si no es web y es android
        child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
            ? FutureBuilder<void>(
                // mando a llamar a future
                // este pendeivis hace consultas sobre
                // si hay algo que recuperar
                // y las recupera si hay algo x alli.
                future: retrieveLostData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  // estos son los snapshot
                  // preguntan si ya termino el future
                  // ConnectionState.done significa que ya termino
                  // y con la misma llama a un metodo
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Text(
                        'Aun no has elegido una imagen pe pillin.',
                        textAlign: TextAlign.center,
                      );
                    case ConnectionState.done:
                      return _handlePreview();
                    default:
                      if (snapshot.hasError) {
                        return Text(
                          'Pick image/video error: ${snapshot.error}}',
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return const Text(
                          'You have not yet picked an image.',
                          textAlign: TextAlign.center,
                        );
                      }
                  }
                },
              )
            // caso contrario ,igual se ejecuta en _
            // resolvemos la vista
            : _handlePreview(),
      ),
    );
  }

  Column Widget_floatingactionbutton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Semantics(
          label: 'image_picker_example_from_gallery',
          child: FloatingActionButton(
            heroTag: 'image0',
            tooltip: 'Seleccionar imagen de galeria.',
            backgroundColor: Colors.pink,
            onPressed: () {
              // Navigator.pushNamed(context, 'add_image');
              isVideo = false;
              onImageButtonPressed(ImageSource.gallery, context: context);
            },
            child: const Icon(Icons.add_photo_alternate_rounded),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: FloatingActionButton(
            heroTag: 'image1',
            tooltip: 'Take a Photo',
            elevation: 0,
            onPressed: () {
              isVideo = false;
              onImageButtonPressed(ImageSource.camera, context: context);
            },
            child: const Icon(Icons.add_a_photo),
          ),
        ),
      ],
    );
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);
