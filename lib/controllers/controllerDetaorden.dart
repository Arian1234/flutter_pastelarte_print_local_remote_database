import 'dart:developer';
import 'package:firebase_orders_flutter/models/modelProductos.dart';
import 'package:flutter/material.dart';
import '../CRUD/crudDetaorden.dart';
import '../models/modelDetaOrden.dart';

class ProviderDetaorden extends ChangeNotifier {
  List<Detaorden> prod = [];
  List<Productos> productos = [];

  AgregarDetaorden(
      int idor, int idpro, double precio, double preciov, double cant) async {
    final model = Detaorden(
        idord: idor,
        idprod: idpro,
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

}
