// To parse this JSON data, do
//
//     final reportecompras = reportecomprasFromJson(jsonString);

import 'dart:convert';

Reportecompras reportecomprasFromJson(String str) =>
    Reportecompras.fromJson(json.decode(str));

String reportecomprasToJson(Reportecompras data) => json.encode(data.toJson());

class Reportecompras {
  Reportecompras({
    this.cod,
    this.doc,
    this.proveedor,
    this.registrado,
    this.fechaemisiondoc,
    this.total,
    this.amortizado,
    this.nota,
    this.estado,
  });

  int? cod;
  String? doc;
  String? proveedor;
  String? registrado;
  String? fechaemisiondoc;
  double? total;
  double? amortizado;
  String? nota;
  int? estado;

  factory Reportecompras.fromJson(Map<String, dynamic> json) => Reportecompras(
        cod: json["COD"],
        doc: json["DOC"],
        proveedor: json["PROVEEDOR"],
        registrado: json["REGISTRADO"],
        fechaemisiondoc: json["FECHAEMISIONDOC"],
        total: json["TOTAL"].toDouble(),
        amortizado: json["AMORTIZADO"].toDouble(),
        nota: json["NOTA"],
        estado: json["ESTADO"],
      );

  Map<String, dynamic> toJson() => {
        "COD": cod,
        "DOC": doc,
        "PROVEEDOR": proveedor,
        "REGISTRADO": registrado,
        "FECHAEMISIONDOC": fechaemisiondoc,
        "TOTAL": total,
        "AMORTIZADO": amortizado,
        "NOTA": nota,
        "ESTADO": estado,
      };
}
