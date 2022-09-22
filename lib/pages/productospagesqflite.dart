import 'dart:convert';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_orders_flutter/widgets/textformfieldcustom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/controllerProductos.dart';

class productospagesqflite extends StatefulWidget {
  const productospagesqflite({Key? key}) : super(key: key);

  @override
  State<productospagesqflite> createState() => _productospagesqfliteState();
}

class _productospagesqfliteState extends State<productospagesqflite> {
  final fb = FirebaseDatabase.instance.ref().child('products');
  List list = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _ancho = MediaQuery.of(context).size.width;
    double _alto = MediaQuery.of(context).size.height;
    final prov = Provider.of<ProviderProductos>(context, listen: true);

    final _controllercategoria = TextEditingController();
    final _controllerbuscador = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        actions: [
          IconButton(
              onPressed: () async {
                fb.once().then((snap) {
                  var data = snap.snapshot;
                  list.clear();

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
                      controllerfield: _controllerbuscador,
                      hinttext: 'Buscar producto .',
                      textinputype: TextInputType.text,
                      habilitado: true),
                  SizedBox(
                    width: _ancho * .02,
                  ),
                  IconButton(
                      onPressed: () {
                        if (_controllerbuscador.text.toString().isNotEmpty) {
                          prov.ObtenerProducto(
                              '%' + _controllerbuscador.text.toString() + '%');
                        }
                      },
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
                  child: ListView.builder(
                    itemCount: prov.prod.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(prov.prod[index].nombprod.toString()),
                        subtitle: Text(prov.prod[index].cantprod.toString()),
                        leading: Text(prov.prod[index].idprod.toString()),
                        trailing: Text(prov.prod[index].precioprod.toString() +
                            " sol(es)."),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
