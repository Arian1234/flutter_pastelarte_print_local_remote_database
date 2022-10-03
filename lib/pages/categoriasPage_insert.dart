import 'dart:developer';
import 'package:firebase_orders_flutter/controllers/controllerCategorias.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../widgets/textformfieldcustom.dart';

class categoriasPage_insert extends StatefulWidget {
  const categoriasPage_insert({
    Key? key,
    this.id,
    this.categ,
  }) : super(key: key);
  final String? id;
  final String? categ;

  @override
  State<categoriasPage_insert> createState() => _categoriasPage_insertState();
}

class _categoriasPage_insertState extends State<categoriasPage_insert> {
  List<XFile>? _imageFileList;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController contr = TextEditingController();
  final valores = [];
  final _controllernombcateg = TextEditingController();
  final _controlleridcateg = TextEditingController();

  final _globalformkey = GlobalKey<FormState>();
  String estado = 'Nueva';

  void _setImageFileListFromFile(XFile? value) {
    // capturamos el parametro y lo asignamos a _imageFileList
    // luego preguntamos si es null
    // si es null entonces devuelvo null
    // si no _imageFileList es el archivo value
    print(
        'Soy una imagen /se acaba de establecer una imagen con _setImageFileListFromFile');
    _imageFileList = value == null ? null : <XFile>[value];
  }

  @override
  void initState() {
    super.initState();

    if (widget.id != null) {
      _controlleridcateg.text = widget.id.toString();
      _controllernombcateg.text = widget.categ.toString();

      setState(() {
        estado = 'Actualizar';

        // String _valordropdownbutton = list.first.value.toString();
      });
    }
    ;
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
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: 300,
          maxHeight: 300,
          imageQuality: 100,
        );
        setState(() {
          _setImageFileListFromFile(pickedFile);
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
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
    final double _ancho = MediaQuery.of(context).size.width;
    final double _alto = MediaQuery.of(context).size.height;

    // _valordropdownbutton = list.first.value.toString as String;
    log("aqui estoy");
    return GestureDetector(
      // onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        key: _globalformkey,
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 12, left: 12, right: 12, top: 12),
              child: SizedBox(
                width: _ancho,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: _ancho * .33,
                          height: _ancho * .33,
                          // color: Colors.pink[100],
                          decoration: BoxDecoration(
                              color: Colors.pink[100],
                              borderRadius: BorderRadius.circular(25)),
                          child: GestureDetector(
                              onTap: () {},
                              child: _imageFileList != null
                                  ? ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(25)),
                                      child: Image(
                                        isAntiAlias: true,
                                        fit: BoxFit.fill,
                                        image: FileImage(
                                            File(_imageFileList![0].path)),
                                        width: 50,
                                        // fit: BoxFit.cover,
                                        // height: 400,
                                      ),
                                    )
                                  : const ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image(
                                        image: AssetImage('assets/logo.png'),
                                        width: 50,
                                        fit: BoxFit.fill,
                                        // height: 400,
                                      ),
                                    )),
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
                          ancho: _ancho * .25,
                          controllercategoria: _controlleridcateg,
                          // hinttext: '',
                          textinputype: TextInputType.text,
                          habilitado: false,
                          label: 'Codigo',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        textformfield(
                          ancho: _ancho * .75,
                          controllercategoria: _controllernombcateg,
                          // hinttext: '',
                          textinputype: TextInputType.text,
                          habilitado: true,
                          label: 'Nombre de la categoria',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget _handlePreview() {
    if (isVideo) {
      // si es video el future
      return const Text('nel... video.');
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
      log('Me ejecute pero no encontre ninguna imagen cargada');
      return;
    }
    if (response.file != null) {
      log('Ahora si files pero no se si es una o varias imagenes');
      // si hay algo perdidijirijillo
      // y si es un video
      if (response.type == RetrieveType.video) {
        log('Soy un video');
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

            log('cargo sobre mi lomo varias imagenes(plural)');
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
    final prov = Provider.of<ProviderCategorias>(context, listen: true);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink[400],
          elevation: 1,
          title: Text("$estado categoria"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: widget.id != null
                  ? IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.pink,
                                  color: Colors.yellow,
                                ),
                              );
                            });

                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          String id = _controlleridcateg.value.text.toString();
                          String nombre =
                              _controllernombcateg.value.text.toString();

                          prov.ActualizarCategoria(int.parse(id), nombre);

                          Timer(const Duration(milliseconds: 1900), () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Datos actualizados.')),
                            );
                          });
                        } else {
                          Timer(const Duration(milliseconds: 300), () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Hubo un error al intentar actualizar.')),
                            );
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.refresh,
                        size: 30,
                      ))
                  : IconButton(
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            });

                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();

                          String nombre =
                              _controllernombcateg.value.text.toString();
                          prov.AgregarCategoria(nombre);
                          Timer(const Duration(milliseconds: 1900), () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Datos registrados.')),
                            );
                          });
                        } else {
                          Timer(const Duration(milliseconds: 300), () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Hubo un error al intentar registrar.')),
                            );
                          });
                        }
                        // Timer(
                        //   Duration(seconds: 3),
                        //   () => Navigator.pop(context),
                        // );
                      },
                      icon: const Icon(
                        Icons.save_alt_outlined,
                        size: 30,
                      )),
            )
          ],
        ),
// TODO:EL BODY COMENTADO ES EL VERDADERO , SE REEMPLAZO POR OTRO WIDGET
        // body: Widget_BodyContain());
        body: _previewImages());
  }

  Widget_BodyContain() {
    return Container(
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
                    return _handlePreview();
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
