import 'dart:developer';
import 'package:flutter/material.dart';
import '../CRUD/crudProductos.dart';
import '../models/modelProductos.dart';

class ProviderProductos extends ChangeNotifier {
  List<Productos> prod = [];

  AgregarProducto(
      String nomb,
      String desc,
      String categ,
      String img,
      double cant,
      double mini,
      double prec,
      double vent,
      int desp,
      int est) async {
    final model = Productos(
        nombprod: nomb,
        descripprod: desc,
        categprod: categ,
        imgprod: img,
        cantprod: cant,
        minstock: mini,
        precioprod: prec,
        ventaprod: vent,
        despachorecep: desp,
        estadoprod: est);
    final id = await DbCrudProductos.dbp.NuevoProducto(model);
    model.idprod = id;
    prod.add(model);
    //  print("AQUI : " + prod[0].toString());
    notifyListeners();
  }

  ActualizarProducto(int cod, String nomb, String desc, String img, double cant,
      double cost, double vent, int est) async {
    await DbCrudProductos.dbp
        .ActualizarProductos(cod, nomb, desc, img, cant, cost, vent, est);
    notifyListeners();
  }

  ObtenerProducto(String busqueda) async {
    log('buscando');
    final model = await DbCrudProductos.dbp.GetProductos(busqueda.toString());
    prod = [...model];
    for (var i = 0; i < prod.length; i++) {
      log(prod[i].nombprod.toString() +
          prod[i].descripprod.toString() +
          '-' +
          prod[i].imgprod.toString() +
          '-' +
          prod[i].idprod.toString() +
          '-' +
          prod[i].cantprod.toString() +
          '-' +
          prod[i].precioprod.toString() +
          '-' +
          prod[i].ventaprod.toString() +
          prod[i].estadoprod.toString());
    }
    notifyListeners();
  }

  // ObtenerProductosxBarra(String cod) async {
  //   final model = await DbCrudCategorias.dbp.GetProductosxBarra(cod.toString());
  //   prod = [...model];
  //   notifyListeners();
  // }
}
