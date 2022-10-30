import 'dart:developer';
import 'package:firebase_orders_flutter/controllers/controllerCompras.dart';
import 'package:firebase_orders_flutter/controllers/controllerDetaCompra.dart';
import 'package:firebase_orders_flutter/models/modelCompras.dart';
import 'package:firebase_orders_flutter/widgets/textformfieldcustom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import '../controllers/controllerProductos.dart';
import 'package:decimal/decimal.dart';

class comprasPage extends StatefulWidget {
  final ProviderProductos provforaneo;
  const comprasPage({Key? key, required this.provforaneo}) : super(key: key);

  @override
  State<comprasPage> createState() => _comprasPageState();
}

class _comprasPageState extends State<comprasPage> {
  var listado = [];
  var iniciado = 1;
  int cant = 0;
  List<ScanResult>? scanResult;
  List<Compras> com = [];

  @override
  void initState() {
    super.initState();
    widget.provforaneo.ObtenerProducto('%%');
  }

  @override
  Widget build(BuildContext context) {
    double _ancho = MediaQuery.of(context).size.width;
    double _alto = MediaQuery.of(context).size.height;
    final prov = Provider.of<ProviderProductos>(context, listen: true);
    final _controllercategoria = TextEditingController();
    final provcompras = Provider.of<ProviderCompras>(context, listen: false);
    final provdetacompras =
        Provider.of<ProviderDetaCompra>(context, listen: false);
    Decimal total = 0.toDecimal();
    Decimal pcosto = 0.toDecimal();
    // com.add(Compras());
    // ProviderCompras().AgregarCompra(com[].idcomp, idprovee, fecharegist, fechadocu, total, amortizo, anota, esta)
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        centerTitle: true,
        title: Text('Compras: $cant'),
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
                onPressed: () async {
                  await prov.ObtenerProducto('%%');
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        log("acabo de entrar al builder");
                        total = 0.toDecimal();
                        pcosto = 0.toDecimal();

                        // ignore: prefer_interpolation_to_compose_strings
                        log("items.length:  listado " +
                            listado.length.toString());
                        for (var i = 0; i < listado.length; i++) {
                          log("acabo de entrar al for");
                          if (listado[i] > 0) {
                            var sd = Decimal.parse(listado[i].toString()) *
                                Decimal.parse(
                                    prov.prod[i].ventaprod.toString());
                            var cost = Decimal.parse(listado[i].toString()) *
                                Decimal.parse(
                                    prov.prod[i].precioprod.toString());
                            total = total + sd;

                            pcosto = pcosto + cost;
                          }
                        }
                        if (cant > 0) {
                          return Container(
                            width: _ancho * .9,
                            height: _alto * .6,
                            color: Colors.black.withOpacity(.15),
                            child: AlertDialog(
                              elevation: 1,
                              actions: [
                                Container(
                                  width: _ancho * .9,
                                  height: _alto * .1,
                                  color: Colors.pink[400],
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          total = 0.toDecimal();
                                          pcosto = 0.toDecimal();
                                        },
                                        child: buttonmodal(
                                          ancho: _ancho * .20,
                                          alto: _alto * .06,
                                          title: "Volver",
                                          icon: Icons.arrow_back_ios,
                                          primary: Colors.red.withOpacity(.8),
                                          second: Colors.red.withOpacity(.9),
                                          shadow: Colors.black26,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          final now = DateTime.now();
                                          // String fecha =
                                          //     ("${now.day}/${now.month}/${now.year}");
                                          String day = "0" + now.day.toString();
                                          String days = (day.substring(
                                              day.length - 2, day.length));
                                          String fecha =
                                              ("${now.year}-${now.month}-${days}");

                                          String unix = DateTime.now()
                                              .toUtc()
                                              .millisecondsSinceEpoch
                                              .toString();

                                          final idcompra =
                                              await provcompras.AgregarCompra(
                                                  unix,
                                                  1,
                                                  fecha,
                                                  fecha,
                                                  total.toDouble(),
                                                  total.toDouble(),
                                                  "---",
                                                  0);

                                          for (var i = 0;
                                              i < listado.length;
                                              i++) {
                                            if (listado[i] > 0) {
                                              provdetacompras.AgregarDetaCompra(
                                                  idcompra,
                                                  (prov.prod[i].idprod)!
                                                      .toInt(),
                                                  prov.prod[i].precioprod!
                                                      .toDouble(),
                                                  prov.prod[i].precioprod!
                                                      .toDouble(),
                                                  prov.prod[i].ventaprod!
                                                      .toDouble(),
                                                  double.parse(
                                                      listado[i].toString()));
                                            }
                                          }
                                          // TestPrint().sample(
                                          //     listado,
                                          //     prov,
                                          //     listado.length,
                                          //     total.toString(),
                                          //     unix);
                                          log("total : $total");

                                          //CLEAR
                                          prov.ObtenerProducto('%%');
                                          Navigator.pop(context);
                                          iniciado = 1;
                                          total = 0.toDecimal();
                                          pcosto = 0.toDecimal();
                                          setState(() {
                                            cant = 0;
                                            listado.clear();
                                          });

                                          log("Tamanio del listado " +
                                              listado.length.toString());

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    "Nota de compra: $unix guardada, imprimiendo.")),
                                          );
                                        },
                                        child: buttonmodal(
                                          ancho: _ancho * .20,
                                          alto: _alto * .06,
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
                              title: Container(
                                width: _ancho * .9,
                                height: _alto * .1,
                                color: Colors.pink[400],
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Carrito: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 22),
                                    ),
                                    Text(
                                      ' $total soles ${total - pcosto}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.white,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              content: SizedBox(
                                width: _ancho * .9,
                                height: _alto * .6,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: _ancho * .9,
                                      height: _alto * .60,
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
                                                SizedBox(
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
                                          SizedBox(
                                            width: _ancho * .9,
                                            height: _alto * .57,
                                            child: ListView.builder(
                                              itemCount: listado.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                if (listado[index] > 0) {
                                                  var sd = Decimal.parse(
                                                          listado[index]
                                                              .toString()) *
                                                      Decimal.parse(prov
                                                          .prod[index].ventaprod
                                                          .toString());

                                                  return Card(
                                                    color: prov.prod[index]
                                                                .despachorecep ==
                                                            1
                                                        ? Colors.white
                                                        : Colors.yellow[700],
                                                    child: ListTile(
                                                      title: Text(
                                                        prov.prod[index]
                                                            .nombprod
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      subtitle: Text(
                                                        prov.prod[index]
                                                            .ventaprod
                                                            .toString(),
                                                      ),
                                                      leading: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              listado[index]
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
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
                                  ],
                                ),
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
                },
                icon: const Icon(
                  Icons.shopping_cart,
                  size: 30,
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Container(
            width: _ancho,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textformfieldsintitle(
                      clase: "productos",
                      ancho: _ancho * .8,
                      controllerfield: _controllercategoria,
                      hinttext: 'B. producto por nombre',
                      textinputype: TextInputType.text,
                      habilitado: true,
                      prov: prov
                   
                    ),
                    SizedBox(
                      width: _ancho * .02,
                    ),
                    IconButton(
                        onPressed: () {
                          prov.ObtenerProducto('%%');
                        },
                        icon: Icon(
                          Icons.all_inbox,
                          color: Colors.blueAccent[200],
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
                      buttonOrdenes(
                        ancho: _ancho * .40,
                        alto: _alto * .06,
                        title: "N. orden",
                        icon: Icons.add,
                        primary: Colors.teal.withOpacity(.7),
                        second: Colors.blueAccent.withOpacity(.9),
                        shadow: Colors.white,
                      ),
                      buttonOrdenes(
                        ancho: _ancho * .40,
                        alto: _alto * .06,
                        title: "B. orden",
                        icon: Icons.find_in_page,
                        primary: Colors.red.withOpacity(.9),
                        second: Colors.pink.withOpacity(.7),
                        shadow: Colors.white,
                      )
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: SizedBox(
                    width: _ancho * .95,
                    height: _alto * .73,
                    child: Center(
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
                                              child: Text(prov
                                                  .prod[index].idprod
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
                                          SizedBox(
                                            width: _ancho * .35,
                                            // color: Colors.red,
                                            child: Center(
                                              child: FittedBox(
                                                child: Text(
                                                  prov.prod[index].nombprod
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      overflow: TextOverflow
                                                          .ellipsis),
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
                                            // ignore: prefer_interpolation_to_compose_strings
                                            listado[(int.parse(prov
                                                            .prod[index].idprod
                                                            .toString()) -
                                                        1)]
                                                    .toString() +
                                                " / " +
                                                prov.prod[index].cantprod
                                                    .toString(),
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
                                                    if (double.tryParse(listado[(prov
                                                                        .prod[
                                                                            index]
                                                                        .idprod ??
                                                                    0) -
                                                                1]
                                                            .toString())! <
                                                        (prov.prod[index]
                                                            .cantprod!
                                                            .toDouble())) {
                                                      listado[(prov.prod[index]
                                                                  .idprod ??
                                                              0) -
                                                          1] += 1;
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
                                                    if (double.tryParse(listado[
                                                                (prov.prod[index]
                                                                            .idprod ??
                                                                        0) -
                                                                    1]
                                                            .toString())! >
                                                        0) {
                                                      listado[(prov.prod[index]
                                                                  .idprod ??
                                                              0) -
                                                          1] -= 1;
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
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class buttonOrdenes extends StatelessWidget {
  const buttonOrdenes({
    Key? key,
    required double ancho,
    required double alto,
    required String title,
    required IconData icon,
    required Color primary,
    required Color second,
    required Color shadow,
  })  : _ancho = ancho,
        _alto = alto,
        _title = title,
        _icon = icon,
        _primary = primary,
        _second = second,
        _shadow = shadow,
        super(key: key);

  final double _ancho;
  final double _alto;
  final String _title;
  final IconData _icon;
  final Color _primary;
  final Color _second;
  final Color _shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            // color: Color.fromARGB(255, 147, 218, 15),
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(colors: [_primary, _second]),
            boxShadow: [
              BoxShadow(
                  color: _shadow,
                  blurRadius: 15.0,
                  offset: const Offset(2.0, 2.0))
            ]),
        width: _ancho,
        height: _alto,
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _title.isNotEmpty
                ? Text(
                    _title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w300, color: Colors.white),
                  )
                : SizedBox(),
          ),
          leading: Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Icon(
              _icon,
              color: Colors.white,
            ),
          ),
        ));
  }
}

class buttonmodal extends StatelessWidget {
  const buttonmodal({
    Key? key,
    required double ancho,
    required double alto,
    required String title,
    required IconData icon,
    required Color primary,
    required Color second,
    required Color shadow,
  })  : _ancho = ancho,
        _alto = alto,
        _title = title,
        _icon = icon,
        _primary = primary,
        _second = second,
        _shadow = shadow,
        super(key: key);

  final double _ancho;
  final double _alto;
  final String _title;
  final IconData _icon;
  final Color _primary;
  final Color _second;
  final Color _shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            // color: Color.fromARGB(255, 147, 218, 15),
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(colors: [_primary, _second]),
            boxShadow: [
              BoxShadow(
                  color: _shadow,
                  blurRadius: 15.0,
                  offset: const Offset(2.0, 2.0))
            ]),
        width: _ancho,
        height: _alto,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _icon,
              color: Colors.white,
            ),
            Text(
              _title,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ));
  }
}
