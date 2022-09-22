// To parse this JSON data, do
//
//     final categorias = categoriasFromJson(jsonString);

import 'dart:convert';

Categorias categoriasFromJson(String str) =>
    Categorias.fromJson(json.decode(str));

String categoriasToJson(Categorias data) => json.encode(data.toJson());

Categorias categoriasFromMap(String str) => Categorias.fromMap(json.decode(str));

String categoriasToMap(Categorias data) => json.encode(data.toMap());

class Categorias {
  Categorias({
    this.idcateg,
    this.nombCateg,
  });

  int? idcateg;
  String? nombCateg;

  factory Categorias.fromJson(Map<String, dynamic> json) => Categorias(
        idcateg: json["idcateg"],
        nombCateg: json["nombCateg"],
      );

  Map<String, dynamic> toJson() => {
        "idcateg": idcateg,
        "nombCateg": nombCateg,
      };

          factory Categorias.fromMap(Map<String, dynamic> json) => Categorias(
        idcateg: json["idcateg"],
        nombCateg: json["nombCateg"],
    );

    Map<String, dynamic> toMap() => {
        "idcateg": idcateg,
        "nombCateg": nombCateg,
    };
}
