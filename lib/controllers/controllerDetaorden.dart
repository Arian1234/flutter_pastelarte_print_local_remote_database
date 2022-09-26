import 'dart:developer';
import 'package:flutter/material.dart';
import '../CRUD/crudDetaorden.dart';
import '../models/modelDetaOrden.dart';

class ProviderDetaorden extends ChangeNotifier {
  List<Detaorden> prod = [];

  AgregarDetaorden(int idor, String produ, double precio, double preciov,
      double cant) async {
    final model = Detaorden(
        idord: idor,
        nombprod: produ,
        preciocprod: precio,
        preciovprod: preciov,
        cantprod: cant);
    final id = await DbCrudDetaorden.dbp.NuevoDetaorden(model);
    model.iddetaord = id;
    prod.add(model);
    log(id.toString());
    //  print("AQUI : " + prod[0].toString());
    notifyListeners();
  }

  // ActualizarCategoria(int cod, String categ) async {
  //   await DbCrudCategorias.dbp.ActualizarCategorias(cod, categ);
  //   notifyListeners();
  // }

  // ObtenerCategoria(String busqueda) async {
  //   log('buscando');
  //   final model = await DbCrudCategorias.dbp.GetCategorias(busqueda.toString());
  //   prod = [...model];
  //   for (var i = 0; i < prod.length; i++) {
  //     log(prod[i].nombCateg.toString() + " - " + prod[i].idcateg.toString());
  //   }
  //   notifyListeners();
  // }

  // ObtenerProductosxBarra(String cod) async {
  //   final model = await DbCrudCategorias.dbp.GetProductosxBarra(cod.toString());
  //   prod = [...model];
  //   notifyListeners();
  // }
}
