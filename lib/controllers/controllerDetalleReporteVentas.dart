import 'dart:developer';
import 'package:firebase_orders_flutter/CRUD/crudReporteDetalleVenta.dart';
import 'package:firebase_orders_flutter/models/modelDetalleReporteVenta.dart';
import 'package:flutter/material.dart';

class ProviderDetalleReporteVenta extends ChangeNotifier {
  List<Detallereporteventa> DRV = [];

  ObtenerDetalleReporteVenta(String id) async {
    // var totales = 0.toDecimal();
    // var utilidades = 0.toDecimal();
    final model =
        await DbCrudDetalleReporteVentas.dbp.GetDetalleReporteVenta(id);
    DRV = [...model];
    for (var i = 0; i < DRV.length; i++) {
      log('${DRV[i].prod} - ${DRV[i].cant}--${DRV[i].publ}--${DRV[i].cost}--${DRV[i].utild}');
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
