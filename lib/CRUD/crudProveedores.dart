import 'package:firebase_orders_flutter/models/modelProveedores.dart';
import '../database/db_dbprovider.dart';

class DbCrudProveedores {
  static final DbCrudProveedores dbp = DbCrudProveedores._();
  DbCrudProveedores._();

  Future<int> nuevoProveedor(Proveedores provee) async {
    final db = await DBProvider.db.getdatabase();
    var res = 0;
    try {
      res = await db.insert('PROVEEDORES', provee.toJson());
      return res;
    } catch (e) {
      return res;
    }
  }

  Future<int> actualizarProveedor(
      int cod, String nombre, String ruc, String dir, String cel) async {
    final db = await DBProvider.db.getdatabase();
    var res = 0;
    try {
      res = await db.rawUpdate(
          '''UPDATE PROVEEDORES SET nombprovee=?,rucprovee=?,dirprovee=?,celprovee=? where idprovee=? ''',
          [nombre, ruc, dir, cel, cod]);
      return res;
    } catch (e) {
      return res;
    }
  }

  Future<List<Proveedores>> getProveedores(String busqueda) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.query('PROVEEDORES',
        where: 'nombprovee like ?', whereArgs: [busqueda.toString()]);
    return res.isNotEmpty
        ? res.map((e) => Proveedores.fromJson(e)).toList()
        : [];
  }
}
