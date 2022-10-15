import 'package:firebase_orders_flutter/models/modelDetalleReporteVenta.dart';
import '../database/db_dbprovider.dart';

class DbCrudDetalleReporteVentas {
  static final DbCrudDetalleReporteVentas dbp = DbCrudDetalleReporteVentas._();
  DbCrudDetalleReporteVentas._();

  Future<List<Detallereporteventa>> GetDetalleReporteVenta(String id) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.rawQuery(
        'SELECT P.idprod AS "COD",P.nombprod AS"PROD",DO.preciovprod AS "PUBL",DO.preciocprod AS "COST",round(DO.preciovprod-DO.preciocprod,2) AS "UTILD",DO.cantprod AS "CANT" FROM DETAORDEN DO INNER JOIN PRODUCTOS P ON DO.idprod=P.idprod WHERE DO.idord="$id";');
    return res.isNotEmpty
        ? res.map((e) => Detallereporteventa.fromJson(e)).toList()
        : [];
  }
}
