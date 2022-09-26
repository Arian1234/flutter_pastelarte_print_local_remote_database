// To parse this JSON data, do
//
//     final orden = ordenFromJson(jsonString);

import 'dart:convert';

Orden ordenFromJson(String str) => Orden.fromJson(json.decode(str));

String ordenToJson(Orden data) => json.encode(data.toJson());

class Orden {
  Orden({
    this.idord,
    this.unix,
    this.nombclie,
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
  String? unix;
  String? nombclie;
  String? fechahoraord;
  String? fechahoradesp;
  String? deliveryord;
  double? totalord;
  double? amortizoord;
  double? margenord;
  String? anotacord;
  int? estord;

  factory Orden.fromJson(Map<String, dynamic> json) => Orden(
        idord: json["idord"],
        unix: json["unix"],
        nombclie: json["nombclie"],
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
        "unix": unix,
        "nombclie": nombclie,
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
