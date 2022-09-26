import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_orders_flutter/pages/testprint.dart';
import 'package:firebase_orders_flutter/widgets/textformfieldcustom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import '../controllers/controllerProductos.dart';
import 'package:decimal/decimal.dart';

FlutterBlue flutterBlue = FlutterBlue.instance;

class ordenespagesqflite extends StatefulWidget {
  final ProviderProductos provforaneo;
  const ordenespagesqflite({Key? key, required this.provforaneo})
      : super(key: key);

  @override
  State<ordenespagesqflite> createState() => _ordenespagesqfliteState();
}

class _ordenespagesqfliteState extends State<ordenespagesqflite> {
  final fb = FirebaseDatabase.instance.ref().child('products');
  List list = [];
  var listado = [];
  var iniciado = 1;
  int cant = 0;
  List<ScanResult>? scanResult;

  @override
  void initState() {
    super.initState();
    widget.provforaneo.ObtenerProducto('% %');
  }

  @override
  Widget build(BuildContext context) {
    double _ancho = MediaQuery.of(context).size.width;
    double _alto = MediaQuery.of(context).size.height;
    final prov = Provider.of<ProviderProductos>(context, listen: true);
    final _controllercategoria = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[400],
        centerTitle: true,
        title: Text('Productos: $cant'),
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        Decimal total = Decimal.parse('0');
                        return Container(
                          width: _ancho * .9,
                          height: _alto * .7,
                          color: Colors.pink.withOpacity(.15),
                          child: AlertDialog(
                            elevation: 1,
                            actions: [
                              Container(
                                color: Colors.teal.withOpacity(.3),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                        onPressed: () => Navigator.pop(context),
                                        icon: const Icon(
                                          Icons.arrow_back_ios_new,
                                          size: 25,
                                          color: Colors.white,
                                        )),
                                    IconButton(
                                      onPressed: () {
                                        TestPrint().sample(listado, prov,
                                            listado.length, total.toString());
                                      },
                                      icon: const Icon(
                                        Icons.print,
                                        size: 30,
                                      ),
                                      color: Colors.red[200],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            title: const Center(
                                child: Text(
                              'Productos en carrito',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink,
                                  fontSize: 22),
                            )),
                            content: Container(
                              width: _ancho * .9,
                              height: _alto * .7,
                              child: Column(
                                children: [
                                  Container(
                                    width: _ancho * .9,
                                    height: _alto * .70,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: _ancho * .9,
                                          height: _alto * .03,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  width: _ancho * .15,
                                                  child: const Text(
                                                    "CANT",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                              Container(
                                                  width: _ancho * .35,
                                                  child: const Text(
                                                    "PRODUCTO/P.U.",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                              Container(
                                                  width: _ancho * .15,
                                                  child: const Text(
                                                    "TOTAL",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: _ancho * .9,
                                          height: _alto * .65,
                                          child: ListView.builder(
                                            itemCount: listado.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              if (listado[index] > 0) {
                                                var sd = Decimal.parse(
                                                        listado[index]
                                                            .toString()) *
                                                    Decimal.parse(prov
                                                        .prod[index].ventaprod
                                                        .toString());

                                                total = total + sd;

                                                return Card(
                                                  color: Colors.pink
                                                      .withOpacity(.2),
                                                  child: ListTile(
                                                    title: Text(
                                                      prov.prod[index].nombprod
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    subtitle: Text(
                                                      prov.prod[index].ventaprod
                                                          .toString(),
                                                    ),
                                                    leading: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                            listado[
                                                                    index]
                                                                .toString(),
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white)),
                                                      ],
                                                    ),
                                                    trailing:
                                                        Text(sd.toString()),
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
                                  // GestureDetector(
                                  //   onTap: () {},
                                  //   child: Column(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.center,
                                  //     children: [
                                  //       IconButton(
                                  //           onPressed: () {
                                  //             TestPrint().sample(listado, prov,
                                  //                 listado.length, total);
                                  //           },
                                  //           iconSize: 53,
                                  //           icon: const Icon(
                                  //               Icons.local_printshop)),
                                  //       Text("Guardar e imprimir")
                                  //     ],
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                icon: const Icon(
                  Icons.shopping_bag_rounded,
                  size: 30,
                )),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          width: _ancho,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textformfieldsintitle(
                      ancho: _ancho * .8,
                      controllerfield: _controllercategoria,
                      hinttext: 'Buscar producto .',
                      textinputype: TextInputType.text,
                      habilitado: true),
                  SizedBox(
                    width: _ancho * .02,
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.qr_code_scanner_rounded,
                        color: Colors.teal[400],
                        size: 30,
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Nueva orden',
                      style: TextStyle(
                          color: Colors.teal[700],
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  width: _ancho * .95,
                  height: _alto * .75,
                  child: Center(
                    child: ListView.builder(
                      itemCount: prov.prod.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (iniciado == 1) {
                          listado.add(0);
                        }
                        if (index == prov.prod.length) {
                          iniciado = 0;
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            width: _ancho * .95,
                            height: 90,
                            decoration: BoxDecoration(
                                // color: Color.fromARGB(255, 147, 218, 15),
                                borderRadius: BorderRadius.circular(5.0),
                                gradient: LinearGradient(colors: [
                                  Colors.black.withOpacity(.1),
                                  Colors.black.withOpacity(.1),
                                  // Colors.teal.shade400
                                ]),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(.1),
                                      blurRadius: 5.0,
                                      offset: const Offset(2.0, 2.0))
                                ]),
                            child: Padding(
                              padding: EdgeInsets.only(left: _ancho * .03),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: _ancho * .1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                            backgroundColor: Colors.teal,
                                            child: Text(prov.prod[index].idprod
                                                .toString())),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: _ancho * .40,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: _ancho * .35,
                                          // color: Colors.red,
                                          child: Center(
                                            child: FittedBox(
                                              child: Text(
                                                prov.prod[index].nombprod
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "${prov.prod[index].ventaprod} sol(es).",
                                          style: const TextStyle(
                                              color: Colors.black45),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: _ancho * .25,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${listado[index]}/${prov.prod[index].cantprod}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 16,
                                              color: Colors.red.shade900),
                                        ),
                                        Text(
                                          "cant. actual",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontSize: 16,
                                              color: Colors.red.shade700),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: _ancho * .15,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.pink[400],
                                          foregroundColor: Colors.white,
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  log(listado[index]
                                                      .toString());
                                                  log(prov.prod[index].cantprod
                                                      .toString());
                                                  if (double.tryParse(
                                                          listado[index]
                                                              .toString())! <
                                                      (prov
                                                          .prod[index].cantprod!
                                                          .toDouble())) {
                                                    listado[index] += 1;
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
                                          backgroundColor:
                                              Colors.blueAccent[200],
                                          foregroundColor: Colors.white,
                                          child: IconButton(
                                              padding: const EdgeInsets.only(
                                                  bottom: 15),
                                              onPressed: () {
                                                setState(() {
                                                  if (listado[index] > 0) {
                                                    listado[index] -= 1;
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
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    //TODO:NO BORRAR ME COSTO MUCHO
                    //TODO : TRAE DATOS DE REALTIMEDATABASE EN UN LISTTILE

                    // child: StreamBuilder(
                    //   stream: FirebaseDatabase.instance.ref('products').onValue,
                    //   // initialData: initialData,
                    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                    //     // log(snapshot.data.toString());
                    //     if (snapshot != null && snapshot.hasData) {
                    //       DataSnapshot dataValues = snapshot.data.snapshot;
                    //       Map<dynamic, dynamic> values =
                    //           dataValues.value as Map<dynamic, dynamic>;
                    //       list.clear();
                    //       values.forEach((key, values) {
                    //         // lists.add(values);
                    //         log(values.toString());
                    //         list.add(values);
                    //       });
                    //     }
                    //     return ListView.builder(
                    //       itemCount: list.length,
                    //       itemBuilder: (BuildContext context, int index) {
                    //         return Card(
                    //           child: ListTile(
                    //             title: Text(list[index]["nombre"]),
                    //             subtitle: Text(list[index]["venta"]),
                    //             leading: FadeInImage.assetNetwork(
                    //                 width: 50,
                    //                 height: 90,
                    //                 placeholder: 'assets/logo.png',
                    //                 image: list[index]["url"]),
                    //           ),
                    //         );
                    //       },
                    //     );
                    //   },
                    // ),
                  ),
                  // child: Center(
                  //   child: StreamBuilder(
                  //     stream: FirebaseDatabase.instance.ref('products').onValue,
                  //     // initialData: initialData,
                  //     builder: (BuildContext context, AsyncSnapshot snapshot) {
                  //       // log(snapshot.data.toString());
                  //       Center(child: CircularProgressIndicator());
                  //       if (snapshot != null && snapshot.hasData) {
                  //         DataSnapshot dataValues = snapshot.data.snapshot;
                  //         Map<dynamic, dynamic> values =
                  //             dataValues.value as Map<dynamic, dynamic>;
                  //         list.clear();
                  //         // listado.clear();
                  //         values.forEach((key, values) {
                  //           // lists.add(values);
                  //           log(values.toString());
                  //           list.add(values);
                  //           if (iniciado == 1) {
                  //             listado.add(0);
                  //           }

                  //           // cantidades.add(values["cantidad"]);
                  //         });
                  //         iniciado = 0;
                  //       }
                  //       return ListView.builder(
                  //         itemCount: list.length,
                  //         itemBuilder: (BuildContext context, int index) {
                  //           return Padding(
                  //             padding: const EdgeInsets.only(
                  //                 top: 15, left: 15, right: 15),
                  //             child: Container(
                  //               height: 90,
                  //               decoration: BoxDecoration(
                  //                   // color: Color.fromARGB(255, 147, 218, 15),
                  //                   borderRadius: BorderRadius.circular(15.0),
                  //                   gradient: LinearGradient(colors: [
                  //                     Colors.black.withOpacity(.1),
                  //                     Colors.black.withOpacity(.1),
                  //                     // Colors.teal.shade400
                  //                   ]),
                  //                   boxShadow: [
                  //                     BoxShadow(
                  //                         color: Colors.black.withOpacity(.1),
                  //                         blurRadius: 5.0,
                  //                         offset: const Offset(2.0, 2.0))
                  //                   ]),
                  //               child: Row(
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.spaceAround,
                  //                 // crossAxisAlignment: CrossAxisAlignment.center,
                  //                 children: [
                  //                   Column(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.center,
                  //                     children: [
                  //                       CircleAvatar(
                  //                         radius: 25,
                  //                         child: ClipRRect(
                  //                           borderRadius: BorderRadius.all(
                  //                               Radius.circular(33)),
                  //                           clipBehavior: Clip.antiAlias,
                  //                           child: FadeInImage.assetNetwork(
                  //                               width: 70,
                  //                               height: 70,
                  //                               fit: BoxFit.cover,
                  //                               placeholder: 'assets/logo.png',
                  //                               image: list[index]["url"]),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   Column(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.center,
                  //                     children: [
                  //                       Text(
                  //                         list[index]["nombre"],
                  //                         style: TextStyle(
                  //                             fontWeight: FontWeight.w400,
                  //                             fontSize: 16),
                  //                       ),
                  //                       Text(
                  //                         list[index]["venta"] + " sol(es)",
                  //                         style: TextStyle(
                  //                             fontWeight: FontWeight.w300,
                  //                             fontSize: 14),
                  //                       )
                  //                     ],
                  //                   ),
                  //                   Column(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.center,
                  //                     children: [
                  //                       Text(
                  //                         listado[index].toString() +
                  //                             "/" +
                  //                             list[index]["cantidad"],
                  //                         style: TextStyle(
                  //                             fontWeight: FontWeight.w300,
                  //                             fontSize: 16,
                  //                             color: Colors.red.shade900),
                  //                       ),
                  //                       Text(
                  //                         "cant. actual",
                  //                         style: TextStyle(
                  //                             fontWeight: FontWeight.w200,
                  //                             fontSize: 16,
                  //                             color: Colors.red.shade700),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                   Column(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.center,
                  //                     children: [
                  //                       CircleAvatar(
                  //                         child: IconButton(
                  //                             onPressed: () {
                  //                               setState(() {
                  //                                 if (listado[index] <
                  //                                     int.tryParse(list[index]
                  //                                         ["cantidad"])) {
                  //                                   listado[index] += 1;
                  //                                   cant++;
                  //                                 }
                  //                               });
                  //                             },
                  //                             icon: Icon(Icons.add)),
                  //                       ),
                  //                       SizedBox(
                  //                         height: 3,
                  //                       ),
                  //                       CircleAvatar(
                  //                         child: IconButton(
                  //                             onPressed: () {
                  //                               setState(() {
                  //                                 if (listado[index] > 0) {
                  //                                   listado[index] -= 1;
                  //                                   cant--;
                  //                                 }
                  //                               });
                  //                             },
                  //                             icon: Icon(
                  //                                 Icons.do_disturb_on_rounded)),
                  //                       ),
                  //                     ],
                  //                   )
                  //                 ],
                  //               ),
                  //             ),
                  //           );
                  //         },
                  //       );
                  //     },
                  //   ),

                  // ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
