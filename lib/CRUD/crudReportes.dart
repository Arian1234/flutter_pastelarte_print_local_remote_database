import '../database/db_dbprovider.dart';

class DbCrudReportes {
  static final DbCrudReportes dbp = DbCrudReportes._();
  DbCrudReportes._();

  Future<int> ObtenerVentasHoy() async {
    final db = await DBProvider.db.getdatabase();
    // final res = await db.rawUpdate(
    //     '''SELECT SUM(totalord) FROM ORDEN WHERE fechahoraord=? ''',
    //     [nombre]);
    String fecha = '03-10-2022';
    var records = await db.rawQuery('''SELECT sum(totalord) FROM ORDEN;''');
    int value = records[0]["sum(totalord)"] as int;
    return value;
  }
}
