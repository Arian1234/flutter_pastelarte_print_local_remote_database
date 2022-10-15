import 'dart:developer';
import 'dart:ffi';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:decimal/decimal.dart';
import 'package:firebase_orders_flutter/controllers/controllerDetalleReporteVentas.dart';
import 'package:firebase_orders_flutter/controllers/controllerReporteVentas.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../OrdenPage.dart';

class ventashoyPage extends StatefulWidget {
  const ventashoyPage({Key? key}) : super(key: key);

  @override
  State<ventashoyPage> createState() => _ventashoyPageState();
}

String day = "0" + DateTime.now().day.toString();
String days = (day.substring(day.length - 2, day.length));

class _ventashoyPageState extends State<ventashoyPage> {
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _ancho = MediaQuery.of(context).size.width;
    double _alto = MediaQuery.of(context).size.height;
    final _controllerfechainicial = TextEditingController();
    var prov = Provider.of<ProviderReporteVenta>(context, listen: true);
    var provdeta =
        Provider.of<ProviderDetalleReporteVenta>(context, listen: true);

    getFormatedDate(_date) {
      var inputFormat = DateFormat('yyyy-MM-dd');
      var inputDate = inputFormat.parse(_date);
      var outputFormat = DateFormat('dd/MM/yyyy');
      return outputFormat.format(inputDate);
    }

    return WillPopScope(
      onWillPop: () async {
        prov.RV.clear();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Reporte de ordenes"),
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
                    resumen = await prov.ObtenerReporteVenta(fechai, fechaf);

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
                        itemCount: prov.RV.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            tot = 0.toDecimal();
                          }

                          tot = tot +
                              Decimal.parse(prov.RV[index].total.toString());
                          log("total : " + tot.toString());

                          return GestureDetector(
                            onTap: () async {
                              await provdeta.ObtenerDetalleReporteVenta(
                                  prov.RV[index].cod.toString());
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
                                                    'T. Orden ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 22),
                                                  ),
                                                  Text(
                                                    'T. Utilidad ',
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
                                                    prov.RV[index].total
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
                                                    prov.RV[index].ganancia
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
                                                  Container(
                                                      width: _ancho * .15,
                                                      child: const Text(
                                                        "TOTAL",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ))
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: _ancho * .9,
                                              height: _alto * .57,
                                              child: ListView.builder(
                                                itemCount: provdeta.DRV.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Container(
                                                    width: _ancho * .8,
                                                    child: ListTile(
                                                      title: Text(provdeta
                                                          .DRV[index].prod
                                                          .toString()),
                                                      subtitle: Text("P.P. : " +
                                                          provdeta
                                                              .DRV[index].publ
                                                              .toString() +
                                                          "\nP.C. : " +
                                                          provdeta
                                                              .DRV[index].cost
                                                              .toString()),
                                                      leading: Text(provdeta
                                                          .DRV[index].cant
                                                          .toString()),
                                                      trailing: Text(provdeta
                                                          .DRV[index].utild
                                                          .toString()),
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
                                leading: Text(prov.RV[index].cod.toString()),
                                title: Text(
                                    "${prov.RV[index].cliente}| ${prov.RV[index].fecha}"),
                                subtitle:
                                    Text(prov.RV[index].ganancia.toString()),
                                trailing: Text(prov.RV[index].total.toString()),
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
