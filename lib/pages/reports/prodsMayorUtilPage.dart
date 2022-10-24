
import 'package:firebase_orders_flutter/controllers/controllerReportProdPorcenUtil.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class reporteProdPorcUtilPage extends StatefulWidget {
  const reporteProdPorcUtilPage({Key? key}) : super(key: key);

  @override
  State<reporteProdPorcUtilPage> createState() =>
      _reporteProdPorcUtilPageState();
}

String day = "0" + DateTime.now().day.toString();
String days = (day.substring(day.length - 2, day.length));

class _reporteProdPorcUtilPageState extends State<reporteProdPorcUtilPage> {
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
        Provider.of<ProviderReporteProdPorcenUtil>(context, listen: true);

    getFormatedDate(_date) {
      var inputFormat = DateFormat('yyyy-MM-dd');
      var inputDate = inputFormat.parse(_date);
      var outputFormat = DateFormat('dd/MM/yyyy');
      return outputFormat.format(inputDate);
    }

    return WillPopScope(
      onWillPop: () async {
        prov.RPU.clear();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
              "Rpt. productos con porcentaje de utilidad desde el precio costo"),
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
                    await prov.ObtenerReporteProdPorcentajeUtil();

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
                              "PRODUCTO/PR. V./ PR. C.",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: _ancho * .08,
                            ),
                            const Text(
                              "% DE UTIL.",
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
                        itemCount: prov.RPU.length,
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
                                leading: Text(prov.RPU[index].cod.toString()),
                                title: Text(prov.RPU[index].prod.toString()),
                                subtitle: Text("PV: " +
                                    prov.RPU[index].vent.toString() +
                                    "\nPC: " +
                                    prov.RPU[index].cost.toString()),
                                trailing: Text(
                                    prov.RPU[index].porc.toString() + " %"),
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
