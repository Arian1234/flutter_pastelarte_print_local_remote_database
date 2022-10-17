// To parse this JSON data, do
//
//     final detacompras = detacomprasFromJson(jsonString);

import 'dart:convert';

Detacompras detacomprasFromJson(String str) =>
    Detacompras.fromJson(json.decode(str));

String detacomprasToJson(Detacompras data) => json.encode(data.toJson());

class Detacompras {
  Detacompras({
    this.iddetacomp,
    this.idcomp,
    this.idprod,
    this.preciooldcomp,
    this.preciocprod,
    this.preciovprod,
    this.cantprod,
  });

  int? iddetacomp;
  int? idcomp;
  int? idprod;
  double? preciooldcomp;
  double? preciocprod;
  double? preciovprod;
  double? cantprod;

  factory Detacompras.fromJson(Map<String, dynamic> json) => Detacompras(
        iddetacomp: json["iddetacomp"],
        idcomp: json["idcomp"],
        idprod: json["idprod"],
        preciooldcomp: json["preciooldcomp"].toDouble(),
        preciocprod: json["preciocprod"].toDouble(),
        preciovprod: json["preciovprod"].toDouble(),
        cantprod: json["cantprod"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "iddetacomp": iddetacomp,
        "idcomp": idcomp,
        "idprod": idprod,
        "preciooldcomp": preciooldcomp,
        "preciocprod": preciocprod,
        "preciovprod": preciovprod,
        "cantprod": cantprod,
      };
}
