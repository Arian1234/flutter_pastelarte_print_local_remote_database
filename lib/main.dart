import 'package:firebase_orders_flutter/controllers/controllerDetaorden.dart';
import 'package:firebase_orders_flutter/controllers/controllerOrdenes.dart';
import 'package:firebase_orders_flutter/controllers/controllerProductos.dart';
import 'package:firebase_orders_flutter/pages/homepage.dart';
import 'package:firebase_orders_flutter/pages/productosPage_insert.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

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
        ChangeNotifierProvider(create: (context) => ProviderProductos()),
        ChangeNotifierProvider(create: (context) => ProviderOrdenes()),
        ChangeNotifierProvider(create: (context) => ProviderDetaorden())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pastelarte',
        home: const homePage(),
        routes: {
          'home': (context) => const homePage(),
          'productos_insert': (context) => productosPage_insert(),
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
