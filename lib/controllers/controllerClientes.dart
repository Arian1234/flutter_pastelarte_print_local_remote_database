import 'dart:developer';
import 'package:flutter/material.dart';
import '../CRUD/crudClientes.dart';
import '../models/modelClientes.dart';


class ProviderClientes extends ChangeNotifier {
  List<Clientes> clie = [];

  AgregarCliente(String nomb, String doc, String dir, String cel) async {
    final model = Clientes(
      nombclie: nomb,
      docclie: doc,
      dirclie: dir,
      celclie: cel,
    );
    final id = await DbCrudClientes.dbp.NuevoCliente(model);
    model.idclie = id;
    clie.add(model);
    //  print("AQUI : " + prod[0].toString());
    notifyListeners();
  }

  ActualizarCLientes(
      int cod, String nomb, String doc, String dir, String cel) async {
    await DbCrudClientes.dbp.ActualizarClientes(cod, nomb, doc, dir, cel);
    notifyListeners();
  }

  ObtenerClientes(String busqueda) async {
    log('buscando');
    final model = await DbCrudClientes.dbp.GetClientes(busqueda.toString());
    clie = [...model];
    for (var i = 0; i < clie.length; i++) {
      log(clie[i].nombclie.toString() +
          ' - ' +
          clie[i].idclie.toString() +
          clie[i].docclie.toString() +
          clie[i].dirclie.toString() +
          clie[i].celclie.toString());
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
