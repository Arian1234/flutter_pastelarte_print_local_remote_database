// To parse this JSON data, do
//
//     final reporteprodmasvendido = reporteprodmasvendidoFromJson(jsonString);

import 'dart:convert';

Reporteprodmasvendido reporteprodmasvendidoFromJson(String str) =>
    Reporteprodmasvendido.fromJson(json.decode(str));

String reporteprodmasvendidoToJson(Reporteprodmasvendido data) =>
    json.encode(data.toJson());

class Reporteprodmasvendido {
  Reporteprodmasvendido({
    this.cod,
    this.prod,
    this.cant,
    this.pventapromedio,
    this.pcostopromedio,
    this.utilidadxundprom,
    this.utiltotalprom,
  });

  int? cod;
  String? prod;
  double? cant;
  double? pventapromedio;
  double? pcostopromedio;
  double? utilidadxundprom;
  double? utiltotalprom;

  factory Reporteprodmasvendido.fromJson(Map<String, dynamic> json) =>
      Reporteprodmasvendido(
        cod: json["COD"],
        prod: json["PROD"],
        cant: json["CANT"].toDouble(),
        pventapromedio: json["PVENTAPROMEDIO"].toDouble(),
        pcostopromedio: json["PCOSTOPROMEDIO"].toDouble(),
        utilidadxundprom: json["UTILIDADXUNDPROM"].toDouble(),
        utiltotalprom: json["UTILTOTALPROM"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "COD": cod,
        "PROD": prod,
        "CANT": cant,
        "PVENTAPROMEDIO": pventapromedio,
        "PCOSTOPROMEDIO": pcostopromedio,
        "UTILIDADXUNDPROM": utilidadxundprom,
        "UTILTOTALPROM": utiltotalprom,
      };
}
