import '../database/db_dbprovider.dart';
import '../models/modelProductos.dart';

class DbCrudProductos {
  static final DbCrudProductos dbp = DbCrudProductos._();
  DbCrudProductos._();

  Future<int> NuevoProducto(Productos productos) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.insert('PRODUCTOS', productos.toJson());
    return res;
  }

  Future<int> ActualizarProductos(
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
    final res = await db.rawUpdate(
        '''UPDATE PRODUCTOS SET nombprod=?,descripprod=?,categprod=?,imgprod=?,cantprod=?,minstock=?,precioprod=?,
        ventaprod=?,despachorecep=? where idprod=? ''',
        [nombre, descrip, categ, img, cant, min, costo, venta, desrec, cod]);
    return res;
  }

  Future<List<Productos>> GetProductos(String busqueda) async {
    final db = await DBProvider.db.getdatabase();
    final res = await db.query('PRODUCTOS',
        where: 'nombprod like ?', whereArgs: [busqueda.toString()]);
    return res.isNotEmpty ? res.map((e) => Productos.fromJson(e)).toList() : [];
  }

  // Future<List<Categorias>> GetProductosxBarra(String cod) async {
  //   final db = await DbProvider.db.getdatabase();
  //   final res = await db.query('PRODUCTOS',
  //       where: 'codigo=?', whereArgs: [cod], limit: 1);
  //   return res.isNotEmpty
  //       ? res.map((e) => Categorias.fromJson(e)).toList()
  //       : [];
  // }
}
