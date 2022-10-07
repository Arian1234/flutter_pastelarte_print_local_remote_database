import 'dart:developer';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_orders_flutter/CRUD/crudReportes.dart';
import 'package:firebase_orders_flutter/controllers/controllerReporteVentas.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  @override
  initState() {
    // TODO: implement initState
    super.initState();
  }

  Future cargar() async {
    final x = await DbCrudReportes.dbp.ObtenerVentasHoy();
    log(x.toString());
  }

  @override
  Widget build(BuildContext context) {
    double _ancho = MediaQuery.of(context).size.width;
    double _alto = MediaQuery.of(context).size.height;
    final _controllerfechainicial = TextEditingController();
    final prov = Provider.of<ProviderReporteVenta>(context, listen: true);

    getFormatedDate(_date) {
      var inputFormat = DateFormat('yyyy-MM-dd');
      var inputDate = inputFormat.parse(_date);
      var outputFormat = DateFormat('dd/MM/yyyy');
      return outputFormat.format(inputDate);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reporte del dia"),
        centerTitle: true,
        backgroundColor: Colors.pink[400],
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
                onPressed: () async {
                  log("fecha i:" + fechai + " fecha f:" + fechaf);
                  await prov.ObtenerReporteVenta(fechai, fechaf);
                },
                icon: const Icon(
                  Icons.manage_search_sharp,
                  size: 30,
                )),
          ),
          IconButton(
              onPressed: () {
                log("${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}");
              },
              icon: Icon(Icons.delete))
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

                              selectableDayPredicate: (date) {
                                // Disable weekend days to select from the calendar
                                if (date.weekday == 6 || date.weekday == 7) {
                                  return false;
                                }

                                return true;
                              },
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
                              // timeLabelText: "Hour",
                              selectableDayPredicate: (date) {
                                // Disable weekend days to select from the calendar
                                if (date.weekday == 6 || date.weekday == 7) {
                                  return false;
                                }

                                return true;
                              },
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
                    height: _alto * .75,
                    child: ListView.builder(
                      itemCount: prov.RV.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                            leading: Text(prov.RV[index].cod.toString()),
                            title: Text(
                                "${prov.RV[index].cliente}| ${prov.RV[index].fecha}"),
                            subtitle: Text(prov.RV[index].ganancia.toString()),
                            trailing: Text(prov.RV[index].total.toString()),
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
    );
  }
}
