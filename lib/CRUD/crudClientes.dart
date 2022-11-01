import '../database/db_dbprovider.dart';
import '../models/modelClientes.dart';

class DbCrudClientes {
  static final DbCrudClientes dbp = DbCrudClientes._();
  DbCrudClientes._();
  Future<int> nuevoCliente(Clientes clientes) async {
    final db = await DBProvider.db.getdatabase();
    var res = 0;
    try {
      res = await db.insert('CLIENTES', clientes.toJson());
      return res;
    } catch (e) {
      return res;
    }
  }

  Future<int> actualizarClientes(
      int cod, String nombre, String doc, String dir, String cel) async {
    final db = await DBProvider.db.getdatabase();
    var res = 0;
    try {
      res = await db.rawUpdate(
          '''UPDATE CLIENTES SET nombclie=?,docclie=?,dirclie=?,celclie=? where idclie=? ''',
          [nombre, doc, dir, cel, cod]);
      return res;
    } catch (e) {
      return res;
    }
  }

  Future<List<Clientes>> getClientes(String busqueda) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.query('CLIENTES',
        where: 'nombclie like ?', whereArgs: [busqueda.toString()]);
    return res.isNotEmpty ? res.map((e) => Clientes.fromJson(e)).toList() : [];
  }
}
