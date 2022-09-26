import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();
  Future<Database> getdatabase() async {
    return _database ??= await initdatabase();
  }

  Future<Database> initdatabase() async {
    var dbpath = await getDatabasesPath();
    String paths = join(dbpath, 'dbpastell.db');

    return await openDatabase(
      paths,
      version: 2,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute(categorias);
        await db.execute(clientes);
        await db.execute(productos);
        await db.execute(orden);
        await db.execute(detaorden);
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
  nombclie TEXT,
  fechahoraord TEXT,
  fechahoradesp TEXT,
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
}
