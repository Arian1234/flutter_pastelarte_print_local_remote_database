import 'package:firebase_orders_flutter/models/modelCompras.dart';
import '../database/db_dbprovider.dart';
import '../models/modelOrdenes.dart';

class DbCrudCompras {
  static final DbCrudCompras dbp = DbCrudCompras._();
  DbCrudCompras._();
  Future<int> NuevaCompra(Compras compras) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.insert('compras', compras.toJson());
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

  Future<List<Compras>> GetCompras(String busqueda) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.query('Compras',
        where: 'nombprovee like ?', whereArgs: [busqueda.toString()]);
    return res.isNotEmpty ? res.map((e) => Compras.fromJson(e)).toList() : [];
  }
}
