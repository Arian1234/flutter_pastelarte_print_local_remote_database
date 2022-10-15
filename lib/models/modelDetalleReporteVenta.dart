// To parse this JSON data, do
//
//     final detallereporteventa = detallereporteventaFromJson(jsonString);

import 'dart:convert';

Detallereporteventa detallereporteventaFromJson(String str) =>
    Detallereporteventa.fromJson(json.decode(str));

String detallereporteventaToJson(Detallereporteventa data) =>
    json.encode(data.toJson());

class Detallereporteventa {
  Detallereporteventa({
    this.cod,
    this.prod,
    this.publ,
    this.cost,
    this.utild,
    this.cant,
  });

  int? cod;
  String? prod;
  double? publ;
  double? cost;
  double? utild;
  int? cant;

  factory Detallereporteventa.fromJson(Map<String, dynamic> json) =>
      Detallereporteventa(
        cod: json["COD"],
        prod: json["PROD"],
        publ: json["PUBL"].toDouble(),
        cost: json["COST"].toDouble(),
        utild: json["UTILD"].toDouble(),
        cant: json["CANT"],
      );

  Map<String, dynamic> toJson() => {
        "COD": cod,
        "PROD": prod,
        "PUBL": publ,
        "COST": cost,
        "UTILD": utild,
        "CANT": cant,
      };
}
