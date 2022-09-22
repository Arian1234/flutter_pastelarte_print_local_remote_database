import '../database/db_dbprovider.dart';
import '../models/modelClientes.dart';

class DbCrudClientes {
  static final DbCrudClientes dbp = DbCrudClientes._();
  DbCrudClientes._();
  Future<int> NuevoCliente(Clientes clientes) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.insert('CLIENTES', clientes.toJson());
    return res;
  }

  Future<int> ActualizarClientes(
      int cod, String nombre, String doc, String dir, String cel) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.rawUpdate(
        '''UPDATE CLIENTES SET nombclie=?,docclie=?,dirclie=?,celclie=? where idclie=? ''',
        [nombre, doc, dir, cel, cod]);
    return res;
  }

  Future<List<Clientes>> GetClientes(String busqueda) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.query('CLIENTES',
        where: 'nombclie like ?', whereArgs: [busqueda.toString()]);
    return res.isNotEmpty ? res.map((e) => Clientes.fromJson(e)).toList() : [];
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
