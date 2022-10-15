import 'package:decimal/decimal.dart';
import 'package:firebase_orders_flutter/CRUD/crudReporteProdPorcenUtil.dart';
import 'package:firebase_orders_flutter/models/modelReportProdPorcenUtil.dart';

import 'package:flutter/material.dart';

class ProviderReporteProdPorcenUtil extends ChangeNotifier {
  List<Reporteprodporcenutil> RPU = [];

  ObtenerReporteProdPorcentajeUtil() async {
    var totales = 0.toDecimal();
    var utilidades = 0.toDecimal();
    final model =
        await DbCrudReporteProdPorcenUtil.dbp.GetReporteProdPorcenUtil();
    RPU = [...model];
    for (var i = 0; i < RPU.length; i++) {
      // log('${RV[i].fecha} - ${RV[i].cod}${RV[i].orden}${RV[i].cliente}${RV[i].total}${RV[i].ganancia}');
      // totales = totales + Decimal.parse(RV[i].total.toString());
      // utilidades = utilidades + Decimal.parse(RV[i].ganancia.toString());
    }
    notifyListeners();
    // return "T. de ordenes:" +
    //     totales.toString() +
    //     " / Utilidades: " +
    //     utilidades.toString();
  }
}
