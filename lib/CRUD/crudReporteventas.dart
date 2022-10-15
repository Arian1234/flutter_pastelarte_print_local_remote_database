import 'dart:developer';

import 'package:firebase_orders_flutter/models/modelReporteVenta.dart';

import '../database/db_dbprovider.dart';

class DbCrudReporteVentas {
  static final DbCrudReporteVentas dbp = DbCrudReporteVentas._();
  DbCrudReporteVentas._();

  Future<List<Reporteventa>> GetReporteVenta(
      String fechai, String fechaf) async {
    final db = await DBProvider.db.getdatabase();
    // final res = await db.query('CLIENTES',
    //     where: 'nombclie like ?', whereArgs: [busqueda.toString()]);
    final res = await db.rawQuery(
        'SELECT O.fechahoraord AS "FECHA",O.idord AS "COD" ,O.unix AS "ORDEN",C.nombclie AS "CLIENTE",O.totalord AS "TOTAL",O.margenord AS "GANANCIA" FROM ORDEN O INNER JOIN CLIENTES C on O.idclie=C.idclie WHERE O.fechahoraord BETWEEN "$fechai" AND "$fechaf";');
    return res.isNotEmpty
        ? res.map((e) => Reporteventa.fromJson(e)).toList()
        : [];
  }
}
