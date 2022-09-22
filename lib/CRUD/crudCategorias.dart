

import 'package:firebase_orders_flutter/database/db_dbprovider.dart';

import '../models/modelCategorias.dart';

class DbCrudCategorias {
  static final DbCrudCategorias dbp = DbCrudCategorias._();
  DbCrudCategorias._();
  Future<int> NuevaCategoria(Categorias categorias) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.insert('CATEGORIAS', categorias.toJson());
    return res;
  }

  Future<int> ActualizarCategorias(int cod, String nombre) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.rawUpdate(
        '''UPDATE CATEGORIAS SET nombCateg=? where idcateg=? ''',
        [nombre, cod]);
    return res;
  }

  Future<List<Categorias>> GetCategorias(String busqueda) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.query('CATEGORIAS',
        where: 'nombCateg like ?', whereArgs: [busqueda.toString()]);
    return res.isNotEmpty
        ? res.map((e) => Categorias.fromJson(e)).toList()
        : [];
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
