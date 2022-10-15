import 'package:firebase_orders_flutter/models/modelReporteProdMasVendido.dart';
import '../database/db_dbprovider.dart';

class DbCrudReporteProdMasVendidos {
  static final DbCrudReporteProdMasVendidos dbp =
      DbCrudReporteProdMasVendidos._();
  DbCrudReporteProdMasVendidos._();

  Future<List<Reporteprodmasvendido>> GetReporteProdMasVendidos(
      String fechai, String fechaf) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.rawQuery(
        'SELECT P.idprod AS "COD",P.nombprod AS "PROD", ROUND(SUM(DO.cantprod),2) AS "CANT",ROUND(SUM(DO.preciovprod*DO.cantprod)/SUM(DO.cantprod),2) AS "PVENTAPROMEDIO",ROUND(SUM(DO.preciocprod*DO.cantprod)/SUM(DO.cantprod),2) AS "PCOSTOPROMEDIO", ROUND(ROUND(SUM(DO.preciovprod*DO.cantprod)/SUM(DO.cantprod),2)-ROUND(SUM(DO.preciocprod*DO.cantprod)/SUM(DO.cantprod),2),2)   AS "UTILIDADXUNDPROM",ROUND((ROUND(SUM(DO.preciovprod*DO.cantprod)/SUM(DO.cantprod),2)-ROUND(SUM(DO.preciocprod*DO.cantprod)/SUM(DO.cantprod),2))*ROUND(SUM(DO.cantprod),2),2) AS "UTILTOTALPROM" FROM PRODUCTOS P INNER JOIN DETAORDEN DO ON P.idprod=DO.idprod INNER JOIN ORDEN O ON DO.idord=O.idord WHERE O.fechahoraord BETWEEN "$fechai" AND "$fechaf" GROUP BY P.idprod  ORDER BY SUM(DO.cantprod) DESC ;');
    return res.isNotEmpty
        ? res.map((e) => Reporteprodmasvendido.fromJson(e)).toList()
        : [];
  }
}
