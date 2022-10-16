import 'package:firebase_orders_flutter/models/modelProveedores.dart';
import '../database/db_dbprovider.dart';

class DbCrudProveedores {
  static final DbCrudProveedores dbp = DbCrudProveedores._();
  DbCrudProveedores._();

  Future<int> NuevoProveedor(Proveedores provee) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.insert('PROVEEDORES', provee.toJson());
    return res;
  }

  Future<int> ActualizarProveedor(
      int cod, String nombre, String ruc, String dir, String cel) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.rawUpdate(
        '''UPDATE PROVEEDORES SET nombprovee=?,rucprovee=?,dirprovee=?,celprovee=? where idprovee=? ''',
        [nombre, ruc, dir, cel, cod]);
    return res;
  }

  Future<List<Proveedores>> GetProveedores(String busqueda) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.query('PROVEEDORES',
        where: 'nombprovee like ?', whereArgs: [busqueda.toString()]);
    return res.isNotEmpty
        ? res.map((e) => Proveedores.fromJson(e)).toList()
        : [];
  }
}
