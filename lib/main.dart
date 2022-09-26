import 'package:firebase_orders_flutter/controllers/controllerProductos.dart';
import 'package:firebase_orders_flutter/pages/homepage.dart';
import 'package:firebase_orders_flutter/pages/imagenpage.dart';
import 'package:firebase_orders_flutter/pages/impresora_SQFLITE.dart';
import 'package:firebase_orders_flutter/pages/impresora.dart';
import 'package:firebase_orders_flutter/pages/loaderimage.dart';
import 'package:firebase_orders_flutter/pages/loaderimagesqflite.dart';
import 'package:firebase_orders_flutter/pages/ordenpage.dart';
import 'package:firebase_orders_flutter/pages/ordenpagesqflite.dart';
import 'package:firebase_orders_flutter/pages/productospage.dart';
import 'package:firebase_orders_flutter/pages/productospageinsert.dart';
import 'package:firebase_orders_flutter/pages/productospagesqflite.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    // FirebaseDatabase database = FirebaseDatabase.instance;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProviderProductos(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pastelarte',
        home: const homePage(),
        routes: {
          'home': (context) => const homePage(),
          'productosinsert': (context) => const productosPageInsert(),
          'productos': (context) => const productospage(),
          'images': (context) => const MyHomePage(),
          'imagenes_carga': (context) => cargadorimages(),
          // 'ordenes': (context) => ordenespagesqflite(provforaneo: prov),
          // 'impresora': (context) => impresoraSQFlite(),
          'cargadorimagessqflite': (context) => cargadorimagessqflite(),
        },
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color.fromARGB(251, 80, 199, 214),
          secondary: Colors.pink.shade300,
        )),
      ),
    );
  }
}
