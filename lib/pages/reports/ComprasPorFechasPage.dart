import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:decimal/decimal.dart';

import 'package:firebase_orders_flutter/controllers/controllerReporteCompras.dart';
import 'package:firebase_orders_flutter/controllers/controllerReporteDetllCompras.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../widgets/buttonsCustoms.dart';

class comprasPorFechasPage extends StatefulWidget {
  const comprasPorFechasPage({Key? key}) : super(key: key);

  @override
  State<comprasPorFechasPage> createState() => _comprasPorFechasPageState();
}

String day = "0" + DateTime.now().day.toString();
String days = (day.substring(day.length - 2, day.length));

class _comprasPorFechasPageState extends State<comprasPorFechasPage> {
  String fechai = "${DateTime.now().year}-${DateTime.now().month}-${days}";
  String fechaf = "${DateTime.now().year}-${DateTime.now().month}-${days}";
  Decimal tot = 0.toDecimal();
  int estado = 0;
  String resumen = "";
  @override
  initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _ancho = MediaQuery.of(context).size.width;
    double _alto = MediaQuery.of(context).size.height;
    final _controllerfechainicial = TextEditingController();
    var provc = Provider.of<ProviderReporteCompras>(context, listen: true);
    var provdeta =
        Provider.of<ProviderReporteDetalleCompras>(context, listen: true);

    getFormatedDate(_date) {
      var inputFormat = DateFormat('yyyy-MM-dd');
      var inputDate = inputFormat.parse(_date);
      var outputFormat = DateFormat('dd/MM/yyyy');
      return outputFormat.format(inputDate);
    }

    return WillPopScope(
      onWillPop: () async {
        provc.RC.clear();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Reporte de compras"),
          centerTitle: true,
          backgroundColor: Colors.pink[400],
          elevation: 1,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                  onPressed: () async {
                    // log("fecha i:" + fechai + " fecha f:" + fechaf);
                    // total = 0.toDecimal();
                    resumen = await provc.ObtenerReporteCompras(fechai, fechaf);

                    // setState(() {
                    //   tot = tot;
                    // });
                  },
                  icon: const Icon(
                    Icons.manage_search_sharp,
                    size: 30,
                  )),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 14, left: 20),
            child: SizedBox(
              width: _ancho * .90,
              height: _alto * .9,
              // color: Colors.teal,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: _ancho * .4,
                              child: DateTimePicker(
                                type: DateTimePickerType.date,
                                // dateMask: 'd MMM, yyyy',
                                dateMask: 'd MMM, yyyy',
                                initialValue: DateTime.now().toString(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                icon: const Icon(Icons.event),

                                dateLabelText: 'Fecha inicial',

                                // selectableDayPredicate: (date) {
                                //   // Disable weekend days to select from the calendar
                                //   if (date.weekday == 6 || date.weekday == 7) {
                                //     return false;
                                //   }

                                //   return true;
                                // },
                                onChanged: (val) {
                                  // log(getFormatedDate(val));
                                  // fechai = getFormatedDate(val);
                                  log(val);
                                  fechai = val;
                                },
                                validator: (val) {
                                  log("fecha validator :$val");
                                  return null;
                                },
                                onSaved: (val) => log(val.toString()),
                              )),
                          Container(
                              width: _ancho * .4,
                              child: DateTimePicker(
                                type: DateTimePickerType.date,
                                // dateMask: 'd MMM, yyyy',
                                dateMask: 'd MMM, yyyy',
                                initialValue: DateTime.now().toString(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                icon: const Icon(Icons.event),

                                dateLabelText: 'Fecha final',

                                onChanged: (val) {
                                  // log(getFormatedDate(val));
                                  // fechaf = getFormatedDate(val);
                                  log(val);
                                  fechaf = val;
                                },
                                validator: (val) {
                                  log("fecha validator :$val");
                                  return null;
                                },
                                onSaved: (val) => log(val.toString()),
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: Container(
                        child: Row(
                          children: [
                            const Text(
                              "COD",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: _ancho * .10,
                            ),
                            const Text(
                              "CLIENTE/FECHA/UTILIDAD",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: _ancho * .08,
                            ),
                            const Text(
                              "T. ORDEN",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: _ancho * .9,
                      height: _alto * .72,
                      child: ListView.builder(
                        itemCount: provc.RC.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            tot = 0.toDecimal();
                          }

                          tot = tot +
                              Decimal.parse(provc.RC[index].total.toString());
                          log("total : " + tot.toString());

                          return GestureDetector(
                            onTap: () async {
                              await provdeta.ObtenerDetalleReporteCompras(
                                  provc.RC[index].cod.toString());
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: _ancho * .9,
                                      height: _alto * .9,
                                      child: AlertDialog(
                                        elevation: 1,
                                        actions: [
                                          Container(
                                              width: _ancho * .9,
                                              height: _alto * .1,
                                              color: Colors.pink[400],
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: buttonmodal(
                                                      ancho: _ancho * .20,
                                                      alto: _alto * .06,
                                                      title: "Volver",
                                                      icon:
                                                          Icons.arrow_back_ios,
                                                      primary: Colors.red
                                                          .withOpacity(.8),
                                                      second: Colors.red
                                                          .withOpacity(.9),
                                                      shadow: Colors.black26,
                                                    ),
                                                  ),
                                                ],
                                              ))
                                        ],
                                        title: Container(
                                          width: _ancho * .9,
                                          height: _alto * .1,
                                          color: Colors.pink[400],
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: const [
                                                  Text(
                                                    'T. Compra ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 22),
                                                  ),
                                                  Text(
                                                    'T. amortizado ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 22),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    provc.RC[index].amortizado
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: Colors.white,
                                                        fontSize: 18),
                                                  ),
                                                  Text(
                                                    provc.RC[index].amortizado
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: Colors.white,
                                                        fontSize: 18),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        content: Column(
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
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  SizedBox(
                                                      width: _ancho * .35,
                                                      child: const Text(
                                                        "PRODUCTO/P.U.",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  // Container(
                                                  //     width: _ancho * .15,
                                                  //     child: const Text(
                                                  //       "TOTAL",
                                                  //       style: TextStyle(
                                                  //           fontWeight:
                                                  //               FontWeight
                                                  //                   .bold),
                                                  //     ))
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: _ancho * .9,
                                              height: _alto * .57,
                                              child: ListView.builder(
                                                itemCount: provdeta.DRC.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Container(
                                                    width: _ancho * .8,
                                                    child: ListTile(
                                                      title: Text(provdeta
                                                              .DRC[index].prod
                                                              .toString() +
                                                          "\nP. ANT: " +
                                                          provdeta.DRC[index]
                                                              .precioant
                                                              .toString()),
                                                      subtitle: Text("P.P. : " +
                                                          provdeta.DRC[index]
                                                              .precvent
                                                              .toString() +
                                                          "\nP.C. : " +
                                                          provdeta
                                                              .DRC[index].precio
                                                              .toString()),
                                                      leading: Text(provdeta
                                                          .DRC[index].cant
                                                          .toString()),
                                                      // trailing: Text(provdeta
                                                      //         .DRC[index].cant
                                                      //         .toString() +
                                                      //     " UND"),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Card(
                              child: ListTile(
                                leading: Text(provc.RC[index].cod.toString()),
                                title: Text(
                                    "${provc.RC[index].proveedor}| ${provc.RC[index].doc}"),
                                subtitle:
                                    Text(provc.RC[index].registrado.toString()),
                                trailing:
                                    Text(provc.RC[index].total.toString()),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      width: _ancho * .9,
                      height: _alto * .05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            resumen.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
