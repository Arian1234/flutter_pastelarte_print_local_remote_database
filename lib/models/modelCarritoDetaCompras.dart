// To parse this JSON data, do
//
//     final carritodetacompras = carritodetacomprasFromJson(jsonString);

import 'dart:convert';

Carritodetacompras carritodetacomprasFromJson(String str) =>
    Carritodetacompras.fromJson(json.decode(str));

String carritodetacomprasToJson(Carritodetacompras data) =>
    json.encode(data.toJson());

class Carritodetacompras {
  Carritodetacompras({
    this.idprod,
    this.nombprod,
    this.preciooldprod,
    this.preciocprod,
    this.preciovprod,
    this.cantprod,
  });

  int? idprod;
  String? nombprod;
  double? preciooldprod;
  double? preciocprod;
  double? preciovprod;
  double? cantprod;

  factory Carritodetacompras.fromJson(Map<String, dynamic> json) =>
      Carritodetacompras(
        idprod: json["idprod"],
        nombprod: json["nombprod"],
        preciooldprod: json["preciooldprod"].toDouble(),
        preciocprod: json["preciocprod"].toDouble(),
        preciovprod: json["preciovprod"].toDouble(),
        cantprod: json["cantprod"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "idprod": idprod,
        "nombprod": nombprod,
        "preciooldprod": preciooldprod,
        "preciocprod": preciocprod,
        "preciovprod": preciovprod,
        "cantprod": cantprod,
      };
}
