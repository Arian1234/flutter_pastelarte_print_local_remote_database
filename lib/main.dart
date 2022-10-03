import 'package:firebase_orders_flutter/controllers/controllerCategorias.dart';
import 'package:firebase_orders_flutter/controllers/controllerClientes.dart';
import 'package:firebase_orders_flutter/controllers/controllerDetaorden.dart';
import 'package:firebase_orders_flutter/controllers/controllerOrdenes.dart';
import 'package:firebase_orders_flutter/controllers/controllerProductos.dart';
import 'package:firebase_orders_flutter/pages/categoriasPage_insert.dart';
import 'package:firebase_orders_flutter/pages/clientesPage_insert.dart';
import 'package:firebase_orders_flutter/pages/homepage.dart';
import 'package:firebase_orders_flutter/pages/productosPage_insert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
  // const MyApp();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProviderProductos()),
        ChangeNotifierProvider(create: (context) => ProviderOrdenes()),
        ChangeNotifierProvider(create: (context) => ProviderCategorias()),
        ChangeNotifierProvider(create: (context) => ProviderDetaorden()),
        ChangeNotifierProvider(create: (context) => ProviderClientes()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pastelarte',
        home: const homePage(),
        routes: {
          'home': (context) => const homePage(),
          'productos_insert': (context) => const productosPage_insert(),
          'categorias_insert': (context) => const categoriasPage_insert(),
          'clientes_insert': (context) => const clientesPage_insert(),
        },
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(251, 80, 199, 214),
          secondary: Colors.pink.shade300,
        )),
      ),
    );
  }
}
