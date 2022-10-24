// To parse this JSON data, do
//
//     final reportedtllecompras = reportedtllecomprasFromJson(jsonString);

import 'dart:convert';

Reportedtllecompras reportedtllecomprasFromJson(String str) =>
    Reportedtllecompras.fromJson(json.decode(str));

String reportedtllecomprasToJson(Reportedtllecompras data) =>
    json.encode(data.toJson());

class Reportedtllecompras {
  Reportedtllecompras({
    this.cod,
    this.prod,
    this.precioant,
    this.precio,
    this.precvent,
    this.cant,
  });

  int? cod;
  String? prod;
  double? precioant;
  double? precio;
  double? precvent;
  double? cant;

  factory Reportedtllecompras.fromJson(Map<String, dynamic> json) =>
      Reportedtllecompras(
        cod: json["COD"],
        prod: json["PROD"],
        precioant: json["PRECIOANT"].toDouble(),
        precio: json["PRECIO"].toDouble(),
        precvent: json["PRECVENT"].toDouble(),
        cant: json["CANT"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "COD": cod,
        "PROD": prod,
        "PRECIOANT": precioant,
        "PRECIO": precio,
        "PRECVENT": precvent,
        "CANT": cant,
      };
}
