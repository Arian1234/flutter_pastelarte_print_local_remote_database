// To parse this JSON data, do
//
//     final reporteprodmin = reporteprodminFromJson(jsonString);

import 'dart:convert';

Reporteprodmin reporteprodminFromJson(String str) => Reporteprodmin.fromJson(json.decode(str));

String reporteprodminToJson(Reporteprodmin data) => json.encode(data.toJson());

class Reporteprodmin {
    Reporteprodmin({
        this.cod,
        this.prod,
        this.cant,
        this.cantmin,
    });

    int? cod;
    String? prod;
    double? cant;
    double? cantmin;

    factory Reporteprodmin.fromJson(Map<String, dynamic> json) => Reporteprodmin(
        cod: json["COD"],
        prod: json["PROD"],
        cant: json["CANT"].toDouble(),
        cantmin: json["CANTMIN"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "COD": cod,
        "PROD": prod,
        "CANT": cant,
        "CANTMIN": cantmin,
    };
}
