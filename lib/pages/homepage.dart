import 'dart:developer';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:firebase_orders_flutter/pages/impresoraAlertDialog.dart';
import 'package:firebase_orders_flutter/pages/OrdenPage.dart';
import 'package:firebase_orders_flutter/pages/productosPage_query.dart';
import 'package:firebase_orders_flutter/pages/testprint.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../controllers/controllerProductos.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _ancho = MediaQuery.of(context).size.width;
    double _alto = MediaQuery.of(context).size.height;
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
              icon: const Icon(
                Icons.bluetooth,
              )),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.exit_to_app_outlined,
                  color: Colors.pink.shade500,
                  size: 29,
                )),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              // decoration: BoxDecoration(color: Colors.pink[500]),
              decoration: BoxDecoration(
                color: Color.fromARGB(251, 80, 199, 214),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                      radius: _alto * .065,
                      backgroundColor: Colors.transparent,
                      child:
                          const Image(image: AssetImage('assets/logo_.png'))),
                  const Text(
                    'Pasteleria Pastel`arte',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  )
                ],
              ),
            ),
            ListTile(
              title: const Text('Nuevo ingreso'),
              leading: const Icon(Icons.add_business_outlined),
              trailing: const Icon(Icons.arrow_forward_ios),
              iconColor: Colors.teal,
              onTap: () => Navigator.pushNamed(context, 'images'),
            ),
            ListTile(
              title: const Text('Productos'),
              leading: const Icon(Icons.add_shopping_cart_sharp),
              trailing: const Icon(Icons.arrow_forward_ios),
              iconColor: Colors.pink[400],
              onTap: () {
                final prov =
                    Provider.of<ProviderProductos>(context, listen: false);
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
              onTap: () {},
            ),
            ListTile(
              title: const Text('Clientes'),
              leading: const Icon(Icons.supervised_user_circle_outlined),
              trailing: const Icon(Icons.arrow_forward_ios),
              iconColor: Colors.pink[400],
              onTap: () => Navigator.pop(context),
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
              title: const Text('Rpt. ordenes'),
              leading: const Icon(Icons.content_paste_search_rounded),
              trailing: const Icon(Icons.arrow_forward_ios),
              iconColor: Colors.teal[400],
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Rpt. proformas'),
              leading: const Icon(Icons.content_paste_search_rounded),
              trailing: const Icon(Icons.arrow_forward_ios),
              iconColor: Colors.teal[400],
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Rpt. nuevos ingresos'),
              leading: const Icon(Icons.add_business_rounded),
              trailing: const Icon(Icons.arrow_forward_ios),
              iconColor: Colors.teal[400],
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Rpt. productos'),
              leading: const Icon(Icons.add_business_rounded),
              trailing: const Icon(Icons.arrow_forward_ios),
              iconColor: Colors.teal[400],
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
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
              primaryColor: Colors.teal.shade100,
              secondaryColor: Colors.teal,
              shadowColor: Colors.teal.shade900,
              image: 'assets/logo_.png',
              title: 'Ordenes',
              subtit: 'Agregar o modificar ordenes.',
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
            title: Text(
              title,
              style: const TextStyle(
                  fontSize: 23,
                  color: Colors.black54,
                  fontWeight: FontWeight.w300),
            ),
            leading: Image(image: AssetImage(image)),
            subtitle: Text(
              subtit,
              style: const TextStyle(fontWeight: FontWeight.w300),
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
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
