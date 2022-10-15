// To parse this JSON data, do
//
//     final reporteprodporcenutil = reporteprodporcenutilFromJson(jsonString);

import 'dart:convert';

Reporteprodporcenutil reporteprodporcenutilFromJson(String str) =>
    Reporteprodporcenutil.fromJson(json.decode(str));

String reporteprodporcenutilToJson(Reporteprodporcenutil data) =>
    json.encode(data.toJson());

class Reporteprodporcenutil {
  Reporteprodporcenutil({
    this.cod,
    this.prod,
    this.vent,
    this.cost,
    this.porc,
  });

  int? cod;
  String? prod;
  double? vent;
  double? cost;
  double? porc;

  factory Reporteprodporcenutil.fromJson(Map<String, dynamic> json) =>
      Reporteprodporcenutil(
        cod: json["COD"],
        prod: json["PROD"],
        vent: json["VENT"].toDouble(),
        cost: json["COST"].toDouble(),
        porc: json["PORC"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "COD": cod,
        "PROD": prod,
        "VENT": vent,
        "COST": cost,
        "PORC": porc,
      };
}
