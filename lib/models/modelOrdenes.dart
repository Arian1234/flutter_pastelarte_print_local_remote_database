// To parse this JSON data, do
//
//     final orden = ordenFromJson(jsonString);

import 'dart:convert';

Orden ordenFromJson(String str) => Orden.fromJson(json.decode(str));

String ordenToJson(Orden data) => json.encode(data.toJson());

class Orden {
  Orden({
    this.idord,
    this.idclie,
    this.fechahoraord,
    this.fechahoradesp,
    this.deliveryord,
    this.totalord,
    this.amortizoord,
    this.margenord,
    this.anotacord,
    this.estord,
  });

  int? idord;
  int? idclie;
  String? fechahoraord;
  String? fechahoradesp;
  String? deliveryord;
  double? totalord;
  double? amortizoord;
  double? margenord;
  String? anotacord;
  String? estord;

  factory Orden.fromJson(Map<String, dynamic> json) => Orden(
        idord: json["idord"],
        idclie: json["idclie"],
        fechahoraord: json["fechahoraord"],
        fechahoradesp: json["fechahoradesp"],
        deliveryord: json["deliveryord"],
        totalord: json["totalord"].toDouble(),
        amortizoord: json["amortizoord"].toDouble(),
        margenord: json["margenord"].toDouble(),
        anotacord: json["anotacord"],
        estord: json["estord"],
      );

  Map<String, dynamic> toJson() => {
        "idord": idord,
        "idclie": idclie,
        "fechahoraord": fechahoraord,
        "fechahoradesp": fechahoradesp,
        "deliveryord": deliveryord,
        "totalord": totalord,
        "amortizoord": amortizoord,
        "margenord": margenord,
        "anotacord": anotacord,
        "estord": estord,
      };
}
