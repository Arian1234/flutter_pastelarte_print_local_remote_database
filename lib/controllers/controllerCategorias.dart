import 'package:firebase_orders_flutter/database/db_dbprovider.dart';
import 'package:flutter/material.dart';
import '../CRUD/crudCategorias.dart';
import '../models/modelCategorias.dart';

class ProviderCategorias extends ChangeNotifier {
  List<Categorias> cat = [];

  Future<int> agregarCategoria(String categ) async {
    final model = Categorias(nombCateg: categ);
    final id = await DbCrudCategorias.dbp.nuevaCategoria(model);
    if (id != 0) {
      model.idcateg = id;
      cat.add(model);
      notifyListeners();
      return 1;
    } else {
      return 0;
    }
  }

  Future<int> actualizarCategoria(int cod, String categ) async {
    final model = Categorias(idcateg: cod, nombCateg: categ);
    final est = await DbCrudCategorias.dbp.actualizarCategorias(cod, categ);
    if (est != 0) {
      int index = cat.indexWhere((element) => element.idcateg == cod);
      cat.removeAt(index);
      cat.insert(index, model);
      notifyListeners();
      return 1;
    } else {
      return 0;
    }
  }

  obtenerCategoria(String busqueda) async {
    final model = await DbCrudCategorias.dbp.getCategorias(busqueda.toString());
    cat = [...model];
    notifyListeners();
  }

  static Future<List<Map<String, dynamic>>>
      obtenerCategoriaDropDownButton() async {
    final db = await DBProvider.db.getdatabase();
    // notifyListeners();
    return await db.rawQuery("SELECT * FROM CATEGORIAS");
  }

  Future<List<String>> getFieldDataAsString() async {
    final db = await DBProvider.db.getdatabase();
    var results = await db.rawQuery('SELECT nombCateg from categorias');
    return results.map((Map<String, dynamic> row) {
      return row["nombCateg"] as String;
    }).toList();
  }
}
