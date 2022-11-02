import 'package:firebase_orders_flutter/controllers/controllerProveedores.dart';
import 'package:firebase_orders_flutter/pages/proveedoresPage_insert.dart';
import 'package:firebase_orders_flutter/widgets/textformfieldcustom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class proveedoresPage_query extends StatefulWidget {
  const proveedoresPage_query({Key? key}) : super(key: key);

  @override
  State<proveedoresPage_query> createState() => _proveedoresPage_queryState();
}

class _proveedoresPage_queryState extends State<proveedoresPage_query> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double ancho = MediaQuery.of(context).size.width;
    double alto = MediaQuery.of(context).size.height;
    final prov = Provider.of<ProviderProveedores>(context, listen: true);
    final controllerbuscador = TextEditingController();

    return Scaffold(
      appBar: appBarProveedoresQuery(context),
      body: body(ancho, controllerbuscador, prov, alto),
    );
  }

  SingleChildScrollView body(
      double ancho,
      TextEditingController controllerbuscador,
      ProviderProveedores prov,
      double alto) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 14),
        child: SizedBox(
          width: ancho,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textformfieldsintitle(
                      clase: "proveedores",
                      ancho: ancho * .8,
                      controllerfield: controllerbuscador,
                      hinttext: 'B. proveedores por nombre',
                      textinputype: TextInputType.text,
                      habilitado: true,
                      prov: prov),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 15, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Registros de proveedores',
                      style: TextStyle(
                          color: Colors.teal[700],
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: ancho * .95,
                height: alto * .77,
                child: Center(
                  child: ListView.builder(
                    itemCount: prov.proveed.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: Card(
                              color: Colors.teal[100],
                              child: ListTile(
                                title: Text(
                                  prov.proveed[index].nombprovee.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400),
                                ),
                                subtitle: Text(
                                  prov.proveed[index].dirprovee.toString(),
                                ),
                                leading: CircleAvatar(
                                    backgroundColor: Colors.teal,
                                    child: Text(prov.proveed[index].idprovee
                                        .toString())),
                                trailing: Text(
                                  prov.proveed[index].celprovee.toString(),
                                  style: const TextStyle(color: Colors.black45),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            proveedoresPage_insert(
                                          id: prov.proveed[index].idprovee
                                              .toString(),
                                          nomb: prov.proveed[index].nombprovee
                                              .toString(),
                                          ruc: prov.proveed[index].rucprovee
                                              .toString(),
                                          dir: prov.proveed[index].dirprovee
                                              .toString(),
                                          cel: prov.proveed[index].celprovee
                                              .toString(),
                                        ),
                                      ));
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
    );
  }

  AppBar appBarProveedoresQuery(BuildContext context) {
    return AppBar(
      elevation: 1,
      title: const Text("Proveedores registrados"),
      centerTitle: true,
      backgroundColor: Colors.pink[400],
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, 'proveedore_insert');
              },
              icon: const Icon(
                Icons.new_releases_rounded,
                size: 30,
              )),
        )
      ],
    );
  }
}
