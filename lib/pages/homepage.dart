import 'dart:developer';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_orders_flutter/controllers/controllerCategorias.dart';
import 'package:firebase_orders_flutter/controllers/controllerClientes.dart';
import 'package:firebase_orders_flutter/controllers/controllerProveedores.dart';
import 'package:firebase_orders_flutter/database/db_dbprovider.dart';
import 'package:firebase_orders_flutter/pages/ComprasPage.dart';
import 'package:firebase_orders_flutter/pages/categoriasPage_query.dart';
import 'package:firebase_orders_flutter/pages/clientesPage_query.dart';
import 'package:firebase_orders_flutter/pages/impresora/impresoraAlertDialog.dart';
import 'package:firebase_orders_flutter/pages/OrdenPage.dart';
import 'package:firebase_orders_flutter/pages/productosPage_query.dart';
import 'package:firebase_orders_flutter/pages/proveedoresPage_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:provider/provider.dart';
import '../controllers/controllerProductos.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final _controllervalidator = TextEditingController();
  bool validator = true;
  int intentos = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _ancho = MediaQuery.of(context).size.width;
    double _alto = MediaQuery.of(context).size.height;
    final prov = Provider.of<ProviderCategorias>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pastel´arte',
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        elevation: 1,
        actions: [
          IconButton(
              onPressed: () async {
                return showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return impresoraAlertDialog(
                        alto: _alto * .2,
                        ancho: _ancho * .8,
                      );
                    });
              },
              icon: Icon(Icons.bluetooth)),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.exit_to_app_outlined,
                  color: Colors.black38,
                  size: 29,
                )),
          )
        ],
      ),
      drawer: SlideInLeft(
        child: Drawer(
            elevation: 1,
            child: validator
                ? ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        height: _alto * .25,
                        child: DrawerHeader(
                          // decoration: BoxDecoration(color: Colors.pink[500]),
                          decoration: BoxDecoration(
                            color: (Colors.pink[400]),
                          ),
                          child: Column(
                            children: [
                              CircleAvatar(
                                  radius: _alto * .065,
                                  backgroundColor: Colors.transparent,
                                  child: const Image(
                                      image: AssetImage('assets/logo_.png'))),
                              const Text(
                                'Pasteleria Pastel`arte',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              )
                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        title: const Text('Compras/nuevo ingreso'),
                        leading: const Icon(Icons.add_business_outlined),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        iconColor: Colors.teal,
                        onTap: () {
                          final prov = Provider.of<ProviderProductos>(context,
                              listen: false);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    comprasPage(provforaneo: prov),
                              ));
                        },
                      ),
                      ListTile(
                        title: const Text('Proveedores'),
                        leading: const Icon(Icons.dashboard_customize_sharp),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        iconColor: Colors.teal,
                        onTap: () {
                          final prov = Provider.of<ProviderProveedores>(context,
                              listen: false);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    proveedoresPage_query(provforaneo: prov),
                              ));
                        },
                      ),
                      ListTile(
                        title: const Text('Productos'),
                        leading: const Icon(Icons.add_shopping_cart_sharp),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        iconColor: Colors.pink[400],
                        onTap: () {
                          final prov = Provider.of<ProviderProductos>(context,
                              listen: false);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    productosPage_query(provforaneo: prov),
                              ));
                        },
                      ),
                      ListTile(
                        title: const Text('Categorias'),
                        leading: const Icon(Icons.add_task),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        iconColor: Colors.pink[400],
                        onTap: () {
                          final prov = Provider.of<ProviderCategorias>(context,
                              listen: false);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    categoriasPage_query(provforaneo: prov),
                              ));
                        },
                      ),
                      ListTile(
                        title: const Text('Clientes'),
                        leading:
                            const Icon(Icons.supervised_user_circle_outlined),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        iconColor: Colors.pink[400],
                        onTap: () {
                          final prov = Provider.of<ProviderClientes>(context,
                              listen: false);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    clientesPage_query(provforaneo: prov),
                              ));
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Center(
                          child: Text(
                        'Reportes',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w200),
                      )),
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        title: const Text('Rpt. de ordenes'),
                        leading: const Icon(Icons.content_paste_search_rounded),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        iconColor: Colors.teal[400],
                        onTap: () {
                          Navigator.pushNamed(context, "rpt_ordenesporfecha");
                        },
                      ),
                      ListTile(
                        title: const Text(
                            'Rpt. productos mas vendidos con util. promedio'),
                        leading: const Icon(Icons.content_paste_search_rounded),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        iconColor: Colors.teal[400],
                        onTap: () =>
                            Navigator.pushNamed(context, "rpt_prodmasvendidos"),
                      ),
                      ListTile(
                        title: const Text(
                            'Rpt. productos con porcentaje de utilidad'),
                        leading: const Icon(Icons.content_paste_search_rounded),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        iconColor: Colors.teal[400],
                        onTap: () =>
                            Navigator.pushNamed(context, "rpt_produtilidad"),
                      ),
                      ListTile(
                        title: const Text('Rpt. productos con bajo stock'),
                        leading: const Icon(Icons.content_paste_search_rounded),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        iconColor: Colors.teal[400],
                        onTap: () =>
                            Navigator.pushNamed(context, "rpt_prodmin"),
                      ),
                      ListTile(
                          title: const Text(
                              'Rpt. nuevas compras/entrada de productos'),
                          leading: const Icon(Icons.add_business_rounded),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          iconColor: Colors.teal[400],
                          onTap: () => Navigator.pushNamed(
                              context, "rpt_comprasporfecha")),
                      ListTile(
                        title: const Text('Enviar R. hacia correo'),
                        leading: const Icon(Icons.email),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        iconColor: Colors.teal[400],
                        onTap: () async {
                          try {
                            // final zipFile = File(paths);
                            // ZipFile.createFromDirectory(
                            //     sourceDir: dataDir, zipFile: zipFile, recurseSubDirs: true);
                            // log(zipFile.path);
                            // log(dataDir.path);
                            DBProvider.db.getdatabase();
                            final Email email = Email(
                              body: 'Se adjunta db :',
                              subject: 'Backup db app',
                              recipients: ['amolina5678@hotmail.com'],
                              // cc: ['cc@examplez.com'],
                              // bcc: ['bcc@examplez.com'],
                              // attachmentPaths: ['/path/to/attachment.zip'],
                              attachmentPaths: [DBProvider.db.parche()],
                              isHTML: false,
                            );
                            await FlutterEmailSender.send(email);
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                    ],
                  )
                : Container(
                    color: Colors.white,
                    height: _alto,
                    child: ListView(padding: EdgeInsets.zero, children: [
                      Container(
                        height: _alto * .25,
                        child: DrawerHeader(
                          // decoration: BoxDecoration(color: Colors.pink[500]),
                          decoration: BoxDecoration(
                            color: (Colors.pink[400]),
                          ),
                          child: Column(
                            children: [
                              CircleAvatar(
                                  radius: _alto * .065,
                                  backgroundColor: Colors.transparent,
                                  child: const Image(
                                      image: AssetImage('assets/logo_.png'))),
                              const Text(
                                'Pasteleria Pastel`arte',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              )
                            ],
                          ),
                        ),
                      ),

                      //aqui empieza
                      Container(
                        height: _alto * .7,
                        color: (Colors.white),
                        child: Column(
                          children: [
                            Container(
                                width: _ancho * .7,
                                height: _alto * .08,
                                color: Colors.white,
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.black26),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                    width: 1,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: _ancho * .65,
                                          child: TextFormField(
                                            obscureText: true,
                                            onFieldSubmitted: (value) {
                                              if (_controllervalidator.text ==
                                                  "201094") {
                                                log("password ok");
                                                const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                                setState(() {
                                                  validator = true;
                                                  // Navigator.pop(context);
                                                });
                                              } else {
                                                intentos += 1;
                                                Center(
                                                  child: Text(
                                                      "Acabas de usar " +
                                                          intentos.toString() +
                                                          " de 3 intentos."),
                                                );
                                              }
                                              _controllervalidator.clear();
                                            },

                                            controller: _controllervalidator,
                                            // onChanged: (value) {
                                            //   setState(() {
                                            //     widget._controllerfield.text = value.toString();
                                            //   });
                                            // },
                                            style: const TextStyle(
                                                color: Colors.black54),
                                            keyboardType: TextInputType.number,
                                            enabled: true,

                                            // decoration: InputDecoration(hintText: _hinttext, label: Text('data')),

                                            decoration: const InputDecoration(
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              prefixIcon: Icon(
                                                Icons.key,
                                                color: Colors.teal,
                                              ),

                                              // icon: Icon(Icons.search),
                                              hintText: "Ingrese la contraseña",
                                              // label: Text('data'),
                                              // labelText: 'Ingrese nombre del producto.',
                                              // border: const OutlineInputBorder(
                                              //     borderRadius: BorderRadius.all(Radius.circular(5))),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )))
                          ],
                        ),
                      )
                    ]),
                  )),
      ),
      body: Container(
        width: _ancho,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Image(
                    width: _ancho * .57,
                    image: const AssetImage('assets/logo.png'))),
            SizedBox(
              height: 20,
            ),
            seleccion(
              ancho: _ancho * .9,
              alto: _alto * .1,
              primaryColor: Colors.pink.shade100,
              secondaryColor: Colors.pink,
              shadowColor: Colors.pink.shade900,
              image: 'assets/logo_.png',
              title: 'Ordenes',
              subtit: 'Registra e imprime una n. orden.',
              imagewidth: 44,
              ruta: 'ordenes',
            ),
            // SizedBox(
            //   height: 20,
            // ),
            // seleccion(
            //   ancho: _ancho * .9,
            //   alto: _alto * .1,
            //   primaryColor: Colors.pink.shade100,
            //   secondaryColor: Colors.pink,
            //   shadowColor: Colors.pink.shade900,
            //   image: 'assets/logo_.png',
            //   title: 'Proformas',
            //   subtit: 'Generar una cotización.',
            //   imagewidth: 44,
            //   ruta: 'impresora',
            // ),
          ],
        ),
      ),
    );
  }
}

class casillavalidator extends StatefulWidget {
  const casillavalidator(
      {Key? key,
      required String clase,
      required double ancho,
      required TextEditingController controllerfield,
      required String hinttext,
      required TextInputType textinputype,
      required bool habilitado,
      required dynamic prov,
      required String busc})
      : _clase = clase,
        _ancho = ancho,
        _controllerfield = controllerfield,
        _hinttext = hinttext,
        _textinputtype = textinputype,
        _enable = habilitado,
        _prov = prov,
        _busc = busc,
        super(key: key);
  final String _clase;
  final double _ancho;
  final TextEditingController _controllerfield;
  final String _hinttext;
  final TextInputType _textinputtype;
  final bool _enable;
  final dynamic _prov;
  final String _busc;

  @override
  State<casillavalidator> createState() => _casillavalidatorState();
}

class _casillavalidatorState extends State<casillavalidator> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black26),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        width: 1,
        child: Row(
          children: [
            SizedBox(
              width: widget._ancho * .65,
              child: TextFormField(
                obscureText: true,
                onFieldSubmitted: (value) {
                  switch (widget._clase) {
                    case "_validator":
                      if (widget._controllerfield.value == "1234") {}

                      break;
                  }

                  //     break;
                  //   case "categorias":
                  //     widget._prov.ObtenerCategoria(
                  //         '%${widget._controllerfield.text}%');
                  //     break;
                  //   case "clientes":
                  //     widget._prov
                  //         .ObtenerClientes('%${widget._controllerfield.text}%');
                  //     break;

                  //   default:
                  // }
                },

                controller: widget._controllerfield,
                // onChanged: (value) {
                //   setState(() {
                //     widget._controllerfield.text = value.toString();
                //   });
                // },
                style: const TextStyle(color: Colors.black54),
                keyboardType: widget._textinputtype,
                enabled: widget._enable,

                // decoration: InputDecoration(hintText: _hinttext, label: Text('data')),

                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  prefixIcon: const Icon(Icons.key),

                  // icon: Icon(Icons.search),
                  hintText: widget._hinttext,
                  // label: Text('data'),
                  // labelText: 'Ingrese nombre del producto.',
                  // border: const OutlineInputBorder(
                  //     borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              ),
            ),
          ],
        ));
  }
}

class seleccion extends StatelessWidget {
  Color primaryColor;
  Color secondaryColor;
  Color shadowColor;
  String image;
  String title;
  double imagewidth;
  String ruta;
  String subtit;
  seleccion(
      {Key? key,
      required this.ancho,
      required this.alto,
      required this.primaryColor,
      required this.secondaryColor,
      required this.shadowColor,
      required this.image,
      required this.title,
      required this.subtit,
      required this.imagewidth,
      required this.ruta})
      : super(key: key);

  final double ancho;
  final double alto;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // color: Color.fromARGB(255, 147, 218, 15),
          borderRadius: BorderRadius.circular(15.0),
          gradient: LinearGradient(colors: [primaryColor, secondaryColor]),
          boxShadow: [
            BoxShadow(
                color: shadowColor,
                blurRadius: 5.0,
                offset: const Offset(2.0, 2.0))
          ]),
      width: ancho,
      height: alto,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            title: Center(
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 23,
                    color: Colors.black45,
                    fontWeight: FontWeight.w300),
              ),
            ),
            // leading: Image(image: AssetImage(image)),
            leading: const Icon(
              Icons.add_business_rounded,
              size: 50,
              color: Colors.white70,
            ),
            subtitle: Center(
              child: Text(
                subtit,
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white70,
            ),
            onTap: () {
              if (ruta == "ordenes") {
                final prov =
                    Provider.of<ProviderProductos>(context, listen: false);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ordenPage(provforaneo: prov),
                    ));
              }
            },
          )
        ],
      ),
    );
  }
}
