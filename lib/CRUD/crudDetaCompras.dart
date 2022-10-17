import 'package:firebase_orders_flutter/database/db_dbprovider.dart';
import 'package:firebase_orders_flutter/models/modelDetaCompras.dart';

class DbCrudDetaCompras {
  static final DbCrudDetaCompras dbp = DbCrudDetaCompras._();
  DbCrudDetaCompras._();
  Future<int> NuevoDetaCompra(Detacompras detacompras) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.insert('DETACOMPRA', detacompras.toJson());
    return res;
  }

  // Future<int> ActualizarDetaorden(Detaorden detaorden) async {
  //   final db = await DbHelper.db.getdatabase();
  //   final res = await db.rawUpdate(
  //       '''UPDATE DETAORDEN SET
  //       nombCateg=? where idcateg=? ''',
  //       [nombre, cod]);
  //   return res;
  // }

  // Future<List<Detaorden>> GetDetaorden(String busqueda) async {
  //   final db = await DbHelper.db.getdatabase();
  //   final res = await db.query('CATEGORIAS',
  //       where: 'nombCateg like ?', whereArgs: [busqueda.toString()]);
  //   return res.isNotEmpty
  //       ? res.map((e) => Categorias.fromJson(e)).toList()
  //       : [];
  // }

  // Future<List<Categorias>> GetProductosxBarra(String cod) async {
  //   final db = await DbProvider.db.getdatabase();
  //   final res = await db.query('PRODUCTOS',
  //       where: 'codigo=?', whereArgs: [cod], limit: 1);
  //   return res.isNotEmpty
  //       ? res.map((e) => Categorias.fromJson(e)).toList()
  //       : [];
  // }
}
