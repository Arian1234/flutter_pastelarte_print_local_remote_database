import 'package:firebase_orders_flutter/CRUD/crudReporteProdmasVentas.dart';
import 'package:firebase_orders_flutter/models/modelReporteProdMasVendido.dart';
import 'package:flutter/material.dart';

class ProviderReporteProdMasVendidos extends ChangeNotifier {
  List<Reporteprodmasvendido> RPMV = [];

  ObtenerReporteProdMasVendidos(String fechai, String fechaf) async {
    final model = await DbCrudReporteProdMasVendidos.dbp
        .GetReporteProdMasVendidos(fechai, fechaf);
    RPMV = [...model];
    notifyListeners();
  }
}
