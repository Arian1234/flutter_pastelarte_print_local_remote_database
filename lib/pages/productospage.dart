import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_orders_flutter/models/modelProductos.dart';
import 'package:firebase_orders_flutter/pages/productospageinsert.dart';
import 'package:firebase_orders_flutter/widgets/textformfieldcustom.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class productospage extends StatefulWidget {
  const productospage({Key? key}) : super(key: key);

  @override
  State<productospage> createState() => _productospageState();
}

class _productospageState extends State<productospage> {
  final fb = FirebaseDatabase.instance.ref().child('products');
  List list = [];
  @override
  void initState() {
    super.initState();
    // fb.once().then((snap) {
    //   var data = snap.snapshot;
    //   DataSnapshot datos = data;

    //   list.clear();
    //   log(data.value.toString());
    // });
  }

  @override
  Widget build(BuildContext context) {
    double _ancho = MediaQuery.of(context).size.width;
    double _alto = MediaQuery.of(context).size.height;

    final _controllercategoria = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        actions: [
          IconButton(
              onPressed: () async {
                fb.once().then((snap) {
                  var data = snap.snapshot;
                  list.clear();

                  // log(data.value.toString());
                  // prod = new Productos(data.value);
                  var json = jsonDecode(data.value.toString());
                  log(json["nombre"] + "   JSON");
                });
              },
              icon: Icon(Icons.read_more)),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'imagenes_carga');
                },
                icon: const Icon(
                  Icons.add,
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
                padding: const EdgeInsets.only(top: 10, left: 15, bottom: 10),
                child: Row(
                  children: const [
                    Text(
                      'Registros de productos',
                      style: TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    )
                  ],
                ),
              ),
              Container(
                width: _ancho * .95,
                height: 500,
                child: Center(
                  child: StreamBuilder(
                    stream: FirebaseDatabase.instance.ref('products').onValue,
                    // initialData: initialData,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      // log(snapshot.data.toString());
                      if (snapshot != null && snapshot.hasData) {
                        DataSnapshot dataValues = snapshot.data.snapshot;
                        Map<dynamic, dynamic> values =
                            dataValues.value as Map<dynamic, dynamic>;
                        list.clear();
                        values.forEach((key, values) {
                          // lists.add(values);
                          log(values.toString());
                          list.add(values);
                        });
                      }
                      return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              title: Text(list[index]["nombre"]),
                              subtitle: Text(list[index]["venta"]),
                              leading: FadeInImage.assetNetwork(
                                  width: 50,
                                  height: 90,
                                  placeholder: 'assets/logo.png',
                                  image: list[index]["url"]),
                            ),
                          );
                        },
                      );

                      // if (snapshot.hasData) {
                      //   DataSnapshot datavalues =
                      //       snapshot.data! as DataSnapshot;
                      //   Map<dynamic, dynamic> values =
                      //       snapshot.data as Map<dynamic, dynamic>;
                      //   values.forEach((key, value) {
                      //     log(value.toString());
                      //   });
                      // }
                      // return CircularProgressIndicator();
                      // // return ListView(
                      // //   children: [Text(snapshot.data.toString())],
                      // // );
                    },
                  ),
                  //     child: StreamBuilder(
                  //   stream:
                  //       FirebaseDatabase.instance.ref().child('products').onValue,
                  //   builder: (context, AsyncSnapshot snapshot) {
                  //     if (!snapshot.hasData) {
                  //       return Container(child: Center(child: Text("No data")));
                  //     }
                  //     return ListView.builder(
                  //       padding: EdgeInsets.all(8.0),
                  //       itemCount: 1,
                  //       // reverse: true,
                  //       itemBuilder: (_, int index) {
                  //         return ListTile(
                  //             title: Text(
                  //               snapshot.data!.snapshot
                  //                   // .child("nombre")
                  //                   .value
                  //                   .toString(),
                  //             ),
                  //             subtitle: Text(index.toString()),
                  //             leading: ClipRRect(
                  //               borderRadius:
                  //                   BorderRadius.all(Radius.circular(35)),
                  //               child: FadeInImage.assetNetwork(
                  //                 width: 50,
                  //                 height: 90,
                  //                 placeholder: 'assets/logo.png',
                  //                 image: snapshot.data!.snapshot
                  //                     .child("url")
                  //                     .value
                  //                     .toString(),
                  //               ),
                  //             )

                  //             //  Image.network(
                  //             //         snapshot.data!.snapshot
                  //             //             .child("url")
                  //             //             .value
                  //             //             .toString(),
                  //             //       )

                  //             );
                  //       },
                  //     );
                  //   },
                  // )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
