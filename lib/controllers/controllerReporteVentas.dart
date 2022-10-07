import 'dart:developer';

import 'package:firebase_orders_flutter/CRUD/crudReporteventas.dart';
import 'package:firebase_orders_flutter/models/modelReporteVenta.dart';
import 'package:flutter/material.dart';

class ProviderReporteVenta extends ChangeNotifier {
  List<Reporteventa> RV = [];

  ObtenerReporteVenta(String fechai, String fechaf) async {
    log('buscando');
    final model = await DbCrudReporteVentas.dbp
        .GetReporteVenta(fechai, fechaf);
    RV = [...model];
    for (var i = 0; i < RV.length; i++) {
      log('${RV[i].fecha} - ${RV[i].cod}${RV[i].orden}${RV[i].cliente}${RV[i].total}${RV[i].ganancia}');
      print('object');
    }
    notifyListeners();
  }
}
