import 'dart:developer';
import 'dart:io';

import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';

class DBProvider {
  static String _parch = '';
  static Database? _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();
  Future<Database> getdatabase() async {
    return _database ??= await initdatabase();
  }

  String parche() {
    return _parch;
  }

  _parche(String x) {
    _parch = x;
  }

  Future<Database> initdatabase() async {
    var dbpath = await getDatabasesPath();
    log("ruta: " + dbpath);
    _parch = join(dbpath, 'dbpastelsaqqqqqqqq.db');
//
    // final dataDir = Directory(dbpath);

// final Email email = Email(
//   body: 'Email body',
//   subject: 'Email subject',
//   recipients: ['amolina5678@hotmail.com'],
//   cc: ['cc@examples.com'],
//   bcc: ['bcc@examples.com'],
//   attachmentPaths: ['/path/to/attachment.zip'],
//   isHTML: false,
// );
    // await FlutterEmailSender.send(email);

    return await openDatabase(
      _parch,
      version: 13,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute(categorias);
        await db.execute(clientes);
        await db.execute(productos);
        await db.execute(orden);
        await db.execute(detaorden);
        await db.execute(inserts);
      },
    );
  }

  String categorias = '''
CREATE TABLE CATEGORIAS(
  idcateg INTEGER PRIMARY KEY,
  nombCateg TEXT UNIQUE
);
''';
  String clientes = '''
CREATE TABLE CLIENTES(
  idclie INTEGER PRIMARY KEY,
  nombclie TEXT UNIQUE,
  docclie TEXT,
  dirclie TEXT,
  celclie TEXT
);
''';
  String productos = '''
CREATE TABLE PRODUCTOS(
  idprod INTEGER PRIMARY KEY,
  nombprod TEXT UNIQUE NOT NULL,
  descripprod TEXT,
  categprod TEXT,
  imgprod TEXT,
  cantprod DECIMAL(7,2),
  minstock DECIMAL(7,2),
  precioprod DECIMAL(7,2),
  ventaprod DECIMAL(7,2),
  despachorecep BOOLEAN NOT NULL CHECK (despachorecep IN(0,1)),
  estadoprod BOOLEAN NOT NULL CHECK (estadoprod IN(0,1)));
''';

  String orden = '''
CREATE TABLE ORDEN(
  idord INTEGER PRIMARY KEY,
  unix TEXT,
  idclie INTEGER,
  fechahoraord DATETIME,
  fechahoradesp DATETIME,
  deliveryord TEXT,
  totalord DECIMAL(7,2),
  amortizoord DECIMAL(7,2),
  margenord DECIMAL(7,2),
  anotacord TEXT,
  estord BOOLEAN NOT NULL CHECK (estord IN(0,1)));
''';

  String detaorden = '''
CREATE TABLE DETAORDEN(
  iddetaord INTEGER PRIMARY KEY,
  idord INTEGER,
  idprod INTEGER,
  preciocprod DECIMAL(7,2),
  preciovprod DECIMAL(7,2),
  cantprod DECIMAL(7,2)
);

''';
  String inserts = '''
INSERT INTO CATEGORIAS(idcateg,nombcateg) VALUES(null,"VARIOS"); 
INSERT INTO CLIENTES(idclie,nombclie,docclie,dirclie,celclie) VALUES(null,"VARIOS","0000","---","0000");
''';
}
