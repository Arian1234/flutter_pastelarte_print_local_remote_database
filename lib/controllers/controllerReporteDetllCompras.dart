import 'package:firebase_orders_flutter/CRUD/crudReporteDtllCompras.dart';
import 'package:flutter/material.dart';
import '../models/modelDtlleCompra.dart';

class ProviderReporteDetalleCompras extends ChangeNotifier {
  List<Reportedtllecompras> DRC = [];

  ObtenerDetalleReporteCompras(String id) async {
    final model =
        await DbCrudReporteDetalleCompras.dbp.GetDetalleReporteCompras(id);
    DRC = [...model];
    notifyListeners();
  }
}
