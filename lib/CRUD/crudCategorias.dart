import 'package:firebase_orders_flutter/database/db_dbprovider.dart';
import '../models/modelCategorias.dart';

class DbCrudCategorias {
  static final DbCrudCategorias dbp = DbCrudCategorias._();
  DbCrudCategorias._();

  Future<int> nuevaCategoria(Categorias categorias) async {
    final db = await DBProvider.db.getdatabase();
    var res = 0;
    try {
      res = await db.insert('CATEGORIAS', categorias.toJson());
      return res;
    } catch (e) {
      return res;
    }
  }

  Future<int> actualizarCategorias(int cod, String nombre) async {
    final db = await DBProvider.db.getdatabase();
    var res = 0;
    try {
      res = await db.rawUpdate(
          '''UPDATE CATEGORIAS SET nombCateg=? where idcateg=? ''',
          [nombre, cod]);
      return res;
    } catch (e) {
      return res;
    }
  }

  Future<List<Categorias>> getCategorias(String busqueda) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.query('CATEGORIAS',
        where: 'nombCateg like ?', whereArgs: [busqueda.toString()]);
    return res.isNotEmpty
        ? res.map((e) => Categorias.fromJson(e)).toList()
        : [];
  }
}
