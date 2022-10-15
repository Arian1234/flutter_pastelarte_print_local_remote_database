import 'dart:developer';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_orders_flutter/controllers/controllerReportProdPorcenUtil.dart';
import 'package:firebase_orders_flutter/controllers/controllerReporteProdMasVendidos.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class reporteProdMasVendidosPage extends StatefulWidget {
  const reporteProdMasVendidosPage({Key? key}) : super(key: key);

  @override
  State<reporteProdMasVendidosPage> createState() =>
      _reporteProdMasVendidosPageState();
}

String day = "0" + DateTime.now().day.toString();
String days = (day.substring(day.length - 2, day.length));

class _reporteProdMasVendidosPageState
    extends State<reporteProdMasVendidosPage> {
  String fechai = "${DateTime.now().year}-${DateTime.now().month}-${days}";
  String fechaf = "${DateTime.now().year}-${DateTime.now().month}-${days}";
  // Decimal tot = 0.toDecimal();
  int estado = 0;

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
    var prov =
        Provider.of<ProviderReporteProdMasVendidos>(context, listen: true);

    getFormatedDate(_date) {
      var inputFormat = DateFormat('yyyy-MM-dd');
      var inputDate = inputFormat.parse(_date);
      var outputFormat = DateFormat('dd/MM/yyyy');
      return outputFormat.format(inputDate);
    }

    return WillPopScope(
      onWillPop: () async {
        prov.RPMV.clear();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Rpt. productos mas vendidos con util. promedio'"),
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
                    await prov.ObtenerReporteProdMasVendidos(fechai, fechaf);

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
                              "CANT",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: _ancho * .04,
                            ),
                            const Text(
                              "PROD/PR. V./ PR. C.",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: _ancho * .04,
                            ),
                            const Text(
                              "UTILXUND/UTILTOTAL",
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
                        itemCount: prov.RPMV.length,
                        itemBuilder: (BuildContext context, int index) {
                          // if (index == 0) {
                          //   tot = 0.toDecimal();
                          // }

                          // tot = tot +
                          //     Decimal.parse(prov.RV[index].total.toString());
                          // log("total : " + tot.toString());

                          return GestureDetector(
                            child: Card(
                              child: ListTile(
                                leading: Text(prov.RPMV[index].cant.toString()),
                                title: Text(
                                    "${prov.RPMV[index].cod} | ${prov.RPMV[index].prod}"),
                                subtitle: Text("PV: " +
                                    prov.RPMV[index].pventapromedio.toString() +
                                    "\nPC: " +
                                    prov.RPMV[index].pcostopromedio.toString()),
                                trailing: Text(
                                    "${prov.RPMV[index].utilidadxundprom} / ${prov.RPMV[index].utiltotalprom}"),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
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
