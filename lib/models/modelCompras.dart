// To parse this JSON data, do
//
//     final compras = comprasFromJson(jsonString);

import 'dart:convert';

Compras comprasFromJson(String str) => Compras.fromJson(json.decode(str));

String comprasToJson(Compras data) => json.encode(data.toJson());

class Compras {
    Compras({
        this.idcomp,
        this.nrodocumento,
        this.idprovee,
        this.fecharegistrocomp,
        this.fechadoc,
        this.totalcomp,
        this.amortizocomp,
        this.anotacomp,
        this.estcomp,
    });

    int? idcomp;
    String? nrodocumento;
    int? idprovee;
    String? fecharegistrocomp;
    String? fechadoc;
    double? totalcomp;
    double? amortizocomp;
    String? anotacomp;
    int? estcomp;

    factory Compras.fromJson(Map<String, dynamic> json) => Compras(
        idcomp: json["idcomp"],
        nrodocumento: json["nrodocumento"],
        idprovee: json["idprovee"],
        fecharegistrocomp: json["fecharegistrocomp"],
        fechadoc: json["fechadoc"],
        totalcomp: json["totalcomp"].toDouble(),
        amortizocomp: json["amortizocomp"].toDouble(),
        anotacomp: json["anotacomp"],
        estcomp: json["estcomp"],
    );

    Map<String, dynamic> toJson() => {
        "idcomp": idcomp,
        "nrodocumento": nrodocumento,
        "idprovee": idprovee,
        "fecharegistrocomp": fecharegistrocomp,
        "fechadoc": fechadoc,
        "totalcomp": totalcomp,
        "amortizocomp": amortizocomp,
        "anotacomp": anotacomp,
        "estcomp": estcomp,
    };
}
