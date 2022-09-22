// To parse this JSON data, do
//
//     final productos = productosFromJson(jsonString);

import 'dart:convert';

Productos productosFromJson(String str) => Productos.fromJson(json.decode(str));

String productosToJson(Productos data) => json.encode(data.toJson());

class Productos {
    Productos({
        this.idprod,
        this.nombprod,
        this.descripprod,
        this.categprod,
        this.imgprod,
        this.cantprod,
        this.minstock,
        this.precioprod,
        this.ventaprod,
        this.despachorecep,
        this.estadoprod,
    });

    int? idprod;
    String? nombprod;
    String? descripprod;
    String? categprod;
    String? imgprod;
    double? cantprod;
    double? minstock;
    double? precioprod;
    double? ventaprod;
    int? despachorecep;
    int? estadoprod;

    factory Productos.fromJson(Map<String, dynamic> json) => Productos(
        idprod: json["idprod"],
        nombprod: json["nombprod"],
        descripprod: json["descripprod"],
        categprod: json["categprod"],
        imgprod: json["imgprod"],
        cantprod: json["cantprod"].toDouble(),
        minstock: json["minstock"].toDouble(),
        precioprod: json["precioprod"].toDouble(),
        ventaprod: json["ventaprod"].toDouble(),
        despachorecep: json["despachorecep"],
        estadoprod: json["estadoprod"],
    );

    Map<String, dynamic> toJson() => {
        "idprod": idprod,
        "nombprod": nombprod,
        "descripprod": descripprod,
        "categprod": categprod,
        "imgprod": imgprod,
        "cantprod": cantprod,
        "minstock": minstock,
        "precioprod": precioprod,
        "ventaprod": ventaprod,
        "despachorecep": despachorecep,
        "estadoprod": estadoprod,
    };
}
