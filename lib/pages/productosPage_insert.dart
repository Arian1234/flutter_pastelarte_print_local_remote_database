import 'package:firebase_orders_flutter/controllers/controllerCategorias.dart';
import 'package:firebase_orders_flutter/widgets/inputsValidator.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/controllerProductos.dart';

class productosPage_insert extends StatefulWidget {
  const productosPage_insert(
      {Key? key,
      this.id,
      this.prod,
      this.descrip,
      this.categ,
      this.cantprod,
      this.cantmin,
      this.preccost,
      this.precvent,
      this.despinst})
      : super(key: key);
  final String? id;
  final String? prod;
  final String? descrip;
  final String? categ;
  final String? cantprod;
  final String? cantmin;
  final String? preccost;
  final String? precvent;
  final String? despinst;
  @override
  State<productosPage_insert> createState() => _productosPage_insertState();
}

class _productosPage_insertState extends State<productosPage_insert> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController contr = TextEditingController();
  final valores = [];
  final _controllerprecioventaprod = TextEditingController();
  final _controllernombprod = TextEditingController();
  final _controlleridprod = TextEditingController();
  final _controllercantprod = TextEditingController();
  final _controllerstockminprod = TextEditingController();
  final _controllerpreciocostoprod = TextEditingController();
  final _controllerdescripprod = TextEditingController();
  bool _switchDespacho = false;
  String estado = 'Nuevo';
  List<DropdownMenuItem<String>> list = [];
  String _valordropdownbutton = '1 VARIOS';

  late Future<void> _valor;
  @override
  void initState() {
    super.initState();
    _valor = llenardropdownbutton();

    if (widget.id != null) {
      _controlleridprod.text = widget.id.toString();
      _controllernombprod.text = widget.prod.toString();
      _controllerdescripprod.text = widget.descrip.toString();
      _controllercantprod.text = widget.cantprod.toString();
      _controllerstockminprod.text = widget.cantmin.toString();
      _controllerpreciocostoprod.text = widget.preccost.toString();
      _controllerprecioventaprod.text = widget.precvent.toString();
      setState(() {
        estado = 'Actualizar';
        _switchDespacho = widget.despinst.toString() == '1' ? true : false;
      });
    }
  }

  Future<void> llenardropdownbutton() async {
    await ProviderCategorias.obtenerCategoriaDropDownButton().then((listmap) {
      listmap.map((mapa) {
        return DropdownMenuItem<String>(
            value: mapa['idcateg'].toString() + " " + mapa['nombCateg'],
            child: Text(
              mapa['idcateg'].toString() + " " + mapa['nombCateg'],
              overflow: TextOverflow.ellipsis,
            ));
      }).forEach((element) {
        list.add(element);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProviderProductos>(context, listen: true);
    final ancho = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink[400],
          elevation: 1,
          title: Text("$estado producto"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: IconButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.pink,
                            color: Colors.yellow,
                          ),
                        );
                      });

                  if (_formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    String id = _controlleridprod.value.text.toString();
                    String nombre = _controllernombprod.value.text.toString();
                    String descripc =
                        _controllerdescripprod.value.text.toString();
                    String cant = _controllercantprod.value.text.toString();
                    String cantmin =
                        _controllerstockminprod.value.text.toString();
                    String costo =
                        _controllerpreciocostoprod.value.text.toString();
                    String venta =
                        _controllerprecioventaprod.value.text.toString();
                    int despacho = _switchDespacho ? 1 : 0;
                    int est = 0;
                    if (widget.id != null) {
                      est = await prov.actualizarProducto(
                          int.parse(id),
                          nombre,
                          descripc,
                          'categ_update',
                          "img_ref_update",
                          double.parse(cant),
                          double.parse(cantmin),
                          double.parse(costo),
                          double.parse(venta),
                          despacho);
                    } else {
                      est = await prov.agregarProducto(
                          nombre,
                          descripc,
                          "VARIOS",
                          "Imagereference",
                          double.parse(cant),
                          double.parse(cantmin),
                          double.parse(costo),
                          double.parse(venta),
                          despacho,
                          1);
                    }

                    if (est == 1) {
                      Timer(const Duration(milliseconds: 1900), () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Datos registrados/actualizados.')),
                        );
                      });
                    } else {
                      Timer(const Duration(milliseconds: 300), () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Hubo un error al intentar registrar/actualizar.')),
                        );
                      });
                    }
                  } else {
                    Navigator.pop(context);
                  }
                },
                icon: Icon(
                  widget.id != null ? Icons.refresh : Icons.save_alt_outlined,
                  size: 30,
                ),
              ),
            )
          ],
        ),
        body: body(ancho));
  }

  GestureDetector body(double ancho) {
    const sizedBox = SizedBox(
      height: 10,
    );
    return GestureDetector(
      child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 12, left: 12, right: 12, top: 12),
              child: SizedBox(
                width: ancho,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: ancho * .33,
                          height: ancho * .33,
                          decoration: BoxDecoration(
                              color: Colors.pink[100],
                              borderRadius: BorderRadius.circular(25)),
                          child: GestureDetector(
                              onTap: () {},
                              child: const ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                clipBehavior: Clip.antiAlias,
                                child: Image(
                                  image: AssetImage('assets/logo.png'),
                                  width: 50,
                                  fit: BoxFit.fill,
                                ),
                              )),
                        )
                      ],
                    ),
                    sizedBox,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textFormField_inputCod(
                            ancho: ancho * .25, controller: _controlleridprod),
                        sizedBox,
                        textFormField_inputText(
                            ancho: ancho * .75,
                            controller: _controllernombprod,
                            label: 'Nombre del producto',
                            hint: 'Ejm: Porc. torta de vainilla'),
                        sizedBox,
                        textFormField_inputText(
                            ancho: ancho * .9,
                            controller: _controllerdescripprod,
                            label: 'Descripción',
                            hint: 'Ejm: Dulce y rica.'),
                        sizedBox,
                        Container(
                            width: ancho * .7,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.teal[100],
                                border:
                                    Border.all(width: 1, color: Colors.black38),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: Row(
                              children: [
                                Container(
                                    width: ancho * .25,
                                    margin: const EdgeInsets.only(left: 9),
                                    child: const Text('Categoría:')),
                                SizedBox(
                                  width: ancho * .40,
                                  child: FutureBuilder<void>(
                                    future: _valor,
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
                                          hint: const Text("S. una categoría"),
                                          items: list,
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
                        sizedBox,
                        Row(
                          children: [
                            textFormField_inputInteger(
                                ancho: ancho * .44,
                                controller: _controllercantprod,
                                label: 'Cant. del producto',
                                hint: 'Ejm: 41'),
                            SizedBox(
                              width: ancho * .02,
                            ),
                            textFormField_inputInteger(
                                ancho: ancho * .44,
                                controller: _controllerstockminprod,
                                label: 'Cant. mínima',
                                hint: 'Ejm: 4'),
                          ],
                        ),
                        sizedBox,
                        Row(
                          children: [
                            textFormField_inputDecimal(
                                ancho: ancho * .44,
                                controller: _controllerpreciocostoprod,
                                label: 'Precio costo',
                                hint: 'Ejm: 1.80'),
                            SizedBox(
                              width: ancho * .02,
                            ),
                            textFormField_inputDecimal(
                                ancho: ancho * .44,
                                controller: _controllerprecioventaprod,
                                label: 'Precio venta',
                                hint: 'Ejm: 2.50'),
                          ],
                        ),
                        sizedBox,
                        Container(
                            width: ancho * .6,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.teal[100],
                                border:
                                    Border.all(width: 1, color: Colors.black38),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: Row(
                              children: [
                                Container(
                                    width: ancho * .25,
                                    margin: const EdgeInsets.only(left: 9),
                                    child: const Text('Despacho inst.:')),
                                Switch(
                                    value: _switchDespacho,
                                    onChanged: (value) {
                                      setState(() {
                                        _switchDespacho = value;
                                      });
                                    })
                              ],
                            )),
                        sizedBox,
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
