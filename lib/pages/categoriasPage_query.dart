import 'dart:developer';
import 'package:firebase_orders_flutter/controllers/controllerCategorias.dart';
import 'package:firebase_orders_flutter/pages/categoriasPage_insert.dart';
import 'package:firebase_orders_flutter/widgets/textformfieldcustom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class categoriasPage_query extends StatefulWidget {
  final ProviderCategorias provforaneo;
  const categoriasPage_query({Key? key, required this.provforaneo})
      : super(key: key);

  @override
  State<categoriasPage_query> createState() => _categoriasPage_queryState();
}

class _categoriasPage_queryState extends State<categoriasPage_query> {
  @override
  void initState() {
    super.initState();
    widget.provforaneo.ObtenerCategoria('%%');
  }

  @override
  Widget build(BuildContext context) {
    double _ancho = MediaQuery.of(context).size.width;
    double _alto = MediaQuery.of(context).size.height;
    final prov = Provider.of<ProviderCategorias>(context, listen: true);
    final _controllerbuscador = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text(" Categorias registradas"),
        centerTitle: true,
        backgroundColor: Colors.pink[400],
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'categorias_insert');
                },
                icon: const Icon(
                  Icons.new_releases_rounded,
                  size: 30,
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Container(
            width: _ancho,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textformfieldsintitle(
                      clase: "categorias",
                      ancho: _ancho * .8,
                      controllerfield: _controllerbuscador,
                      hinttext: 'B. categoria por nombre',
                      textinputype: TextInputType.text,
                      habilitado: true,
                      prov: prov,
                      busc: _controllerbuscador.text,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 15, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Registros de categorias',
                        style: TextStyle(
                            color: Colors.teal[700],
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: _ancho * .95,
                  height: _alto * .77,
                  child: Center(
                    child: ListView.builder(
                      itemCount: prov.cat.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: Card(
                                color: Colors.teal[100],
                                child: ListTile(
                                  title: Text(
                                    prov.cat[index].nombCateg.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400),
                                  ),
                                  leading: CircleAvatar(
                                      backgroundColor: Colors.teal,
                                      child: Text(
                                          prov.cat[index].idcateg.toString())),
                                ),
                              ),
                            ),
                            Positioned(
                                right: 0,
                                top: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    log("Se acaba de presionar categoria con codigo : ${prov.cat[index].idcateg.toString()}");
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                categoriasPage_insert(
                                                  id: prov.cat[index].idcateg
                                                      .toString(),
                                                  categ: prov
                                                      .cat[index].nombCateg
                                                      .toString(),
                                                )));
                                  },
                                  child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: (Colors.pink[400]),
                                      foregroundColor: Colors.red,
                                      child: const Icon(
                                        Icons.refresh_sharp,
                                        color: Colors.white,
                                      )),
                                )),
                          ],
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
