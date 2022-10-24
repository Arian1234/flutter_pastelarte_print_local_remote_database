import 'dart:developer';
import 'package:decimal/decimal.dart';
import 'package:firebase_orders_flutter/CRUD/crudReporteCompras.dart';
import 'package:firebase_orders_flutter/models/modelReporteCompras.dart';
import 'package:flutter/material.dart';

class ProviderReporteCompras extends ChangeNotifier {
  List<Reportecompras> RC = [];

  ObtenerReporteCompras(String fechai, String fechaf) async {
    var totalcompras = 0.toDecimal();
    var amortizado = 0.toDecimal();
    final model =
        await DbCrudReporteCompras.dbp.GetReporteCompras(fechai, fechaf);
    RC = [...model];
    for (var i = 0; i < RC.length; i++) {
      // log('${RC[i].fechadereg} - ${RC[i].idcomp}${RC[i].nrodoc}${RC[i].nombprovee}${RC[i].totalc}${RC[i].amortizoc}');
      totalcompras = totalcompras + Decimal.parse(RC[i].total.toString());
      amortizado = amortizado + Decimal.parse(RC[i].amortizado.toString());
    }
    notifyListeners();
    return "T. de compras:" +
        totalcompras.toString() +
        " / Amortizado: " +
        amortizado.toString();
  }
}
