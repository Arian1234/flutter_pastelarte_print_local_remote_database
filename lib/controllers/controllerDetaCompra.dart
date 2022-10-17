import 'dart:developer';
import 'package:firebase_orders_flutter/CRUD/crudDetaCompras.dart';
import 'package:firebase_orders_flutter/models/modelDetaCompras.dart';
import 'package:flutter/material.dart';

class ProviderDetaCompra extends ChangeNotifier {
  List<Detacompras> dtcom = [];

  AgregarDetaCompra(int idcompra, int idpro, double precioolds, double precio,
      double preciov, double cant) async {
    final model = Detacompras(
        idcomp: idcompra,
        idprod: idpro,
        preciooldcomp: precioolds,
        preciocprod: precio,
        preciovprod: preciov,
        cantprod: cant);

    final id = await DbCrudDetaCompras.dbp.NuevoDetaCompra(model);
    model.iddetacomp = id;
    dtcom.add(model);
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
