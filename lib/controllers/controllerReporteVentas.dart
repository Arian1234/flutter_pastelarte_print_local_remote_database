import 'dart:developer';

import 'package:decimal/decimal.dart';
import 'package:firebase_orders_flutter/CRUD/crudReporteventas.dart';
import 'package:firebase_orders_flutter/models/modelReporteVenta.dart';
import 'package:flutter/material.dart';

class ProviderReporteVenta extends ChangeNotifier {
  List<Reporteventa> RV = [];

  ObtenerReporteVenta(String fechai, String fechaf) async {
    var totales = 0.toDecimal();
    var utilidades = 0.toDecimal();
    final model = await DbCrudReporteVentas.dbp.GetReporteVenta(fechai, fechaf);
    RV = [...model];
    for (var i = 0; i < RV.length; i++) {
      log('${RV[i].fecha} - ${RV[i].cod}${RV[i].orden}${RV[i].cliente}${RV[i].total}${RV[i].ganancia}');
      totales = totales + Decimal.parse(RV[i].total.toString());
      utilidades = utilidades + Decimal.parse(RV[i].ganancia.toString());
    }
    notifyListeners();
    return "T. de ordenes:" +
        totales.toString() +
        " / Utilidades: " +
        utilidades.toString();
  }
}
