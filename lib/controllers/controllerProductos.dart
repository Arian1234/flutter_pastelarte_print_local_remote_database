import 'dart:developer';
import 'package:flutter/material.dart';
import '../CRUD/crudProductos.dart';
import '../models/modelProductos.dart';

class ProviderProductos extends ChangeNotifier {
  List<Productos> prod = [];

  Future<int> agregarProducto(
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

    final id = await DbCrudProductos.dbp.nuevoProducto(model);
    if (id != 0) {
      model.idprod = id;
      prod.add(model);
      notifyListeners();
      return 1;
    } else {
      return 0;
    }
  }

  Future<int> actualizarProducto(
      int cod,
      String nombre,
      String descrip,
      String categ,
      String img,
      double cant,
      double min,
      double costo,
      double venta,
      int desrec) async {
    final model = Productos(
        idprod: cod,
        nombprod: nombre,
        descripprod: descrip,
        categprod: categ,
        imgprod: img,
        cantprod: cant,
        minstock: min,
        precioprod: costo,
        ventaprod: venta,
        despachorecep: desrec);
    final est = await DbCrudProductos.dbp.actualizarProductos(
        cod, nombre, descrip, categ, img, cant, min, costo, venta, desrec);
    if (est != 0) {
      int index = prod.indexWhere((element) => element.idprod == cod);
      log(index.toString());
      prod.removeAt(index);
      prod.insert(index, model);
      notifyListeners();
      return 1;
    } else {
      return 0;
    }
  }

  obtenerProducto(String busqueda) async {
    log('buscando');
    final model = await DbCrudProductos.dbp.getProductos(busqueda.toString());
    prod = [...model];
    notifyListeners();
  }
}
