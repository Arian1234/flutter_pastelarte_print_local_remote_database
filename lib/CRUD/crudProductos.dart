import '../database/db_dbprovider.dart';
import '../models/modelProductos.dart';

class DbCrudProductos {
  static final DbCrudProductos dbp = DbCrudProductos._();
  DbCrudProductos._();

  Future<int> nuevoProducto(Productos productos) async {
    final db = await DBProvider.db.getdatabase();
    var res = 0;
    try {
      res = await db.insert('PRODUCTOS', productos.toJson());
      return res;
    } catch (e) {
      return res;
    }
  }

  Future<int> actualizarProductos(
      int cod,
      String nombre,
      String descrip,
      String categ,
      String img,
      double cant,
      double min,
      double costo,
      double venta,
      int desrec) async {
    final db = await DBProvider.db.getdatabase();
    var res = 0;
    try {
      res = await db.rawUpdate(
          '''UPDATE PRODUCTOS SET nombprod=?,descripprod=?,categprod=?,imgprod=?,cantprod=?,minstock=?,precioprod=?,
        ventaprod=?,despachorecep=? where idprod=? ''',
          [nombre, descrip, categ, img, cant, min, costo, venta, desrec, cod]);
      return res;
    } catch (e) {
      return res;
    }
  }

  Future<List<Productos>> getProductos(String busqueda) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.query('PRODUCTOS',
        where: 'nombprod like ?', whereArgs: [busqueda.toString()]);
    return res.isNotEmpty ? res.map((e) => Productos.fromJson(e)).toList() : [];
  }
}
