import 'dart:developer';
import 'package:firebase_orders_flutter/CRUD/crudProveedores.dart';
import 'package:firebase_orders_flutter/models/modelProveedores.dart';
import 'package:flutter/material.dart';
import '../database/db_dbprovider.dart';

class ProviderProveedores extends ChangeNotifier {
  List<Proveedores> proveed = [];

  Future<int> agregarProveedor(
      String nomb, String ruc, String dir, String cel) async {
    final model = Proveedores(
      nombprovee: nomb,
      rucprovee: ruc,
      dirprovee: dir,
      celprovee: cel,
    );
    final id = await DbCrudProveedores.dbp.nuevoProveedor(model);
    if (id != 0) {
      model.idprovee = id;
      proveed.add(model);
      notifyListeners();
      return 1;
    } else {
      return 0;
    }
  }

  Future<int> actualizarProveedor(
      int cod, String nomb, String ruc, String dir, String cel) async {
    final model = Proveedores(
        idprovee: cod,
        nombprovee: nomb,
        rucprovee: ruc,
        dirprovee: dir,
        celprovee: cel);
    final est = await DbCrudProveedores.dbp
        .actualizarProveedor(cod, nomb, ruc, dir, cel);
    if (est != 0) {
      int index = proveed.indexWhere((element) => element.idprovee == cod);
      log(index.toString());
      proveed.removeAt(index);
      proveed.insert(index, model);
      notifyListeners();
      return 1;
    } else {
      return 0;
    }
  }

  static Future<List<Map<String, dynamic>>>
      obtenerProveedorDropDownButton() async {
    log('buscando');
    final db = await DBProvider.db.getdatabase();
    return await db.rawQuery("SELECT * FROM PROVEEDORES");
  }

  obtenerProveedores(String busqueda) async {
    final model =
        await DbCrudProveedores.dbp.getProveedores(busqueda.toString());
    proveed = [...model];
    notifyListeners();
  }
}
