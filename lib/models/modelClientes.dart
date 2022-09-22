// To parse this JSON data, do
//
//     final clientes = clientesFromJson(jsonString);

import 'dart:convert';

Clientes clientesFromJson(String str) => Clientes.fromJson(json.decode(str));

String clientesToJson(Clientes data) => json.encode(data.toJson());

class Clientes {
  Clientes({
    this.idclie,
    this.nombclie,
    this.docclie,
    this.dirclie,
    this.celclie,
  });

  int? idclie;
  String? nombclie;
  String? docclie;
  String? dirclie;
  String? celclie;

  factory Clientes.fromJson(Map<String, dynamic> json) => Clientes(
        idclie: json["idclie"],
        nombclie: json["nombclie"],
        docclie: json["docclie"],
        dirclie: json["dirclie"],
        celclie: json["celclie"],
      );

  Map<String, dynamic> toJson() => {
        "idclie": idclie,
        "nombclie": nombclie,
        "docclie": docclie,
        "dirclie": dirclie,
        "celclie": celclie,
      };
}
