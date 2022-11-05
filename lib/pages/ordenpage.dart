// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:firebase_orders_flutter/controllers/controllerDetaorden.dart';
import 'package:firebase_orders_flutter/controllers/controllerOrdenes.dart';
import 'package:firebase_orders_flutter/widgets/textformfieldcustom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import '../controllers/controllerProductos.dart';
import 'package:decimal/decimal.dart';
import 'package:share_plus/share_plus.dart';
import '../helpers/impresora/testprint.dart';
import '../widgets/buttonsCustoms.dart';

FlutterBlue flutterBlue = FlutterBlue.instance;

class ordenPage extends StatefulWidget {
  const ordenPage({Key? key}) : super(key: key);

  @override
  State<ordenPage> createState() => _ordenPageState();
}

class _ordenPageState extends State<ordenPage> {
  ScreenshotController screenshotController = ScreenshotController();
  var listado = [];
  var iniciado = 1;
  int cant = 0;
  Decimal total = 0.toDecimal();
  Decimal pcosto = 0.toDecimal();
  List<ScanResult>? scanResult;

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;
    double alto = MediaQuery.of(context).size.height;
    final provproductos = Provider.of<ProviderProductos>(context, listen: true);
    final provordenes = Provider.of<ProviderOrdenes>(context, listen: false);
    final provdetaord = Provider.of<ProviderDetaorden>(context, listen: false);
    final controllerbuscprod = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Items: $cant'),
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                  size: 30,
                ),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  await provproductos.obtenerProducto('%%');
                  await showDialogCarrito(context, provproductos, ancho, alto,
                      provordenes, provdetaord);
                }),
          )
        ],
      ),
      body: body(ancho, controllerbuscprod, provproductos, context, alto),
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.blue,
        onPressed: () {},
        child: Icon(Icons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }

  showDialogCarrito(
      BuildContext context,
      ProviderProductos provproductos,
      double ancho,
      double alto,
      ProviderOrdenes provordenes,
      ProviderDetaorden provdetaord) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          total = 0.toDecimal();
          pcosto = 0.toDecimal();

          log("items.length:  listado ${listado.length}");
          for (var i = 0; i < listado.length; i++) {
            if (listado[i] > 0) {
              var sd = Decimal.parse(listado[i].toString()) *
                  Decimal.parse(provproductos.prod[i].ventaprod.toString());
              var cost = Decimal.parse(listado[i].toString()) *
                  Decimal.parse(provproductos.prod[i].precioprod.toString());
              total = total + sd;
              pcosto = pcosto + cost;
            }
          }
          if (cant > 0) {
            return Container(
              width: ancho * .9,
              height: alto * .6,
              color: Colors.black.withOpacity(.15),
              child: Screenshot(
                controller: screenshotController,
                child: AlertDialog(
                  elevation: 1,
                  title: titleCarrito(ancho, alto),
                  content: contentCarrito(ancho, alto, provproductos),
                  actions: [
                    Container(
                      width: ancho * .9,
                      height: alto * .1,
                      color: Colors.pink[400],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          botonVolver(context, ancho, alto),
                          botonCompartir(
                            screenshotController: screenshotController,
                            alto: alto,
                            ancho: ancho,
                          ),
                          // botton registrar nueva orden
                          GestureDetector(
                            onTap: () async {
                              return showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: const Text(
                                          "¿Desea guardar esta orden?"),
                                      actions: [
                                        bottoncancelar(context, ancho, alto),
                                        GestureDetector(
                                          onTap: () async {
                                            final now = DateTime.now();

                                            String day = "0${now.day}";
                                            String days = (day.substring(
                                                day.length - 2, day.length));
                                            String fecha =
                                                ("${now.year}-${now.month}-$days");

                                            String unix = DateTime.now()
                                                .toUtc()
                                                .millisecondsSinceEpoch
                                                .toString();

                                            final idorden =
                                                await provordenes.AgregarOrden(
                                                    unix,
                                                    1,
                                                    fecha,
                                                    fecha,
                                                    "0",
                                                    total.toDouble(),
                                                    total.toDouble(),
                                                    (total - pcosto).toDouble(),
                                                    "---",
                                                    0);

                                            for (var i = 0;
                                                i < listado.length;
                                                i++) {
                                              if (listado[i] > 0) {
                                                provdetaord.AgregarDetaorden(
                                                    idorden,
                                                    (provproductos
                                                            .prod[i].idprod)!
                                                        .toInt(),
                                                    provproductos
                                                        .prod[i].precioprod!
                                                        .toDouble(),
                                                    provproductos
                                                        .prod[i].ventaprod!
                                                        .toDouble(),
                                                    double.parse(
                                                        listado[i].toString()));
                                              }
                                            }
                                            await TestPrint().sample(
                                                listado,
                                                provproductos,
                                                listado.length,
                                                total.toString(),
                                                unix);

                                            log("total : $total");

                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            //CLEAR
                                            nuevaorden(provproductos);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "Nota de venta: $unix guardada, imprimiendo.")),
                                            );
                                          },
                                          child: buttonmodal(
                                            ancho: ancho * .20,
                                            alto: alto * .06,
                                            title: "Guardar",
                                            icon: Icons.save,
                                            primary:
                                                Colors.blue.withOpacity(.8),
                                            second: Colors.blue.withOpacity(1),
                                            shadow: Colors.black26,
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: buttonmodal(
                              ancho: ancho * .20,
                              alto: alto * .06,
                              title: "Guardar",
                              icon: Icons.save_as,
                              primary: Colors.blue.withOpacity(.7),
                              second: Colors.blue.withOpacity(.9),
                              shadow: Colors.black26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return AlertDialog(
              title: const Text("Ingrese productos al carrito."),
              actions: [
                Center(
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios_new)),
                )
              ],
            );
          }
        });
  }

  SizedBox contentCarrito(
      double ancho, double alto, ProviderProductos provproductos) {
    return SizedBox(
      width: ancho * .9,
      height: alto * .6,
      child: Column(
        children: [
          SizedBox(
            width: ancho * .9,
            height: alto * .6,
            child: Column(
              children: [
                SizedBox(
                  width: ancho * .9,
                  height: alto * .03,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: ancho * .15,
                          child: const Text(
                            "CANT",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                          width: ancho * .35,
                          child: const Text(
                            "PRODUCTO/P.U.",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                          width: ancho * .15,
                          child: const Text(
                            "TOTAL",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  width: ancho * .9,
                  height: alto * .57,
                  //
                  // Listado del carrito dentro del showdialog
                  //
                  child: ListView.builder(
                    itemCount: listado.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (listado[index] > 0) {
                        var sd = Decimal.parse(listado[index].toString()) *
                            Decimal.parse(
                                provproductos.prod[index].ventaprod.toString());

                        return Card(
                          color: provproductos.prod[index].despachorecep == 1
                              ? Colors.white
                              : Colors.yellow[700],
                          child: ListTile(
                            title: Text(
                              provproductos.prod[index].nombprod.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              provproductos.prod[index].ventaprod.toString(),
                            ),
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(listado[index].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            ),
                            trailing: Text(sd.toString()),
                          ),
                        );
                      }
                      return const SizedBox(
                        height: 1,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container titleCarrito(double ancho, double alto) {
    return Container(
      width: ancho * .9,
      height: alto * .1,
      color: Colors.pink[400],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Carrito: ',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22),
          ),
          Text(
            // ' $total soles ${total - pcosto}',
            ' $total soles ',
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: Colors.white,
                fontSize: 18),
          ),
        ],
      ),
    );
  }

  GestureDetector bottoncancelar(
      BuildContext context, double ancho, double alto) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        total = 0.toDecimal();
        pcosto = 0.toDecimal();
      },
      child: buttonmodal(
        ancho: ancho * .20,
        alto: alto * .06,
        title: "Cancelar",
        icon: Icons.arrow_back_ios,
        primary: Colors.red.withOpacity(.8),
        second: Colors.red.withOpacity(.9),
        shadow: Colors.black26,
      ),
    );
  }

  GestureDetector botonVolver(BuildContext context, double ancho, double alto) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        total = 0.toDecimal();
        pcosto = 0.toDecimal();
      },
      child: buttonmodal(
        ancho: ancho * .20,
        alto: alto * .06,
        title: "Volver",
        icon: Icons.arrow_back_ios,
        primary: Colors.red.withOpacity(.8),
        second: Colors.red.withOpacity(.9),
        shadow: Colors.black26,
      ),
    );
  }

  SingleChildScrollView body(
      double ancho,
      TextEditingController controllerbuscprod,
      ProviderProductos prov,
      BuildContext context,
      double alto) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 14),
        child: SizedBox(
          width: ancho,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textformfieldsintitle(
                      clase: "productos",
                      ancho: ancho * .7,
                      controllerfield: controllerbuscprod,
                      hinttext: 'B. producto por nombre',
                      textinputype: TextInputType.text,
                      habilitado: true,
                      prov: prov),
                  SizedBox(
                    width: ancho * .02,
                  ),
                  IconButton(
                      onPressed: () {
                        prov.obtenerProducto('%%');
                      },
                      icon: const Icon(
                        Icons.find_replace_outlined,
                        color: Colors.pink,
                        size: 30,
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 15, left: 15, right: 15, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        nuevaorden(prov);
                        listado.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              backgroundColor: Colors.pink,
                              content: Text(
                                  "Nueva orden\nItems y productos seleccionados en cero.")),
                        );
                      },
                      child: buttonOrdenes(
                        ancho: ancho * .40,
                        alto: alto * .06,
                        title: "N. orden",
                        icon: Icons.add,
                        primary: Colors.teal.withOpacity(.7),
                        second: Colors.blueAccent.withOpacity(.9),
                        shadow: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  width: ancho * .95,
                  height: alto * .73,
                  child: Center(
                    // Cargamos los ListTiles
                    // "INICIADO" sirve para no volver a "AGREGAR Y DUPLICAR"
                    // las listas al refrescar la pantalla
                    child: ListView.builder(
                      itemCount: prov.prod.length,
                      itemBuilder: (BuildContext context, int index) {
                        log("length prov.prod: ${prov.prod.length} listado : ${listado.length} index: $index");
                        if (iniciado == 1) {
                          log("iniciado 1");
                          for (var i = 0; i < prov.prod.length; i++) {
                            listado.add(0);
                          }
                          log("iniciado 0");
                          iniciado = 0;
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
                            width: ancho * .95,
                            height: 90,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                gradient: LinearGradient(colors: [
                                  Colors.blue.withOpacity(.1),
                                  Colors.blueAccent.withOpacity(.1),
                                ]),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(.1),
                                      blurRadius: 5.0,
                                      offset: const Offset(2.0, 2.0))
                                ]),
                            child: Padding(
                              padding: EdgeInsets.only(left: ancho * .03),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                // LIST PERSONALIZADAS
                                // Agrego las listas personalizadas
                                children: [
                                  SizedBox(
                                    width: ancho * .1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        listLeadingIcon(prov, index),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: ancho * .40,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        listTitle(ancho, prov, index),
                                        listSubtitle(prov, index)
                                      ],
                                    ),
                                  ),
                                  listTrailingCantidades(ancho, prov, index),
                                  listTrailingBotones(ancho, prov, index)
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

//
// METODOS PERSONALIZADOS
//
  CircleAvatar listLeadingIcon(ProviderProductos prov, int index) {
    return CircleAvatar(
        backgroundColor: Colors.teal,
        child: Text(prov.prod[index].idprod.toString()));
  }

  SizedBox listTrailingBotones(
      double ancho, ProviderProductos prov, int index) {
    return SizedBox(
      width: ancho * .15,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.pink[400],
            foregroundColor: Colors.white,
            child: IconButton(
                onPressed: () {
                  setState(() {
                    if (double.tryParse(
                            listado[(prov.prod[index].idprod ?? 0) - 1]
                                .toString())! <
                        (prov.prod[index].cantprod!.toDouble())) {
                      listado[(prov.prod[index].idprod ?? 0) - 1] += 1;
                      cant++;
                    }
                  });
                },
                icon: const Icon(Icons.add)),
          ),
          const SizedBox(
            height: 3,
          ),
          CircleAvatar(
            backgroundColor: Colors.blueAccent[200],
            foregroundColor: Colors.white,
            child: IconButton(
                padding: const EdgeInsets.only(bottom: 15),
                onPressed: () {
                  setState(() {
                    if (double.tryParse(
                            listado[(prov.prod[index].idprod ?? 0) - 1]
                                .toString())! >
                        0) {
                      listado[(prov.prod[index].idprod ?? 0) - 1] -= 1;
                      cant--;
                    }
                  });
                },
                icon: const Icon(
                  Icons.minimize_outlined,
                )),
          ),
        ],
      ),
    );
  }

  Container listTrailingCantidades(
      double ancho, ProviderProductos prov, int index) {
    return Container(
      color: Colors.pink.withOpacity(.1),
      width: ancho * .25,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            // ignore: prefer_interpolation_to_compose_strings
            listado[(int.parse(prov.prod[index].idprod.toString()) - 1)]
                    .toString() +
                " / " +
                prov.prod[index].cantprod.toString(),
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Colors.red.shade900),
          ),
          Text(
            "cant. actual",
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 16,
                color: Colors.red.shade700),
          ),
        ],
      ),
    );
  }

  Text listSubtitle(ProviderProductos prov, int index) {
    return Text(
      "${prov.prod[index].ventaprod} sol(es).",
      style: const TextStyle(color: Colors.black45),
    );
  }

  SizedBox listTitle(double ancho, ProviderProductos prov, int index) {
    return SizedBox(
      width: ancho * .35,
      child: Center(
        child: FittedBox(
          child: Text(
            prov.prod[index].nombprod.toString(),
            style: const TextStyle(
                fontWeight: FontWeight.w400, overflow: TextOverflow.ellipsis),
          ),
        ),
      ),
    );
  }

  void nuevaorden(ProviderProductos prov) {
    prov.obtenerProducto('%%');
    iniciado = 1;
    total = 0.toDecimal();
    pcosto = 0.toDecimal();

    setState(() {
      cant = 0;
      // listado.clear();
    });
    log("Tamanio del listado ${listado.length}");
  }
}

class botonCompartir extends StatelessWidget {
  const botonCompartir(
      {Key? key,
      required this.screenshotController,
      required this.ancho,
      required this.alto})
      : super(key: key);

  final ScreenshotController screenshotController;
  final double ancho;
  final double alto;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await screenshotController
            .capture(delay: const Duration(milliseconds: 10))
            .then((image) async {
          if (image != null) {
            final directory = await getApplicationDocumentsDirectory();
            final imagePath =
                await File('${directory.path}/image.png').create();
            await imagePath.writeAsBytes(image);

            /// Share Plugin
            await Share.shareFiles([imagePath.path]);
          }
        });
      },
      child: buttonmodal(
        ancho: ancho * .20,
        alto: alto * .06,
        title: "Compartir",
        icon: Icons.share,
        primary: Colors.green.withOpacity(.8),
        second: Colors.green.withOpacity(.9),
        shadow: Colors.black26,
      ),
    );
  }
}
