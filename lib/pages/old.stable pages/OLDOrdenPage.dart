// import 'dart:developer';
// import 'dart:io';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_orders_flutter/controllers/controllerDetaorden.dart';
// import 'package:firebase_orders_flutter/controllers/controllerOrdenes.dart';
// import 'package:firebase_orders_flutter/pages/impresora/testprint.dart';
// import 'package:firebase_orders_flutter/widgets/textformfieldcustom.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:screenshot/screenshot.dart';
// import '../controllers/controllerProductos.dart';
// import 'package:decimal/decimal.dart';
// import 'package:share_plus/share_plus.dart';

// FlutterBlue flutterBlue = FlutterBlue.instance;

// class ordenPage extends StatefulWidget {
//   final ProviderProductos provforaneo;
//   const ordenPage({Key? key, required this.provforaneo}) : super(key: key);

//   @override
//   State<ordenPage> createState() => _ordenPageState();
// }

// class _ordenPageState extends State<ordenPage> {
//   final fb = FirebaseDatabase.instance.ref().child('products');
//   ScreenshotController screenshotController = ScreenshotController();
//   List list = [];
//   var listado = [];
//   var iniciado = 1;
//   int cant = 0;
//   List<ScanResult>? scanResult;

//   @override
//   void initState() {
//     super.initState();
//     widget.provforaneo.ObtenerProducto('%%');
//   }

//   @override
//   Widget build(BuildContext context) {
//     double _ancho = MediaQuery.of(context).size.width;
//     double _alto = MediaQuery.of(context).size.height;
//     final prov = Provider.of<ProviderProductos>(context, listen: true);
//     final _controllercategoria = TextEditingController();
//     final provordenes = Provider.of<ProviderOrdenes>(context, listen: false);
//     final provdetaordenes =
//         Provider.of<ProviderDetaorden>(context, listen: false);
//     Decimal total = 0.toDecimal();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.pink[400],
//         centerTitle: true,
//         title: Text('Productos: $cant'),
//         elevation: 1,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 15),
//             child: IconButton(
//                 onPressed: () {
//                   showDialog(
//                       barrierDismissible: false,
//                       context: context,
//                       builder: (BuildContext context) {
//                         for (var i = 0; i < listado.length; i++) {
//                           if (listado[i] > 0) {
//                             var sd = Decimal.parse(listado[i].toString()) *
//                                 Decimal.parse(
//                                     prov.prod[i].ventaprod.toString());
//                             total = total + sd;
//                           }
//                         }

//                         return Container(
//                           width: _ancho * .9,
//                           height: _alto * .6,
//                           color: Colors.black.withOpacity(.15),
//                           child: Screenshot(
//                             controller: screenshotController,
//                             child: AlertDialog(
//                               elevation: 1,
//                               actions: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceAround,
//                                   children: [
//                                     IconButton(
//                                         onPressed: () {
//                                           Navigator.pop(context);
//                                           total = 0.toDecimal();
//                                         },
//                                         icon: const Icon(
//                                           Icons.arrow_back_ios_new,
//                                           // size: 25,
//                                           // color: Colors.black,
//                                         )),
//                                     IconButton(
//                                         onPressed: () async {
//                                           await screenshotController
//                                               .capture(
//                                                   delay: const Duration(
//                                                       milliseconds: 10))
//                                               .then((image) async {
//                                             if (image != null) {
//                                               final directory =
//                                                   await getApplicationDocumentsDirectory();
//                                               final imagePath = await File(
//                                                       '${directory.path}/image.png')
//                                                   .create();
//                                               await imagePath
//                                                   .writeAsBytes(image);

//                                               /// Share Plugin
//                                               await Share.shareFiles(
//                                                   [imagePath.path]);
//                                             }
//                                           });
//                                         },
//                                         icon: const Icon(Icons.share)),
//                                     IconButton(
//                                         onPressed: () async {
//                                           final now = DateTime.now();
//                                           String fecha =
//                                               ("${now.day}-${now.month}-${now.year}");
//                                           String unix = DateTime.now()
//                                               .toUtc()
//                                               .millisecondsSinceEpoch
//                                               .toString();
//                                           final idorden =
//                                               await provordenes.AgregarOrden(
//                                                   unix,
//                                                   "anderson Molina",
//                                                   fecha,
//                                                   fecha,
//                                                   "1",
//                                                   total.toDouble(),
//                                                   total.toDouble(),
//                                                   0,
//                                                   "---",
//                                                   1);

//                                           for (var i = 0;
//                                               i < listado.length;
//                                               i++) {
//                                             if (listado[i] > 0) {
//                                               provdetaordenes.AgregarDetaorden(
//                                                   idorden,
//                                                   prov.prod[i].nombprod
//                                                       .toString(),
//                                                   prov.prod[i].precioprod!
//                                                       .toDouble(),
//                                                   prov.prod[i].ventaprod!
//                                                       .toDouble(),
//                                                   prov.prod[i].cantprod!
//                                                       .toDouble());
//                                             }
//                                           }
//                                           TestPrint().sample(
//                                               listado,
//                                               prov,
//                                               listado.length,
//                                               total.toString(),
//                                               unix);
//                                           log("total : $total");
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(
//                                             SnackBar(
//                                                 content: Text(
//                                                     "Nota de venta: $unix guardada, imprimiendo.")),
//                                           );
//                                         },
//                                         icon: const Icon(Icons.save_as)),
//                                   ],
//                                 ),
//                               ],
//                               title: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     'Carrito:',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.blueAccent[800],
//                                         fontSize: 22),
//                                   ),
//                                   Text(
//                                     ' $total soles',
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.w400,
//                                         fontStyle: FontStyle.italic,
//                                         color: Colors.blueAccent[800],
//                                         fontSize: 18),
//                                   ),
//                                 ],
//                               ),
//                               content: SizedBox(
//                                 width: _ancho * .9,
//                                 height: _alto * .6,
//                                 child: Column(
//                                   children: [
//                                     SizedBox(
//                                       width: _ancho * .9,
//                                       height: _alto * .60,
//                                       child: Column(
//                                         children: [
//                                           SizedBox(
//                                             width: _ancho * .9,
//                                             height: _alto * .03,
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 SizedBox(
//                                                     width: _ancho * .15,
//                                                     child: const Text(
//                                                       "CANT",
//                                                       style: TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     )),
//                                                 SizedBox(
//                                                     width: _ancho * .35,
//                                                     child: const Text(
//                                                       "PRODUCTO/P.U.",
//                                                       style: TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     )),
//                                                 Container(
//                                                     width: _ancho * .15,
//                                                     child: const Text(
//                                                       "TOTAL",
//                                                       style: TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     ))
//                                               ],
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: _ancho * .9,
//                                             height: _alto * .55,
//                                             child: ListView.builder(
//                                               itemCount: listado.length,
//                                               itemBuilder:
//                                                   (BuildContext context,
//                                                       int index) {
//                                                 if (listado[index] > 0) {
//                                                   var sd = Decimal.parse(
//                                                           listado[index]
//                                                               .toString()) *
//                                                       Decimal.parse(prov
//                                                           .prod[index].ventaprod
//                                                           .toString());
//                                                   // total = total + sd;
//                                                   return Card(
//                                                     // color: Colors.lightBlue[50],
//                                                     color: prov.prod[index]
//                                                                 .despachorecep ==
//                                                             1
//                                                         ? Colors.white
//                                                         : Colors.yellow[700],
//                                                     child: ListTile(
//                                                       title: Text(
//                                                         prov.prod[index]
//                                                             .nombprod
//                                                             .toString(),
//                                                         style: const TextStyle(
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .w500),
//                                                       ),
//                                                       subtitle: Text(
//                                                         prov.prod[index]
//                                                             .ventaprod
//                                                             .toString(),
//                                                       ),
//                                                       leading: Column(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .center,
//                                                         children: [
//                                                           Text(
//                                                               listado[index]
//                                                                   .toString(),
//                                                               style:
//                                                                   const TextStyle(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                               )),
//                                                         ],
//                                                       ),
//                                                       trailing:
//                                                           Text(sd.toString()),
//                                                     ),
//                                                   );
//                                                 }
//                                                 return const SizedBox(
//                                                   height: 1,
//                                                 );
//                                               },
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       });
//                 },
//                 icon: const Icon(
//                   Icons.shopping_bag_rounded,
//                   size: 30,
//                 )),
//           )
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(top: 14),
//         child: SizedBox(
//           width: _ancho,
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   textformfieldsintitle(
//                     clase: "productos",
//                     ancho: _ancho * .8,
//                     controllerfield: _controllercategoria,
//                     hinttext: 'B. producto por nombre',
//                     textinputype: TextInputType.text,
//                     habilitado: true,
//                     prov: prov,
//                     busc: "tort",
//                   ),
//                   SizedBox(
//                     width: _ancho * .02,
//                   ),
//                   IconButton(
//                       onPressed: () {
//                         prov.ObtenerProducto('%%');
//                       },
//                       icon: Icon(
//                         Icons.all_inbox,
//                         color: Colors.blueAccent[200],
//                         size: 30,
//                       ))
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 15, left: 15),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Nueva orden',
//                       style: TextStyle(
//                           color: Colors.teal[700],
//                           fontWeight: FontWeight.w700,
//                           fontSize: 18),
//                     )
//                   ],
//                 ),
//               ),
//               SingleChildScrollView(
//                 child: SizedBox(
//                   width: _ancho * .95,
//                   height: _alto * .75,
//                   child: Center(
//                     child: ListView.builder(
//                       itemCount: prov.prod.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         if (iniciado == 1) {
//                           listado.add(0);
//                         }
//                         if (index == prov.prod.length) {
//                           iniciado = 0;
//                         }

//                         return Padding(
//                           padding: const EdgeInsets.only(top: 8),
//                           child: Container(
//                             width: _ancho * .95,
//                             height: 90,
//                             decoration: BoxDecoration(
//                                 // color: Color.fromARGB(255, 147, 218, 15),
//                                 borderRadius: BorderRadius.circular(5.0),
//                                 gradient: LinearGradient(colors: [
//                                   Colors.black.withOpacity(.1),
//                                   Colors.black.withOpacity(.1),
//                                   // Colors.teal.shade400
//                                 ]),
//                                 boxShadow: [
//                                   BoxShadow(
//                                       color: Colors.black.withOpacity(.1),
//                                       blurRadius: 5.0,
//                                       offset: const Offset(2.0, 2.0))
//                                 ]),
//                             child: Padding(
//                               padding: EdgeInsets.only(left: _ancho * .03),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   SizedBox(
//                                     width: _ancho * .1,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         CircleAvatar(
//                                             backgroundColor: Colors.teal,
//                                             child: Text(prov.prod[index].idprod
//                                                 .toString())),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: _ancho * .40,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         SizedBox(
//                                           width: _ancho * .35,
//                                           // color: Colors.red,
//                                           child: Center(
//                                             child: FittedBox(
//                                               child: Text(
//                                                 prov.prod[index].nombprod
//                                                     .toString(),
//                                                 style: const TextStyle(
//                                                     fontWeight: FontWeight.w400,
//                                                     overflow:
//                                                         TextOverflow.ellipsis),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Text(
//                                           "${prov.prod[index].ventaprod} sol(es).",
//                                           style: const TextStyle(
//                                               color: Colors.black45),
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: _ancho * .25,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           "${listado[index]}/${prov.prod[index].cantprod}",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w300,
//                                               fontSize: 16,
//                                               color: Colors.red.shade900),
//                                         ),
//                                         Text(
//                                           "cant. actual",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w200,
//                                               fontSize: 16,
//                                               color: Colors.red.shade700),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: _ancho * .15,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         CircleAvatar(
//                                           backgroundColor: Colors.pink[400],
//                                           foregroundColor: Colors.white,
//                                           child: IconButton(
//                                               onPressed: () {
//                                                 setState(() {
//                                                   log(listado[index]
//                                                       .toString());
//                                                   log(prov.prod[index].cantprod
//                                                       .toString());
//                                                   if (double.tryParse(
//                                                           listado[index]
//                                                               .toString())! <
//                                                       (prov
//                                                           .prod[index].cantprod!
//                                                           .toDouble())) {
//                                                     listado[index] += 1;
//                                                     cant++;
//                                                   }
//                                                 });
//                                               },
//                                               icon: const Icon(Icons.add)),
//                                         ),
//                                         const SizedBox(
//                                           height: 3,
//                                         ),
//                                         CircleAvatar(
//                                           backgroundColor:
//                                               Colors.blueAccent[200],
//                                           foregroundColor: Colors.white,
//                                           child: IconButton(
//                                               padding: const EdgeInsets.only(
//                                                   bottom: 15),
//                                               onPressed: () {
//                                                 setState(() {
//                                                   if (listado[index] > 0) {
//                                                     listado[index] -= 1;
//                                                     cant--;
//                                                   }
//                                                 });
//                                               },
//                                               icon: const Icon(
//                                                 Icons.minimize_outlined,
//                                               )),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),

//                     //TODO:NO BORRAR ME COSTO MUCHO
//                     //TODO : TRAE DATOS DE REALTIMEDATABASE EN UN LISTTILE

//                     // child: StreamBuilder(
//                     //   stream: FirebaseDatabase.instance.ref('products').onValue,
//                     //   // initialData: initialData,
//                     //   builder: (BuildContext context, AsyncSnapshot snapshot) {
//                     //     // log(snapshot.data.toString());
//                     //     if (snapshot != null && snapshot.hasData) {
//                     //       DataSnapshot dataValues = snapshot.data.snapshot;
//                     //       Map<dynamic, dynamic> values =
//                     //           dataValues.value as Map<dynamic, dynamic>;
//                     //       list.clear();
//                     //       values.forEach((key, values) {
//                     //         // lists.add(values);
//                     //         log(values.toString());
//                     //         list.add(values);
//                     //       });
//                     //     }
//                     //     return ListView.builder(
//                     //       itemCount: list.length,
//                     //       itemBuilder: (BuildContext context, int index) {
//                     //         return Card(
//                     //           child: ListTile(
//                     //             title: Text(list[index]["nombre"]),
//                     //             subtitle: Text(list[index]["venta"]),
//                     //             leading: FadeInImage.assetNetwork(
//                     //                 width: 50,
//                     //                 height: 90,
//                     //                 placeholder: 'assets/logo.png',
//                     //                 image: list[index]["url"]),
//                     //           ),
//                     //         );
//                     //       },
//                     //     );
//                     //   },
//                     // ),
//                   ),
//                   // child: Center(
//                   //   child: StreamBuilder(
//                   //     stream: FirebaseDatabase.instance.ref('products').onValue,
//                   //     // initialData: initialData,
//                   //     builder: (BuildContext context, AsyncSnapshot snapshot) {
//                   //       // log(snapshot.data.toString());
//                   //       Center(child: CircularProgressIndicator());
//                   //       if (snapshot != null && snapshot.hasData) {
//                   //         DataSnapshot dataValues = snapshot.data.snapshot;
//                   //         Map<dynamic, dynamic> values =
//                   //             dataValues.value as Map<dynamic, dynamic>;
//                   //         list.clear();
//                   //         // listado.clear();
//                   //         values.forEach((key, values) {
//                   //           // lists.add(values);
//                   //           log(values.toString());
//                   //           list.add(values);
//                   //           if (iniciado == 1) {
//                   //             listado.add(0);
//                   //           }

//                   //           // cantidades.add(values["cantidad"]);
//                   //         });
//                   //         iniciado = 0;
//                   //       }
//                   //       return ListView.builder(
//                   //         itemCount: list.length,
//                   //         itemBuilder: (BuildContext context, int index) {
//                   //           return Padding(
//                   //             padding: const EdgeInsets.only(
//                   //                 top: 15, left: 15, right: 15),
//                   //             child: Container(
//                   //               height: 90,
//                   //               decoration: BoxDecoration(
//                   //                   // color: Color.fromARGB(255, 147, 218, 15),
//                   //                   borderRadius: BorderRadius.circular(15.0),
//                   //                   gradient: LinearGradient(colors: [
//                   //                     Colors.black.withOpacity(.1),
//                   //                     Colors.black.withOpacity(.1),
//                   //                     // Colors.teal.shade400
//                   //                   ]),
//                   //                   boxShadow: [
//                   //                     BoxShadow(
//                   //                         color: Colors.black.withOpacity(.1),
//                   //                         blurRadius: 5.0,
//                   //                         offset: const Offset(2.0, 2.0))
//                   //                   ]),
//                   //               child: Row(
//                   //                 mainAxisAlignment:
//                   //                     MainAxisAlignment.spaceAround,
//                   //                 // crossAxisAlignment: CrossAxisAlignment.center,
//                   //                 children: [
//                   //                   Column(
//                   //                     mainAxisAlignment:
//                   //                         MainAxisAlignment.center,
//                   //                     children: [
//                   //                       CircleAvatar(
//                   //                         radius: 25,
//                   //                         child: ClipRRect(
//                   //                           borderRadius: BorderRadius.all(
//                   //                               Radius.circular(33)),
//                   //                           clipBehavior: Clip.antiAlias,
//                   //                           child: FadeInImage.assetNetwork(
//                   //                               width: 70,
//                   //                               height: 70,
//                   //                               fit: BoxFit.cover,
//                   //                               placeholder: 'assets/logo.png',
//                   //                               image: list[index]["url"]),
//                   //                         ),
//                   //                       ),
//                   //                     ],
//                   //                   ),
//                   //                   Column(
//                   //                     mainAxisAlignment:
//                   //                         MainAxisAlignment.center,
//                   //                     children: [
//                   //                       Text(
//                   //                         list[index]["nombre"],
//                   //                         style: TextStyle(
//                   //                             fontWeight: FontWeight.w400,
//                   //                             fontSize: 16),
//                   //                       ),
//                   //                       Text(
//                   //                         list[index]["venta"] + " sol(es)",
//                   //                         style: TextStyle(
//                   //                             fontWeight: FontWeight.w300,
//                   //                             fontSize: 14),
//                   //                       )
//                   //                     ],
//                   //                   ),
//                   //                   Column(
//                   //                     mainAxisAlignment:
//                   //                         MainAxisAlignment.center,
//                   //                     children: [
//                   //                       Text(
//                   //                         listado[index].toString() +
//                   //                             "/" +
//                   //                             list[index]["cantidad"],
//                   //                         style: TextStyle(
//                   //                             fontWeight: FontWeight.w300,
//                   //                             fontSize: 16,
//                   //                             color: Colors.red.shade900),
//                   //                       ),
//                   //                       Text(
//                   //                         "cant. actual",
//                   //                         style: TextStyle(
//                   //                             fontWeight: FontWeight.w200,
//                   //                             fontSize: 16,
//                   //                             color: Colors.red.shade700),
//                   //                       ),
//                   //                     ],
//                   //                   ),
//                   //                   Column(
//                   //                     mainAxisAlignment:
//                   //                         MainAxisAlignment.center,
//                   //                     children: [
//                   //                       CircleAvatar(
//                   //                         child: IconButton(
//                   //                             onPressed: () {
//                   //                               setState(() {
//                   //                                 if (listado[index] <
//                   //                                     int.tryParse(list[index]
//                   //                                         ["cantidad"])) {
//                   //                                   listado[index] += 1;
//                   //                                   cant++;
//                   //                                 }
//                   //                               });
//                   //                             },
//                   //                             icon: Icon(Icons.add)),
//                   //                       ),
//                   //                       SizedBox(
//                   //                         height: 3,
//                   //                       ),
//                   //                       CircleAvatar(
//                   //                         child: IconButton(
//                   //                             onPressed: () {
//                   //                               setState(() {
//                   //                                 if (listado[index] > 0) {
//                   //                                   listado[index] -= 1;
//                   //                                   cant--;
//                   //                                 }
//                   //                               });
//                   //                             },
//                   //                             icon: Icon(
//                   //                                 Icons.do_disturb_on_rounded)),
//                   //                       ),
//                   //                     ],
//                   //                   )
//                   //                 ],
//                   //               ),
//                   //             ),
//                   //           );
//                   //         },
//                   //       );
//                   //     },
//                   //   ),

//                   // ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
