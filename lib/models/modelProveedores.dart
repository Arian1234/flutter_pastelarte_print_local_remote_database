// To parse this JSON data, do
//
//     final proveedores = proveedoresFromJson(jsonString);

import 'dart:convert';

Proveedores proveedoresFromJson(String str) =>
    Proveedores.fromJson(json.decode(str));

String proveedoresToJson(Proveedores data) => json.encode(data.toJson());

class Proveedores {
  Proveedores({
    this.idprovee,
    this.nombprovee,
    this.rucprovee,
    this.dirprovee,
    this.celprovee,
  });

  int? idprovee;
  String? nombprovee;
  String? rucprovee;
  String? dirprovee;
  String? celprovee;

  factory Proveedores.fromJson(Map<String, dynamic> json) => Proveedores(
        idprovee: json["idprovee"],
        nombprovee: json["nombprovee"],
        rucprovee: json["rucprovee"],
        dirprovee: json["dirprovee"],
        celprovee: json["celprovee"],
      );

  Map<String, dynamic> toJson() => {
        "idprovee": idprovee,
        "nombprovee": nombprovee,
        "rucprovee": rucprovee,
        "dirprovee": dirprovee,
        "celprovee": celprovee,
      };
}
