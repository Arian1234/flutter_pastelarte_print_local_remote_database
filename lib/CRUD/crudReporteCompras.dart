import 'package:firebase_orders_flutter/models/modelReporteCompras.dart';
import '../database/db_dbprovider.dart';

class DbCrudReporteCompras {
  static final DbCrudReporteCompras dbp = DbCrudReporteCompras._();
  DbCrudReporteCompras._();

  Future<List<Reportecompras>> GetReporteCompras(
      String fechai, String fechaf) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.rawQuery(
        'SELECT C.idcomp as "COD",C.nrodocumento as "DOC",P.nombprovee AS "PROVEEDOR",C.fecharegistrocomp AS "REGISTRADO",C.fechadoc AS "FECHAEMISIONDOC",C.totalcomp AS "TOTAL",C.amortizocomp AS "AMORTIZADO",C.anotacomp AS "NOTA",C.estcomp AS "ESTADO" FROM COMPRAS C INNER JOIN PROVEEDORES P ON C.idprovee=P.idprovee WHERE C.fecharegistrocomp BETWEEN "$fechai" AND "$fechaf";');
    return res.isNotEmpty
        ? res.map((e) => Reportecompras.fromJson(e)).toList()
        : [];
  }
}
