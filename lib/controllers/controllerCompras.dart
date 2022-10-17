import 'dart:developer';

import 'package:firebase_orders_flutter/CRUD/crudCompras.dart';
import 'package:firebase_orders_flutter/models/modelCompras.dart';
import 'package:flutter/material.dart';
import '../models/modelOrdenes.dart';

class ProviderCompras extends ChangeNotifier {
  List<Compras> comp = [];

  Future<int> AgregarCompra(
      String nroserie,
      int idprovee,
      String fecharegist,
      String fechadocu,
      double total,
      double amortizo,
      String anota,
      int esta) async {
    final model = Compras(
        nrodocumento: nroserie,
        idprovee: idprovee,
        fecharegistrocomp: fecharegist,
        fechadoc: fechadocu,
        totalcomp: total,
        amortizocomp: amortizo,
        anotacomp: anota,
        estcomp: esta);

    final id = await DbCrudCompras.dbp.NuevaCompra(model);
    model.idcomp = id;
    comp.add(model);
    //  print("AQUI : " + prod[0].toString());
    notifyListeners();
    log("$id id es aqui");
    return id;
  }

  ActualizarCompra(Orden orden) async {
    await DbCrudCompras.dbp.ActualizarOrden(orden);
    notifyListeners();
  }

  ObtenerCompra(String busqueda) async {
    log('***buscando***');
    final model = await DbCrudCompras.dbp.GetCompras(busqueda.toString());
    comp = [...model];
    for (var i = 0; i < comp.length; i++) {
      log("${comp[i].idprovee} - ${comp[i].idcomp} - ${comp[i].nrodocumento}");
    }
    notifyListeners();
  }

  // ObtenerProductosxBarra(String cod) async {
  //   final model = await DbCrudCategorias.dbp.GetProductosxBarra(cod.toString());
  //   prod = [...model];
  //   notifyListeners();
  // }
}
