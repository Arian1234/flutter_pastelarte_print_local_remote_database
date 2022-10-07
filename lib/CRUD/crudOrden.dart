import '../database/db_dbprovider.dart';
import '../models/modelOrdenes.dart';

class DbCrudOrdenes {
  static final DbCrudOrdenes dbp = DbCrudOrdenes._();
  DbCrudOrdenes._();
  Future<int> NuevaOrden(Orden orden) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.insert('Orden', orden.toJson());
    return res;
  }

  Future<int> ActualizarOrden(Orden orden) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.rawUpdate('''UPDATE ORDEN SET 
        nombclie=?, 
        fechahoraord=?,
        fechahoradesp=?,
        deliveryord=?,
        totalord=?,
        amortizoord=?,
        margenord=?,
        anotacord=? where idord=?
         ''', [
      orden.idclie,
      orden.fechahoraord,
      orden.fechahoradesp,
      orden.deliveryord,
      orden.totalord,
      orden.amortizoord,
      orden.margenord,
      orden.anotacord,
      orden.idord
    ]);
    return res;
  }

  Future<List<Orden>> GetOrden(String busqueda) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.query('ORDEN',
        where: 'nombclie like ?', whereArgs: [busqueda.toString()]);
    return res.isNotEmpty ? res.map((e) => Orden.fromJson(e)).toList() : [];
  }

  // Future<List<Categorias>> GetProductosxBarra(String cod) async {
  //   final db = await DbProvider.db.getdatabase();
  //   final res = await db.query('PRODUCTOS',
  //       where: 'codigo=?', whereArgs: [cod], limit: 1);
  //   return res.isNotEmpty
  //       ? res.map((e) => Categorias.fromJson(e)).toList()
  //       : [];
  // }
}
