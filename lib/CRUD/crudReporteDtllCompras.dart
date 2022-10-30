import '../database/db_dbprovider.dart';
import '../models/modelDtlleCompra.dart';

class DbCrudReporteDetalleCompras {
  static final DbCrudReporteDetalleCompras dbp =
      DbCrudReporteDetalleCompras._();
  DbCrudReporteDetalleCompras._();

  Future<List<Reportedtllecompras>> GetDetalleReporteCompras(String id) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.rawQuery(
        'SELECT DC.iddetacomp AS "COD",P.nombprod AS "PROD",DC.preciooldcomp AS "PRECIOANT",DC.preciocprod AS "PRECIO",DC.preciovprod AS "PRECVENT",DC.cantprod AS "CANT" FROM DETACOMPRA DC INNER JOIN PRODUCTOS P ON DC.idprod=P.idprod WHERE DC.idcomp="$id";');
    return res.isNotEmpty
        ? res.map((e) => Reportedtllecompras.fromJson(e)).toList()
        : [];
  }
}
