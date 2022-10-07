// To parse this JSON data, do
//
//     final reporteventa = reporteventaFromJson(jsonString);

import 'dart:convert';

Reporteventa reporteventaFromJson(String str) =>
    Reporteventa.fromJson(json.decode(str));

String reporteventaToJson(Reporteventa data) => json.encode(data.toJson());

class Reporteventa {
  Reporteventa({
    this.fecha,
    this.cod,
    this.orden,
    this.cliente,
    this.total,
    this.ganancia,
  });

  String? fecha;
  int? cod;
  String? orden;
  String? cliente;
  double? total;
  double? ganancia;

  factory Reporteventa.fromJson(Map<String, dynamic> json) => Reporteventa(
        fecha: json["FECHA"],
        cod: json["COD"],
        orden: json["ORDEN"],
        cliente: json["CLIENTE"],
        total: json["TOTAL"].toDouble(),
        ganancia: json["GANANCIA"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "FECHA": fecha,
        "COD": cod,
        "ORDEN": orden,
        "CLIENTE": cliente,
        "TOTAL": total,
        "GANANCIA": ganancia,
      };
}
