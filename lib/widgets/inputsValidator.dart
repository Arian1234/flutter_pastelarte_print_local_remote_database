import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class textFormField_inputDecimal extends StatelessWidget {
  textFormField_inputDecimal({
    Key? key,
    required this.ancho,
    required this.controller,
    required this.label,
    required this.hint,
    this.enable,
  }) : super(key: key);
  final double ancho;
  final TextEditingController controller;
  final String label;
  bool? enable = true;
  String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ancho,
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(
              RegExp(r'^(?=\D*(?:\d\D*){1,9}$)\d+(?:\.\d{0,2})?$'))
        ],
        controller: controller,
        enabled: enable,
        keyboardType: TextInputType.number,
        validator: (value) {
          String valor = value!.toString().trim();
          if (valor.isEmpty) {
            return "Casillero vacío.";
          } else {
            if (!valor.contains(
                RegExp(r'^(?=\D*(?:\d\D*){1,9}$)\d+(?:\.\d{0,2})?$'))) {
              return "Caracteres no válidos.";
            }
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hint,
          labelText: label.toString(),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
      ),
    );
  }
}

class textFormField_inputText extends StatelessWidget {
  textFormField_inputText(
      {Key? key,
      required this.ancho,
      required this.controller,
      required this.label,
      required this.hint,
      this.enable})
      : super(key: key);
  final double ancho;
  final TextEditingController controller;
  final String label;
  bool? enable = true;
  String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ancho,
      child: TextFormField(
        controller: controller,
        enabled: enable,
        keyboardType: TextInputType.text,
        validator: (value) {
          String valor = value!.toString().trim();
          if (valor.isEmpty) {
            return "Casillero vacío.";
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hint,
          labelText: label.toString(),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
      ),
    );
  }
}

class textFormField_inputInteger extends StatelessWidget {
  textFormField_inputInteger(
      {Key? key,
      required this.ancho,
      required this.controller,
      required this.label,
      required this.hint,
      this.enable})
      : super(key: key);
  final double ancho;
  final TextEditingController controller;
  final String label;
  bool? enable = true;
  String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ancho,
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(
              RegExp(r'^(?=\D*(?:\d\D*){1,12}$)\d+?$'))
        ],
        controller: controller,
        enabled: enable,
        keyboardType: TextInputType.number,
        validator: (value) {
          String valor = value!.toString().trim();
          if (valor.isEmpty) {
            return "Casillero vacío.";
          } else {
            if (!valor.contains(RegExp(r'^(?=\D*(?:\d\D*){1,12}$)\d+?$'))) {
              return "Caracteres no válidos.";
            }
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hint,
          labelText: label.toString(),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
      ),
    );
  }
}

class textFormField_inputCod extends StatelessWidget {
  const textFormField_inputCod({
    Key? key,
    required this.ancho,
    required this.controller,
  }) : super(key: key);
  final double ancho;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ancho,
      child: TextFormField(
        controller: controller,
        enabled: false,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: 'Código',
          labelText: 'Código',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
      ),
    );
  }
}
