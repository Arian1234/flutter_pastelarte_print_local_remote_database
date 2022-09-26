import 'package:firebase_orders_flutter/widgets/textformfieldcustom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/controllerProductos.dart';

class productosPage_query extends StatefulWidget {
  final ProviderProductos provforaneo;
  const productosPage_query({Key? key, required this.provforaneo})
      : super(key: key);

  @override
  State<productosPage_query> createState() => _productosPage_queryState();
}

class _productosPage_queryState extends State<productosPage_query> {
  @override
  void initState() {
    super.initState();
    widget.provforaneo.ObtenerProducto('%%');
  }

  @override
  Widget build(BuildContext context) {
    double _ancho = MediaQuery.of(context).size.width;
    double _alto = MediaQuery.of(context).size.height;
    final prov = Provider.of<ProviderProductos>(context, listen: true);
    final _controllerbuscador = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text("Productos registrados"),
        centerTitle: true,
        backgroundColor: Colors.pink[400],
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'productos_insert');
                },
                icon: const Icon(
                  Icons.add,
                  size: 30,
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            width: _ancho,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textformfieldsintitle(
                        ancho: _ancho * .8,
                        controllerfield: _controllerbuscador,
                        hinttext: 'Buscar producto .',
                        textinputype: TextInputType.text,
                        habilitado: true),
                    SizedBox(
                      width: _ancho * .02,
                    ),
                    IconButton(
                        onPressed: () {
                          if (_controllerbuscador.text.toString().isNotEmpty) {
                            prov.ObtenerProducto(
                                '%${_controllerbuscador.text}%');
                          }
                        },
                        icon: Icon(
                          Icons.search,
                          color: Colors.teal[400],
                          size: 30,
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 15, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Registros de productos',
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
                  height: _alto * .80,
                  child: Center(
                    child: ListView.builder(
                      itemCount: prov.prod.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.teal[100],
                          child: ListTile(
                            title: Text(
                              prov.prod[index].nombprod.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.w400),
                            ),
                            subtitle: Text(
                              prov.prod[index].cantprod.toString(),
                            ),
                            leading: CircleAvatar(
                                backgroundColor: Colors.teal,
                                child:
                                    Text(prov.prod[index].idprod.toString())),
                            trailing: Text(
                              "${prov.prod[index].ventaprod} sol(es).",
                              style: const TextStyle(color: Colors.black45),
                            ),
                          ),
                        );
                      },
                    ),

                    //TODO:NO BORRAR ME COSTO MUCHO
                    //TODO : TRAE DATOS DE REALTIMEDATABASE EN UN LISTTILE

                    // child: StreamBuilder(
                    //   stream: FirebaseDatabase.instance.ref('products').onValue,
                    //   // initialData: initialData,
                    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
                    //     // log(snapshot.data.toString());
                    //     if (snapshot != null && snapshot.hasData) {
                    //       DataSnapshot dataValues = snapshot.data.snapshot;
                    //       Map<dynamic, dynamic> values =
                    //           dataValues.value as Map<dynamic, dynamic>;
                    //       list.clear();
                    //       values.forEach((key, values) {
                    //         // lists.add(values);
                    //         log(values.toString());
                    //         list.add(values);
                    //       });
                    //     }
                    //     return ListView.builder(
                    //       itemCount: list.length,
                    //       itemBuilder: (BuildContext context, int index) {
                    //         return Card(
                    //           child: ListTile(
                    //             title: Text(list[index]["nombre"]),
                    //             subtitle: Text(list[index]["venta"]),
                    //             leading: FadeInImage.assetNetwork(
                    //                 width: 50,
                    //                 height: 90,
                    //                 placeholder: 'assets/logo.png',
                    //                 image: list[index]["url"]),
                    //           ),
                    //         );
                    //       },
                    //     );
                    //   },
                    // ),
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
