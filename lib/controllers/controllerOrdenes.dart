import 'dart:developer';

import 'package:flutter/material.dart';

import '../CRUD/crudOrden.dart';
import '../models/modelOrdenes.dart';

class ProviderOrdenes extends ChangeNotifier {
  List<Orden> prod = [];

  Future<int> AgregarOrden(
      String uni,
      String nombcli,
      String fechaord,
      String fechadesp,
      String delivery,
      double total,
      double amortizo,
      double margen,
      String anota,
      int esta) async {
    final model = Orden(
        unix: uni,
        nombclie: nombcli,
        fechahoraord: fechaord,
        fechahoradesp: fechadesp,
        deliveryord: delivery,
        totalord: total,
        amortizoord: amortizo,
        margenord: margen,
        anotacord: anota,
        estord: esta);

    final id = await DbCrudOrdenes.dbp.NuevaOrden(model);
    model.idord = id;
    prod.add(model);
    //  print("AQUI : " + prod[0].toString());
    notifyListeners();
    log("$id id es aqui");
    return id;
  }

  ActualizarOrden(Orden orden) async {
    await DbCrudOrdenes.dbp.ActualizarOrden(orden);
    notifyListeners();
  }

  ObtenerOrden(String busqueda) async {
    log('***buscando***');
    final model = await DbCrudOrdenes.dbp.GetOrden(busqueda.toString());
    prod = [...model];
    for (var i = 0; i < prod.length; i++) {
      log("${prod[i].nombclie} - ${prod[i].idord} - ${prod[i].unix}");
    }
    notifyListeners();
  }

  // ObtenerProductosxBarra(String cod) async {
  //   final model = await DbCrudCategorias.dbp.GetProductosxBarra(cod.toString());
  //   prod = [...model];
  //   notifyListeners();
  // }
}
