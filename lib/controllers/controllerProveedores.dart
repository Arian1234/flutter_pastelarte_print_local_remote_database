import 'dart:developer';
import 'package:firebase_orders_flutter/CRUD/crudProveedores.dart';
import 'package:firebase_orders_flutter/models/modelProveedores.dart';
import 'package:flutter/material.dart';
import '../CRUD/crudClientes.dart';
import '../database/db_dbprovider.dart';
import '../models/modelClientes.dart';

class ProviderProveedores extends ChangeNotifier {
  List<Proveedores> proveed = [];

  AgregarProveedor(String nomb, String ruc, String dir, String cel) async {
    final model = Proveedores(
      nombprovee: nomb,
      rucprovee: ruc,
      dirprovee: dir,
      celprovee: cel,
    );
    final id = await DbCrudProveedores.dbp.NuevoProveedor(model);
    model.idprovee = id;
    proveed.add(model);
    notifyListeners();
  }

  ActualizarProveedor(
      int cod, String nomb, String ruc, String dir, String cel) async {
    final model = Proveedores(
        idprovee: cod,
        nombprovee: nomb,
        rucprovee: ruc,
        dirprovee: dir,
        celprovee: cel);
    await DbCrudProveedores.dbp.ActualizarProveedor(cod, nomb, ruc, dir, cel);
    int index = proveed.indexWhere((element) => element.idprovee == cod);
    log(index.toString());
    proveed.removeAt(index);
    proveed.insert(index, model);
    notifyListeners();
  }

  static Future<List<Map<String, dynamic>>>
      obtenerProveedorDropDownButton() async {
    log('buscando');
    final db = await DBProvider.db.getdatabase();
    // notifyListeners();
    return await db.rawQuery("SELECT * FROM PROVEEDORES");
  }

  ObtenerProveedores(String busqueda) async {
    log('buscando');
    final model =
        await DbCrudProveedores.dbp.GetProveedores(busqueda.toString());
    proveed = [...model];
    for (var i = 0; i < proveed.length; i++) {
      log('${proveed[i].nombprovee} - ${proveed[i].idprovee}${proveed[i].rucprovee}${proveed[i].dirprovee}${proveed[i].celprovee}');
      print('object');
    }
    notifyListeners();
  }

  // ObtenerProductosxBarra(String cod) async {
  //   final model = await DbCrudCategorias.dbp.GetProductosxBarra(cod.toString());
  //   prod = [...model];
  //   notifyListeners();
  // }
}
