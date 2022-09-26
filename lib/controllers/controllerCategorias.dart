import 'dart:developer';
import 'package:firebase_orders_flutter/database/db_dbprovider.dart';
import 'package:flutter/material.dart';
import '../CRUD/crudCategorias.dart';
import '../models/modelCategorias.dart';

class ProviderCategorias extends ChangeNotifier {
  List<Categorias> cat = [];

  AgregarCategoria(String categ) async {
    final model = Categorias(nombCateg: categ);
    final id = await DbCrudCategorias.dbp.NuevaCategoria(model);
    model.idcateg = id;
    cat.add(model);
    //  print("AQUI : " + prod[0].toString());
    notifyListeners();
  }

  ActualizarCategoria(int cod, String categ) async {
    await DbCrudCategorias.dbp.ActualizarCategorias(cod, categ);
    notifyListeners();
  }

  ObtenerCategoria(String busqueda) async {
    log('buscando');
    final model = await DbCrudCategorias.dbp.GetCategorias(busqueda.toString());
    cat = [...model];
    for (var i = 0; i < cat.length; i++) {
      log(cat[i].nombCateg.toString() + " - " + cat[i].idcateg.toString());
    }
    notifyListeners();
  }

  Future<List<String>> getFieldDataAsString() async {
    final db = await DBProvider.db.getdatabase();

    var results = await db.rawQuery('SELECT nombCateg from categorias');

    return results.map((Map<String, dynamic> row) {
      return row["nombCateg"] as String;
    }).toList();
  }

  // ObtenerProductosxBarra(String cod) async {
  //   final model = await DbCrudCategorias.dbp.GetProductosxBarra(cod.toString());
  //   prod = [...model];
  //   notifyListeners();
  // }
}