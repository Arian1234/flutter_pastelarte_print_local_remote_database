import 'dart:developer';
import 'package:flutter/material.dart';
import '../CRUD/crudClientes.dart';
import '../models/modelClientes.dart';

class ProviderClientes extends ChangeNotifier {
  List<Clientes> clie = [];

  Future<int> agregarCliente(
      String nomb, String doc, String dir, String cel) async {
    final model = Clientes(
      nombclie: nomb,
      docclie: doc,
      dirclie: dir,
      celclie: cel,
    );

    final id = await DbCrudClientes.dbp.nuevoCliente(model);
    if (id != 0) {
      model.idclie = id;
      clie.add(model);
      notifyListeners();
      return 1;
    } else {
      return 0;
    }
  }

  Future<int> actualizarCLientes(
      int cod, String nomb, String doc, String dir, String cel) async {
    final model = Clientes(
        idclie: cod, nombclie: nomb, docclie: doc, dirclie: dir, celclie: cel);
    int est =
        await DbCrudClientes.dbp.actualizarClientes(cod, nomb, doc, dir, cel);
    if (est != 0) {
      int index = clie.indexWhere((element) => element.idclie == cod);
      log(index.toString());
      clie.removeAt(index);
      clie.insert(index, model);
      notifyListeners();
      return 1;
    } else {
      return 0;
    }
  }

  obtenerClientes(String busqueda) async {
    log('buscando');
    final model = await DbCrudClientes.dbp.getClientes(busqueda.toString());
    clie = [...model];
    notifyListeners();
  }
}
