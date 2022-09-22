import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_orders_flutter/pages/testprint.dart';
import 'package:firebase_orders_flutter/widgets/textformfieldcustom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

FlutterBlue flutterBlue = FlutterBlue.instance;

class ordenespage extends StatefulWidget {
  const ordenespage({Key? key}) : super(key: key);

  @override
  State<ordenespage> createState() => _ordenespageState();
}

class _ordenespageState extends State<ordenespage> {
  final fb = FirebaseDatabase.instance.ref().child('products');
  List list = [];
  var listado = [];
  var iniciado = 1;
  int cant = 0;
  List<ScanResult>? scanResult;

  @override
  void initState() {
    super.initState();

  }




  @override
  Widget build(BuildContext context) {
    double _ancho = MediaQuery.of(context).size.width;
    double _alto = MediaQuery.of(context).size.height;

    final _controllercategoria = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Productos : ' + cant.toString()),
        elevation: 1,
        actions: [
          IconButton(onPressed: () async {}, icon: Icon(Icons.delete)),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        double total = 0;
                        return AlertDialog(
                          title: Text('Productos en carrito'),
                          content: Container(
                            width: _ancho * .7,
                            height: _alto * .55,
                            child: Column(
                              children: [
                                Container(
                                  width: _ancho * .7,
                                  height: _alto * .45,
                                  child: ListView.builder(
                                    itemCount: listado.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (listado[index] > 0) {
                                        var sd = double.parse(
                                                listado[index].toString()) *
                                            double.parse(list[index]["venta"]
                                                .toString());

                                        total = total + sd;

                                        return ListTile(
                                          title: Text(
                                              list[index]["nombre"].toString()),
                                          subtitle: Text(
                                              list[index]["venta"].toString()),
                                          leading:
                                              Text(listado[index].toString()),
                                          trailing: Text(sd.toString()),
                                        );
                                      }
                                      return const SizedBox(
                                        height: 1,
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            TestPrint().sample(listado, list,
                                                listado.length, total);
                                          },
                                          iconSize: 53,
                                          icon: const Icon(
                                              Icons.local_printshop)),
                                      Text("Guardar e imprimir")
                                    ],
                                  ),
                                )
                              ],
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
                padding: const EdgeInsets.only(top: 10, left: 15, bottom: 10),
                child: Row(
                  children: const [
                    Text(
                      'Nueva orden',
                      style: TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  width: _ancho * .95,
                  height: _alto * .75,
                  child: Center(
                    child: StreamBuilder(
                      stream: FirebaseDatabase.instance.ref('products').onValue,
                      // initialData: initialData,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        // log(snapshot.data.toString());
                        Center(child: CircularProgressIndicator());
                        if (snapshot != null && snapshot.hasData) {
                          DataSnapshot dataValues = snapshot.data.snapshot;
                          Map<dynamic, dynamic> values =
                              dataValues.value as Map<dynamic, dynamic>;
                          list.clear();
                          // listado.clear();
                          values.forEach((key, values) {
                            // lists.add(values);
                            log(values.toString());
                            list.add(values);
                            if (iniciado == 1) {
                              listado.add(0);
                            }

                            // cantidades.add(values["cantidad"]);
                          });
                          iniciado = 0;
                        }
                        return ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 15, right: 15),
                              child: Container(
                                height: 90,
                                decoration: BoxDecoration(
                                    // color: Color.fromARGB(255, 147, 218, 15),
                                    borderRadius: BorderRadius.circular(15.0),
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 25,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(33)),
                                            clipBehavior: Clip.antiAlias,
                                            child: FadeInImage.assetNetwork(
                                                width: 70,
                                                height: 70,
                                                fit: BoxFit.cover,
                                                placeholder: 'assets/logo.png',
                                                image: list[index]["url"]),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          list[index]["nombre"],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          list[index]["venta"] + " sol(es)",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 14),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          listado[index].toString() +
                                              "/" +
                                              list[index]["cantidad"],
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
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (listado[index] <
                                                      int.tryParse(list[index]
                                                          ["cantidad"])) {
                                                    listado[index] += 1;
                                                    cant++;
                                                  }
                                                });
                                              },
                                              icon: Icon(Icons.add)),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        CircleAvatar(
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (listado[index] > 0) {
                                                    listado[index] -= 1;
                                                    cant--;
                                                  }
                                                });
                                              },
                                              icon: Icon(
                                                  Icons.do_disturb_on_rounded)),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
