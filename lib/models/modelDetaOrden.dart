// To parse this JSON data, do
//
//     final detaorden = detaordenFromJson(jsonString);

import 'dart:convert';

Detaorden detaordenFromJson(String str) => Detaorden.fromJson(json.decode(str));

String detaordenToJson(Detaorden data) => json.encode(data.toJson());

class Detaorden {
  Detaorden({
    this.iddetaord,
    this.idord,
    this.idprod,
    this.preciocprod,
    this.preciovprod,
    this.cantprod,
  });

  int? iddetaord;
  int? idord;
  int? idprod;
  double? preciocprod;
  double? preciovprod;
  double? cantprod;

  factory Detaorden.fromJson(Map<String, dynamic> json) => Detaorden(
        iddetaord: json["iddetaord"],
        idord: json["idord"],
        idprod: json["idprod"],
        preciocprod: json["preciocprod"].toDouble(),
        preciovprod: json["preciovprod"].toDouble(),
        cantprod: json["cantprod"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "iddetaord": iddetaord,
        "idord": idord,
        "idprod": idprod,
        "preciocprod": preciocprod,
        "preciovprod": preciovprod,
        "cantprod": cantprod,
      };
}
