import 'dart:developer';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_orders_flutter/controllers/controllerCompras.dart';
import 'package:firebase_orders_flutter/controllers/controllerDetaCompra.dart';
import 'package:firebase_orders_flutter/controllers/controllerProveedores.dart';
import 'package:firebase_orders_flutter/models/modelCarritoDetaCompras.dart';
import 'package:firebase_orders_flutter/models/modelDetaCompras.dart';
import 'package:firebase_orders_flutter/widgets/textformfieldcustom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import '../controllers/controllerProductos.dart';
import 'package:decimal/decimal.dart';

class comprasPage extends StatefulWidget {
  final ProviderProductos provforaneo;
  const comprasPage({Key? key, required this.provforaneo}) : super(key: key);

  @override
  State<comprasPage> createState() => _comprasPageState();
}

String day = "0" + DateTime.now().day.toString();
String days = (day.substring(day.length - 2, day.length));

class _comprasPageState extends State<comprasPage> {
  var listado = [];
  var iniciado = 1;
  int cant = 0;
  Decimal total = 0.toDecimal();
  Decimal pcosto = 0.toDecimal();
  List<ScanResult>? scanResult;
  List<Detacompras> detacomp = [];
  List<Carritodetacompras> carritodetcomp = [];
  String fechai = "${DateTime.now().year}-${DateTime.now().month}-${days}";
  List<DropdownMenuItem<String>> list = [];
  String _valordropdownbutton = '1 ELABORACION INTERNA';
  final _controllernrodoc = TextEditingController();
  bool value = false;
  String fechaodoc = "";
  late Future<void> _valor;
  @override
  void initState() {
    super.initState();
    widget.provforaneo.ObtenerProducto('%%');
    _valor = llenardropdownbutton();
  }

  Future<void> llenardropdownbutton() async {
    await ProviderProveedores.obtenerProveedorDropDownButton().then((listmap) {
      listmap.map((mapa) {
        log(mapa.toString());
        return DropdownMenuItem<String>(
            value: mapa['idprovee'].toString() + " " + mapa['nombprovee'],
            child: Text(
              mapa['idprovee'].toString() + " " + mapa['nombprovee'],
              overflow: TextOverflow.ellipsis,
            ));
      }).forEach((element) {
        list.add(element);
      });
      log("lista cargada");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.provforaneo.prod.clear();
  }

  @override
  Widget build(BuildContext context) {
    double _ancho = MediaQuery.of(context).size.width;
    double _alto = MediaQuery.of(context).size.height;
    final prov = Provider.of<ProviderProductos>(context, listen: true);
    final _controllerbuscprod = TextEditingController();
    final _controllercodprod = TextEditingController();
    final _controllerprodbuscado = TextEditingController();
    final _controllernombprod = TextEditingController();
    final _controllercantprod = TextEditingController();
    final _controllerprecprod = TextEditingController();
    final _controllerprecvprod = TextEditingController();

    final provcompras = Provider.of<ProviderCompras>(context, listen: false);
    final provdetacompras =
        Provider.of<ProviderDetaCompra>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.blue[400],
        centerTitle: true,
        title: Text('Items: $cant | Total: $pcosto'),
        elevation: 1,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
                onPressed: () async {
                  if (cant > 0) {
                    log('cant es mayor a cero,el carrito de compra tiene length  $carritodetcomp.length.toString()');

                    return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Container(
                              width: _ancho * .9,
                              child: _controllernrodoc.text.isEmpty
                                  ? Text(
                                      "¿Su registro no tiene número de documento ,desea que se le autogenere uno?.")
                                  : Text(
                                      "¿Está seguro que desea registrar esta compra?."),
                            ),
                            actions: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: buttonmodal(
                                  ancho: _ancho * .20,
                                  alto: _alto * .06,
                                  title: "Cancelar",
                                  icon: Icons.arrow_back_ios,
                                  primary: Colors.red.withOpacity(.8),
                                  second: Colors.red.withOpacity(.9),
                                  shadow: Colors.black26,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  String unix = DateTime.now()
                                      .toUtc()
                                      .millisecondsSinceEpoch
                                      .toString();
                                  fechaodoc = _controllernrodoc.text.isEmpty
                                      ? unix
                                      : _controllernrodoc.text;

                                  final idcompra =
                                      await provcompras.AgregarCompra(
                                          fechaodoc,
                                          1,
                                          fechai,
                                          fechai,
                                          pcosto.toDouble(),
                                          pcosto.toDouble(),
                                          "---",
                                          0);

                                  for (var i = 0;
                                      i < carritodetcomp.length;
                                      i++) {
                                    provdetacompras.AgregarDetaCompra(
                                      idcompra,
                                      int.parse(
                                          carritodetcomp[i].idprod.toString()),
                                      double.parse(carritodetcomp[i]
                                          .preciooldprod
                                          .toString()),
                                      double.parse(carritodetcomp[i]
                                          .preciocprod
                                          .toString()),
                                      double.parse(carritodetcomp[i]
                                          .preciovprod
                                          .toString()),
                                      double.parse(carritodetcomp[i]
                                          .cantprod
                                          .toString()),
                                    );
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Nota de compra: $idcompra guardada.")),
                                  );
                                  Navigator.pop(context);
                                },
                                child: buttonmodal(
                                  ancho: _ancho * .20,
                                  alto: _alto * .06,
                                  title: "Guardar",
                                  icon: Icons.save,
                                  primary: Colors.blue.withOpacity(.8),
                                  second: Colors.blue.withOpacity(1),
                                  shadow: Colors.black26,
                                ),
                              ),
                            ],
                          );
                        });
                  }
                },
                icon: Icon(
                  Icons.app_registration_sharp,
                  size: 30,
                )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            width: _ancho,
            child: Column(
              children: [
                // TODO: CABECERA DE COMPRA
                Container(
                  width: _ancho * .9,
                  decoration: BoxDecoration(
                      color: Colors.pink.shade200,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: _ancho * .9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: _ancho * .4,
                            child: DateTimePicker(
                              type: DateTimePickerType.date,
                              // dateMask: 'd MMM, yyyy',
                              dateMask: 'd MMM, yyyy',
                              initialValue: DateTime.now().toString(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              icon: const Icon(
                                Icons.event,
                                color: Colors.pink,
                              ),

                              dateLabelText: 'Fecha de documento',

                              onChanged: (val) {
                                // log(getFormatedDate(val));
                                // fechai = getFormatedDate(val);
                                log(val);
                                fechai = val;
                              },
                              validator: (val) {
                                log("fecha validator :$val");
                                return null;
                              },
                              onSaved: (val) => log(val.toString()),
                            ),
                          ),
                          Container(
                              width: _ancho * .9,
                              height: 60,
                              decoration: BoxDecoration(
                                  // color: Colors.teal[100],
                                  border: Border.all(
                                      width: 1, color: Colors.black38),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              child: Row(
                                children: [
                                  Container(
                                      width: _ancho * .25,
                                      margin: const EdgeInsets.only(left: 9),
                                      child: const Text('Proveedores:')),
                                  Container(
                                    width: _ancho * .55,
                                    // color: Colors.red,
                                    child: FutureBuilder<void>(
                                      future: _valor,
                                      // initialData: InitialData,
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.pink,
                                              color: Colors.yellow,
                                            ),
                                          );
                                        } else {
                                          return DropdownButton(
                                            hint: const Text("S. un proveedor"),
                                            items: list,
                                            // style: TextStyle(
                                            //     overflow: TextOverflow.fade),
                                            onChanged: (value) {
                                              setState(() {
                                                _valordropdownbutton =
                                                    value.toString();
                                              });
                                            },
                                            value: _valordropdownbutton,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              child: Row(
                                children: [
                                  textformfield(
                                      ancho: _ancho * .6,
                                      controllercategoria: _controllernrodoc,
                                      textinputype: TextInputType.text,
                                      habilitado: true,
                                      label: "Ingrese nro de documento"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // TODO : DETALLE COMPRA
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // textformfieldsintitle(
                        //   clase: "productos",
                        //   ancho: _ancho * .65,
                        //   controllerfield: _controllerbuscprod,
                        //   hinttext: 'B. prod. por nombre',
                        //   textinputype: TextInputType.text,
                        //   habilitado: true,
                        //   prov: prov,
                        //   busc: "tort",
                        // ),

                        Container(
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                border:
                                    Border.all(width: 1, color: Colors.black26),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            width: _ancho * .75,
                            child: Row(
                              children: [
                                Container(
                                  // color: Colors.black12,
                                  width: _ancho * .74,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: TextFormField(
                                      onFieldSubmitted: (value) {
                                        prov.ObtenerProducto("%" +
                                            _controllerbuscprod.text +
                                            "%");

                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Container(
                                                width: _ancho * .9,
                                                height: _alto * .6,
                                                // color: Colors.black.withOpacity(.55),
                                                child: AlertDialog(
                                                  content: Container(
                                                      width: _ancho * .85,
                                                      height: _alto * .50,
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Container(
                                                          width: _ancho * .85,
                                                          height: _alto * .60,
                                                          child: Center(
                                                            child: ListView
                                                                .builder(
                                                              itemCount: prov
                                                                  .prod.length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                log("length prov.prod: ${prov.prod.length} listado : ${listado.length} index: $index");
                                                                if (iniciado ==
                                                                    1) {
                                                                  log("iniciado 1");
                                                                  for (var i =
                                                                          0;
                                                                      i <
                                                                          prov.prod
                                                                              .length;
                                                                      i++) {
                                                                    listado
                                                                        .add(0);
                                                                  }
                                                                  log("iniciado 0");
                                                                  iniciado = 0;
                                                                }

                                                                return Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          1),
                                                                  child: Card(
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          _ancho *
                                                                              .75,
                                                                      height:
                                                                          60,
                                                                      decoration: BoxDecoration(
                                                                          // color: Color.fromARGB(255, 147, 218, 15),
                                                                          borderRadius: BorderRadius.circular(5.0),
                                                                          gradient: LinearGradient(colors: [
                                                                            Colors.yellow.withOpacity(.6),
                                                                            Colors.yellow.withOpacity(.8),
                                                                            // Colors.teal.shade400
                                                                          ]),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                                color: Colors.black.withOpacity(.1),
                                                                                blurRadius: 5.0,
                                                                                offset: const Offset(2.0, 2.0))
                                                                          ]),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            EdgeInsets.only(left: _ancho * .03),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceAround,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: _ancho * .1,
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  CircleAvatar(backgroundColor: Colors.pink.shade300, foregroundColor: Colors.white, child: Text(prov.prod[index].idprod.toString())),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: _ancho * .30,
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    width: _ancho * .35,
                                                                                    // color: Colors.red,
                                                                                    child: Center(
                                                                                      child: FittedBox(
                                                                                        child: Text(
                                                                                          prov.prod[index].nombprod.toString(),
                                                                                          style: const TextStyle(fontWeight: FontWeight.w400, overflow: TextOverflow.ellipsis),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    prov.prod[index].cantprod.toString() + " UND",
                                                                                    style: const TextStyle(color: Colors.black45),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              width: _ancho * .16,
                                                                              child: IconButton(
                                                                                icon: Icon(
                                                                                  Icons.arrow_forward_ios,
                                                                                  color: Colors.pink.shade500,
                                                                                  size: 35,
                                                                                ),
                                                                                onPressed: () {
                                                                                  // TODO: SEGUNDO ALERT DIALOG ,EL CUAL CONTIENE LOS DETALLES A LOS CUALES SE DESEA AGREGAR
                                                                                  showDialog(
                                                                                      // barrierDismissible: true,
                                                                                      context: context,
                                                                                      builder: (BuildContext context) {
                                                                                        _controllercodprod.text = prov.prod[index].idprod.toString();

                                                                                        _controllernombprod.text = prov.prod[index].nombprod.toString();
                                                                                        return Container(
                                                                                          width: _ancho * .9,
                                                                                          height: _alto * .6,
                                                                                          child: AlertDialog(
                                                                                            actions: [
                                                                                              Container(
                                                                                                color: Colors.pink[400],
                                                                                                width: _ancho * .9,
                                                                                                height: _alto * .1,
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                                  children: [
                                                                                                    GestureDetector(
                                                                                                      onTap: () {
                                                                                                        Navigator.pop(context);
                                                                                                      },
                                                                                                      child: buttonmodal(
                                                                                                        ancho: _ancho * .20,
                                                                                                        alto: _alto * .06,
                                                                                                        title: "Volver",
                                                                                                        icon: Icons.arrow_back_ios,
                                                                                                        primary: Colors.red.withOpacity(.8),
                                                                                                        second: Colors.red.withOpacity(.9),
                                                                                                        shadow: Colors.black26,
                                                                                                      ),
                                                                                                    ),
                                                                                                    GestureDetector(
                                                                                                      onTap: () {
                                                                                                        setState(() {
                                                                                                          //TODO : CARRITO DE COMPRAS

                                                                                                          var venta = Decimal.parse(_controllercantprod.text.toString()) * Decimal.parse(_controllerprecvprod.text.toString());
                                                                                                          var cost = Decimal.parse(_controllercantprod.text.toString()) * Decimal.parse(_controllerprecprod.text.toString());
                                                                                                          carritodetcomp.add(Carritodetacompras(
                                                                                                            idprod: int.parse(_controllercodprod.text.toString()),
                                                                                                            nombprod: (_controllernombprod.text.toString()),
                                                                                                            preciooldprod: double.parse(prov.prod[index].precioprod.toString()),
                                                                                                            preciocprod: double.parse(_controllerprecprod.text.toString()),
                                                                                                            preciovprod: double.parse(_controllerprecvprod.text.toString()),
                                                                                                            cantprod: double.parse(_controllercantprod.text.toString()),
                                                                                                          ));

                                                                                                          cant = cant + int.parse(_controllercantprod.text.toString());

                                                                                                          pcosto = pcosto + cost;
                                                                                                          total = total + venta;
                                                                                                        });

                                                                                                        log("cantidad  actualizada $cant+ $pcosto");
                                                                                                        Navigator.pop(context);
                                                                                                        Navigator.pop(context);
                                                                                                      },
                                                                                                      child: buttonmodal(
                                                                                                        ancho: _ancho * .20,
                                                                                                        alto: _alto * .06,
                                                                                                        title: "Agregar",
                                                                                                        icon: Icons.save_as,
                                                                                                        primary: Colors.blue.withOpacity(.7),
                                                                                                        second: Colors.blue.withOpacity(.9),
                                                                                                        shadow: Colors.black26,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              )
                                                                                            ],
                                                                                            content: Container(
                                                                                              width: _ancho * .9,
                                                                                              height: _alto * .43,
                                                                                              child: Column(
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  textformfield(ancho: _ancho * .3, controllercategoria: _controllercodprod, textinputype: TextInputType.text, habilitado: false, label: "Codigo"),
                                                                                                  const SizedBox(
                                                                                                    height: 10,
                                                                                                  ),
                                                                                                  textformfield(ancho: _ancho * .7, controllercategoria: _controllernombprod, textinputype: TextInputType.text, habilitado: false, label: "Producto"),
                                                                                                  const SizedBox(
                                                                                                    height: 10,
                                                                                                  ),
                                                                                                  textformfield_hintText(
                                                                                                    ancho: _ancho * .5,
                                                                                                    controllercategoria: _controllerprecprod,
                                                                                                    textinputype: TextInputType.number,
                                                                                                    habilitado: true,
                                                                                                    label: "P. compra/costo",
                                                                                                    hinttext: "precio costo: " + prov.prod[index].precioprod.toString(),
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                    height: 10,
                                                                                                  ),
                                                                                                  textformfield_hintText(
                                                                                                    ancho: _ancho * .5,
                                                                                                    controllercategoria: _controllerprecvprod,
                                                                                                    textinputype: TextInputType.number,
                                                                                                    habilitado: true,
                                                                                                    label: "P. venta",
                                                                                                    hinttext: "precio venta: " + prov.prod[index].ventaprod.toString(),
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                    height: 10,
                                                                                                  ),
                                                                                                  textformfield_hintText(
                                                                                                    ancho: _ancho * .4,
                                                                                                    controllercategoria: _controllercantprod,
                                                                                                    textinputype: TextInputType.number,
                                                                                                    habilitado: true,
                                                                                                    label: "Cantidad",
                                                                                                    hinttext: "stock act.: " + prov.prod[index].cantprod.toString(),
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        );
                                                                                      });
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                              );
                                            });
                                      },
                                      controller: _controllerbuscprod,
                                      style: const TextStyle(
                                          color: Colors.black54),
                                      keyboardType: TextInputType.text,
                                      enabled: true,
                                      decoration: const InputDecoration(
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        hintText: "B. prod. por nombre",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),

                        SizedBox(
                          width: _ancho * .02,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    width: _ancho * .93,
                    height: _alto * .05,
                    color: Colors.pink,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text(
                          "COD",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          "PROD/PREC. C./PREC. V",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          "TOTAL UND.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    height: _alto * .50,
                    width: _ancho * .95,
                    child: ListView.builder(
                      itemCount: carritodetcomp.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.pink[400],
                              foregroundColor: Colors.white,
                              child:
                                  Text(carritodetcomp[index].idprod.toString()),
                            ),
                            trailing:
                                Text(carritodetcomp[index].cantprod.toString()),
                            title: Text(
                              carritodetcomp[index].nombprod.toString(),
                            ),
                            subtitle: Text(
                              "PC: " +
                                  carritodetcomp[index].preciocprod.toString() +
                                  "\nPV: " +
                                  carritodetcomp[index].preciovprod.toString(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class buttonOrdenes extends StatelessWidget {
  const buttonOrdenes({
    Key? key,
    required double ancho,
    required double alto,
    required String title,
    required IconData icon,
    required Color primary,
    required Color second,
    required Color shadow,
  })  : _ancho = ancho,
        _alto = alto,
        _title = title,
        _icon = icon,
        _primary = primary,
        _second = second,
        _shadow = shadow,
        super(key: key);

  final double _ancho;
  final double _alto;
  final String _title;
  final IconData _icon;
  final Color _primary;
  final Color _second;
  final Color _shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            // color: Color.fromARGB(255, 147, 218, 15),
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(colors: [_primary, _second]),
            boxShadow: [
              BoxShadow(
                  color: _shadow,
                  blurRadius: 15.0,
                  offset: const Offset(2.0, 2.0))
            ]),
        width: _ancho,
        height: _alto,
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _title.isNotEmpty
                ? Text(
                    _title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w300, color: Colors.white),
                  )
                : SizedBox(),
          ),
          leading: Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Icon(
              _icon,
              color: Colors.white,
            ),
          ),
        ));
  }
}

class buttonmodal extends StatelessWidget {
  const buttonmodal({
    Key? key,
    required double ancho,
    required double alto,
    required String title,
    required IconData icon,
    required Color primary,
    required Color second,
    required Color shadow,
  })  : _ancho = ancho,
        _alto = alto,
        _title = title,
        _icon = icon,
        _primary = primary,
        _second = second,
        _shadow = shadow,
        super(key: key);

  final double _ancho;
  final double _alto;
  final String _title;
  final IconData _icon;
  final Color _primary;
  final Color _second;
  final Color _shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            // color: Color.fromARGB(255, 147, 218, 15),
            borderRadius: BorderRadius.circular(15.0),
            gradient: LinearGradient(colors: [_primary, _second]),
            boxShadow: [
              BoxShadow(
                  color: _shadow,
                  blurRadius: 15.0,
                  offset: const Offset(2.0, 2.0))
            ]),
        width: _ancho,
        height: _alto,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _icon,
              color: Colors.white,
            ),
            Text(
              _title,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ));
  }
}
