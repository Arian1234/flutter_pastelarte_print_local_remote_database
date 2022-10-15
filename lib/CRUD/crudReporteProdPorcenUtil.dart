import 'dart:developer';

import 'package:firebase_orders_flutter/models/modelReportProdPorcenUtil.dart';
import '../database/db_dbprovider.dart';

class DbCrudReporteProdPorcenUtil {
  static final DbCrudReporteProdPorcenUtil dbp =
      DbCrudReporteProdPorcenUtil._();
  DbCrudReporteProdPorcenUtil._();

  Future<List<Reporteprodporcenutil>> GetReporteProdPorcenUtil() async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.rawQuery(
        'SELECT  P.idprod as "COD",P.nombprod AS "PROD",ROUND(P.ventaprod,2) AS "VENT",ROUND(P.precioprod,2) AS "COST",ROUND(ROUND((ROUND(P.ventaprod,2)-ROUND(P.precioprod,2))/P.precioprod,2)*100,2) AS "PORC" FROM PRODUCTOS P ORDER BY (ROUND((ROUND(P.ventaprod,2)-ROUND(P.precioprod,2))/P.precioprod,1)*100) DESC;');
    return res.isNotEmpty
        ? res.map((e) => Reporteprodporcenutil.fromJson(e)).toList()
        : [];
  }
}
