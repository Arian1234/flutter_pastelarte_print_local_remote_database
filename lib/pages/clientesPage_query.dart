import 'dart:async';
import 'dart:developer';
import 'package:firebase_orders_flutter/controllers/controllerClientes.dart';
import 'package:firebase_orders_flutter/pages/clientesPage_insert.dart';
import 'package:firebase_orders_flutter/widgets/textformfieldcustom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class clientesPage_query extends StatefulWidget {
  final ProviderClientes provforaneo;
  const clientesPage_query({Key? key, required this.provforaneo})
      : super(key: key);

  @override
  State<clientesPage_query> createState() => _clientesPage_queryState();
}

class _clientesPage_queryState extends State<clientesPage_query> {
  @override
  void initState() {
    super.initState();
    widget.provforaneo.ObtenerClientes('%%');
  }

  @override
  Widget build(BuildContext context) {
    double _ancho = MediaQuery.of(context).size.width;
    double _alto = MediaQuery.of(context).size.height;
    final prov = Provider.of<ProviderClientes>(context, listen: true);
    final _controllerbuscador = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text("Clientes registrados"),
        centerTitle: true,
        backgroundColor: Colors.pink[400],
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'clientes_insert');
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
                      clase: "clientes",
                      ancho: _ancho * .8,
                      controllerfield: _controllerbuscador,
                      hinttext: 'B. clientes por nombre',
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
                        'Registros de clientes',
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
                      itemCount: prov.clie.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: Card(
                                color: Colors.teal[100],
                                child: ListTile(
                                  title: Text(
                                    prov.clie[index].nombclie.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w400),
                                  ),
                                  subtitle: Text(
                                    prov.clie[index].dirclie.toString(),
                                  ),
                                  leading: CircleAvatar(
                                      backgroundColor: Colors.teal,
                                      child: Text(
                                          prov.clie[index].idclie.toString())),
                                  trailing: Text(
                                    prov.clie[index].celclie.toString(),
                                    style:
                                        const TextStyle(color: Colors.black45),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                right: 0,
                                top: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    log("Se acaba de presionar cliente con codigo : ${prov.clie[index].idclie}");
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              clientesPage_insert(
                                            id: prov.clie[index].idclie
                                                .toString(),
                                            nomb: prov.clie[index].nombclie
                                                .toString(),
                                            doc: prov.clie[index].docclie
                                                .toString(),
                                            dir: prov.clie[index].dirclie
                                                .toString(),
                                            cel: prov.clie[index].celclie
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
      ),
    );
  }
}
