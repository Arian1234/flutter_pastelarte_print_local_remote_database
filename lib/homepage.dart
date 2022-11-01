import 'dart:developer';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_orders_flutter/controllers/controllerCategorias.dart';
import 'package:firebase_orders_flutter/controllers/controllerClientes.dart';
import 'package:firebase_orders_flutter/controllers/controllerProveedores.dart';
import 'package:firebase_orders_flutter/database/db_dbprovider.dart';
import 'package:firebase_orders_flutter/pages/ComprasPage.dart';
import 'package:firebase_orders_flutter/pages/categoriasPage_query.dart';
import 'package:firebase_orders_flutter/pages/clientesPage_query.dart';
import 'package:firebase_orders_flutter/pages/OrdenPage.dart';
import 'package:firebase_orders_flutter/pages/productosPage_query.dart';
import 'package:firebase_orders_flutter/pages/proveedoresPage_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:provider/provider.dart';
import 'controllers/controllerProductos.dart';
import 'helpers/impresora/impresoraAlertDialog.dart';

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
    double ancho = MediaQuery.of(context).size.width;
    double alto = MediaQuery.of(context).size.height;

    //
    //EMPIEZA EL HOMEPAGE
    //
    return WillPopScope(
      onWillPop: () => salir(context),
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(alto * .07),
            child: appBarHomePage(context, alto, ancho)),
        drawer: SlideInLeft(
          child: Drawer(
              elevation: 1,
              child: validator
                  ? listViewOpcionesDrawer(alto: alto)
                  : Container(
                      color: Colors.white,
                      height: alto,
                      child: ListView(padding: EdgeInsets.zero, children: [
                        Container(
                          height: alto * .25,
                          child: drawerHeaderLogin(alto),
                        ),

                        //aqui empieza
                        drawerDetalleLogin(alto, ancho)
                      ]),
                    )),
        ),
        body: body(ancho, alto),
      ),
    );
  }

// METODOS
  SizedBox body(double ancho, double alto) {
    return SizedBox(
      width: ancho,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Image(
                  width: ancho * .57,
                  image: const AssetImage('assets/logo.png'))),
          const SizedBox(
            height: 20,
          ),
          seleccion(
            ancho: ancho * .9,
            alto: alto * .1,
            primaryColor: Colors.pink.shade200,
            secondaryColor: Colors.pink,
            shadowColor: Colors.pink.shade900,
            image: 'assets/logo_.png',
            title: 'Nueva orden',
            subtit: 'Registra e imprime una n. orden.',
            imagewidth: 44,
            ruta: 'ordenes',
          ),
        ],
      ),
    );
  }

  AppBar appBarHomePage(BuildContext context, double alto, double ancho) {
    return AppBar(
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
                      alto: alto * .2,
                      ancho: ancho * .8,
                    );
                  });
            },
            icon: const Icon(Icons.bluetooth)),
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
    );
  }

  DrawerHeader drawerHeaderLogin(double alto) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: (Colors.pink[400]),
      ),
      child: Column(
        children: [
          CircleAvatar(
              radius: alto * .065,
              backgroundColor: Colors.transparent,
              child: const Image(image: AssetImage('assets/logo_.png'))),
          const Text(
            'Pasteleria Pastel`arte',
            style: TextStyle(color: Colors.white, fontSize: 17),
          )
        ],
      ),
    );
  }

  Container drawerDetalleLogin(double alto, double ancho) {
    return Container(
      height: alto * .7,
      color: (Colors.white),
      child: Column(
        children: [
          Container(
              width: ancho * .7,
              height: alto * .08,
              color: Colors.white,
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black26),
                      borderRadius: const BorderRadius.all(Radius.circular(5))),
                  width: 1,
                  child: Row(
                    children: [
                      SizedBox(
                        width: ancho * .65,
                        child: TextFormField(
                          obscureText: true,
                          onFieldSubmitted: (value) {
                            if (_controllervalidator.text == "201094") {
                              log("password ok");
                              const Center(
                                child: CircularProgressIndicator(),
                              );
                              setState(() {
                                validator = true;
                                // Navigator.pop(context);
                              });
                            } else {
                              intentos += 1;
                              Center(
                                child: Text(
                                    "Acabas de usar $intentos de 3 intentos."),
                              );
                            }
                            _controllervalidator.clear();
                          },
                          controller: _controllervalidator,
                          style: const TextStyle(color: Colors.black54),
                          keyboardType: TextInputType.number,
                          enabled: true,
                          decoration: const InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.key,
                              color: Colors.teal,
                            ),
                            hintText: "Ingrese la contraseña",
                          ),
                        ),
                      ),
                    ],
                  )))
        ],
      ),
    );
  }
}

class listViewOpcionesDrawer extends StatelessWidget {
  const listViewOpcionesDrawer({
    Key? key,
    required this.alto,
  }) : super(key: key);

  final double alto;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        SizedBox(
          height: alto * .25,
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: (Colors.pink[400]),
            ),
            child: Column(
              children: [
                CircleAvatar(
                    radius: alto * .065,
                    backgroundColor: Colors.transparent,
                    child: const Image(image: AssetImage('assets/logo_.png'))),
                const Text(
                  'Pasteleria Pastel`arte',
                  style: TextStyle(color: Colors.white, fontSize: 17),
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
            final prov = Provider.of<ProviderProductos>(context, listen: false);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => comprasPage(provforaneo: prov),
                ));
          },
        ),
        ListTile(
          title: const Text('Proveedores'),
          leading: const Icon(Icons.dashboard_customize_sharp),
          trailing: const Icon(Icons.arrow_forward_ios),
          iconColor: Colors.teal,
          onTap: () {
            final prov =
                Provider.of<ProviderProveedores>(context, listen: false);
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
            final prov = Provider.of<ProviderProductos>(context, listen: false);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => productosPage_query(provforaneo: prov),
                ));
          },
        ),
        ListTile(
          title: const Text('Categorias'),
          leading: const Icon(Icons.add_task),
          trailing: const Icon(Icons.arrow_forward_ios),
          iconColor: Colors.pink[400],
          onTap: () {
            final prov =
                Provider.of<ProviderCategorias>(context, listen: false);
            prov.cat.clear();
            prov.obtenerCategoria('%%');

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const categoriasPage_query(),
                ));
          },
        ),
        ListTile(
          title: const Text('Clientes'),
          leading: const Icon(Icons.supervised_user_circle_outlined),
          trailing: const Icon(Icons.arrow_forward_ios),
          iconColor: Colors.pink[400],
          onTap: () {
            final prov = Provider.of<ProviderClientes>(context, listen: false);
            prov.clie.clear();
            prov.obtenerClientes("%%");
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const clientesPage_query(),
                ));
          },
        ),
        const SizedBox(
          height: 10,
        ),
        const Center(
            child: Text(
          'Reportes',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w200),
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
          title: const Text('Rpt. productos mas vendidos con util. promedio'),
          leading: const Icon(Icons.content_paste_search_rounded),
          trailing: const Icon(Icons.arrow_forward_ios),
          iconColor: Colors.teal[400],
          onTap: () => Navigator.pushNamed(context, "rpt_prodmasvendidos"),
        ),
        ListTile(
          title: const Text('Rpt. productos con porcentaje de utilidad'),
          leading: const Icon(Icons.content_paste_search_rounded),
          trailing: const Icon(Icons.arrow_forward_ios),
          iconColor: Colors.teal[400],
          onTap: () => Navigator.pushNamed(context, "rpt_produtilidad"),
        ),
        ListTile(
          title: const Text('Rpt. productos con bajo stock'),
          leading: const Icon(Icons.content_paste_search_rounded),
          trailing: const Icon(Icons.arrow_forward_ios),
          iconColor: Colors.teal[400],
          onTap: () => Navigator.pushNamed(context, "rpt_prodmin"),
        ),
        ListTile(
            title: const Text('Rpt. nuevas compras/entrada de productos'),
            leading: const Icon(Icons.add_business_rounded),
            trailing: const Icon(Icons.arrow_forward_ios),
            iconColor: Colors.teal[400],
            onTap: () => Navigator.pushNamed(context, "rpt_comprasporfecha")),
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
    );
  }
}

Future<bool> salir(BuildContext context) async {
  showDialog<String>(
      context: context,
      barrierDismissible: false,
      barrierColor: Color.fromARGB(96, 226, 19, 133),
      builder: (BuildContext context) => const buildAlertDialogsalir());

  return false;
}

class buildAlertDialogsalir extends StatelessWidget {
  const buildAlertDialogsalir({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Text('''¿Desea salir de la aplicación?'''),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
            child: const Text("Si"),
            onPressed: () {
              Future.delayed(const Duration(milliseconds: 1000), () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              });
            }),
        TextButton(
            child: const Text("No"),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
    );
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
                    color: Colors.white70,
                    fontWeight: FontWeight.w400),
              ),
            ),
            // leading: Image(image: AssetImage(image)),
            leading: Icon(Icons.add_business_rounded,
                size: 50, color: Colors.pink[400]),
            subtitle: Center(
              child: Text(
                subtit,
                style: const TextStyle(
                  color: Colors.white70,
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
