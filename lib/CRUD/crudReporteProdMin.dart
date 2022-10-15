import 'package:firebase_orders_flutter/models/modelReporteProdMin.dart';
import '../database/db_dbprovider.dart';

class DbCrudReporteProdMin {
  static final DbCrudReporteProdMin dbp = DbCrudReporteProdMin._();
  DbCrudReporteProdMin._();

  Future<List<Reporteprodmin>> GetReporteVenta() async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.rawQuery(
        'SELECT P.idprod AS "COD",P.nombprod AS "PROD",P.cantprod AS "CANT",P.minstock AS "CANTMIN" FROM PRODUCTOS P WHERE P.cantprod<P.minstock;');
    return res.isNotEmpty
        ? res.map((e) => Reporteprodmin.fromJson(e)).toList()
        : [];
  }
}
