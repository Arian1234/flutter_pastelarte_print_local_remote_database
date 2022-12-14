import 'dart:developer';
import 'package:firebase_orders_flutter/controllers/controllerProductos.dart';
import 'package:firebase_orders_flutter/helpers/impresora/printerenum.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'dart:io';

///Test printing
class TestPrint {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  sample(List listado, ProviderProductos prov, int itemscount, String total,
      String unix) async {
    //image max 300px X 300px

    ///image from File path
    String filename = 'logo.png';
    ByteData bytesData = await rootBundle.load("assets/logo_.png");
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = await File('$dir/$filename').writeAsBytes(bytesData.buffer
        .asUint8List(bytesData.offsetInBytes, bytesData.lengthInBytes));

    ///image from Asset
    // ByteData bytesAsset = await rootBundle.load("assets/logo.png");
    // Uint8List imageBytesFromAsset = bytesAsset.buffer
    //     .asUint8List(bytesAsset.offsetInBytes, bytesAsset.lengthInBytes);

    ///image from Network
    // var response = await http.get(Uri.parse(
    //     "https://raw.githubusercontent.com/kakzaki/blue_thermal_printer/master/example/assets/images/yourlogo.png"));
    // Uint8List bytesNetwork = response.bodyBytes;
    // Uint8List imageBytesFromNetwork = bytesNetwork.buffer
    //     .asUint8List(bytesNetwork.offsetInBytes, bytesNetwork.lengthInBytes);

    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        bluetooth.printNewLine();
        bluetooth.printCustom(
            "NOTA DE VENTA", Size.medium.val, Align.center.val);
        bluetooth.printCustom(
            "CONTACTO : 930 621 387", Size.medium.val, Align.center.val);
        bluetooth.printNewLine();
        bluetooth.printCustom("NRO NV: $unix", Size.medium.val, Align.left.val);
        bluetooth.printCustom(
            "CLIENTE: VARIOS", Size.medium.val, Align.left.val);
        // bluetooth.printImage(file.path); //path of your image/logo
        bluetooth.printCustom("FECHA: " + DateTime.now().toString(),
            Size.medium.val, Align.left.val);
        // bluetooth.printImageBytes(imageBytesFromAsset); //image from Asset
        // bluetooth.printImageBytes(imageBytesFromNetwork); //image from Network
        bluetooth.printCustom("__________________________________________",
            Size.medium.val, Align.center.val);
        bluetooth.print4Column(
            "CANT", "DESCRIP.", "P.U.", "TOTAL", Size.medium.val,
            format: "%-6s %10s %6s %7s %n");
        for (var i = 0; i < itemscount; i++) {
          if (listado[i] > 0) {
            var sd = double.parse(listado[i].toString()) *
                prov.prod[i].ventaprod!.toDouble();
            bluetooth.print4Column(
                listado[i].toString(),
                prov.prod[i].nombprod.toString(),
                prov.prod[i].ventaprod.toString(),
                sd.toString(),
                Size.medium.val,
                format: "%-2s %14s %6s %7s %n");
          }
        }
        listado.clear();
        log("TERMINE DE IMPRIMIR");
        bluetooth.printNewLine();
        bluetooth.printCustom(
            "Total : $total sol(es).", Size.bold.val, Align.left.val);
        bluetooth.printNewLine();
        bluetooth.printCustom(
            "Mire nuestros trabajos.", Size.bold.val, Align.center.val);
        bluetooth.printQRcode(
            "https://www.pinterest.es/milagrosrociopachastasayco/",
            370,
            200,
            Align.right.val);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printCustom("Gracias", Size.boldMedium.val, Align.center.val);
        bluetooth.printCustom(
            "por su compra", Size.boldMedium.val, Align.center.val);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();

        bluetooth
            .paperCut(); //some printer not supported (sometime making image not centered)

      }
    });
  }

  test() async {
    //image max 300px X 300px
    ///image from File path
    String filename = 'logo.png';
    ByteData bytesData = await rootBundle.load("assets/logo_.png");
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = await File('$dir/$filename').writeAsBytes(bytesData.buffer
        .asUint8List(bytesData.offsetInBytes, bytesData.lengthInBytes));
    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        bluetooth.printNewLine();
        bluetooth.printCustom("Exito al conectar el dispositivo bluetooth.",
            Size.boldLarge.val, Align.center.val);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printImage(file.path);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printCustom("FECHA: " + DateTime.now().toString(),
            Size.medium.val, Align.left.val);
        bluetooth.printCustom("__________________________________________",
            Size.medium.val, Align.center.val);
        bluetooth.printCustom(
            "Mire nuestros trabajos.", Size.bold.val, Align.center.val);
        bluetooth.printQRcode(
            "https://www.pinterest.es/", 370, 200, Align.right.val);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printCustom("Gracias", Size.boldMedium.val, Align.center.val);
        bluetooth.printCustom(
            "por su compra", Size.boldMedium.val, Align.center.val);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth
            .paperCut(); //some printer not supported (sometime making image not centered)

      }
    });
  }

//   sample(String pathImage) async {
//     //SIZE
//     // 0- normal size text
//     // 1- only bold text
//     // 2- bold with medium text
//     // 3- bold with large text
//     //ALIGN
//     // 0- ESC_ALIGN_LEFT
//     // 1- ESC_ALIGN_CENTER
//     // 2- ESC_ALIGN_RIGHT
//
// //     var response = await http.get("IMAGE_URL");
// //     Uint8List bytes = response.bodyBytes;
//     bluetooth.isConnected.then((isConnected) {
//       if (isConnected == true) {
//         bluetooth.printNewLine();
//         bluetooth.printCustom("HEADER", 3, 1);
//         bluetooth.printNewLine();
//         bluetooth.printImage(pathImage); //path of your image/logo
//         bluetooth.printNewLine();
// //      bluetooth.printImageBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
//         bluetooth.printLeftRight("LEFT", "RIGHT", 0);
//         bluetooth.printLeftRight("LEFT", "RIGHT", 1);
//         bluetooth.printLeftRight("LEFT", "RIGHT", 1, format: "%-15s %15s %n");
//         bluetooth.printNewLine();
//         bluetooth.printLeftRight("LEFT", "RIGHT", 2);
//         bluetooth.printLeftRight("LEFT", "RIGHT", 3);
//         bluetooth.printLeftRight("LEFT", "RIGHT", 4);
//         bluetooth.printNewLine();
//         bluetooth.print3Column("Col1", "Col2", "Col3", 1);
//         bluetooth.print3Column("Col1", "Col2", "Col3", 1,
//             format: "%-10s %10s %10s %n");
//         bluetooth.printNewLine();
//         bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", 1);
//         bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", 1,
//             format: "%-8s %7s %7s %7s %n");
//         bluetooth.printNewLine();
//         String testString = " ????????????-H-??????";
//         bluetooth.printCustom(testString, 1, 1, charset: "windows-1250");
//         bluetooth.printLeftRight("??tevilka:", "18000001", 1,
//             charset: "windows-1250");
//         bluetooth.printCustom("Body left", 1, 0);
//         bluetooth.printCustom("Body right", 0, 2);
//         bluetooth.printNewLine();
//         bluetooth.printCustom("Thank You", 2, 1);
//         bluetooth.printNewLine();
//         bluetooth.printQRcode("Insert Your Own Text to Generate", 200, 200, 1);
//         bluetooth.printNewLine();
//         bluetooth.printNewLine();
//         bluetooth.paperCut();
//       }
//     });
//   }
}
