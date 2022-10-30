import 'package:firebase_orders_flutter/pages/ComprasPage%20_BACKUP.dart';
import 'package:flutter/material.dart';

class textformfield extends StatefulWidget {
  const textformfield(
      {Key? key,
      required double ancho,
      required TextEditingController controllercategoria,
      // required String hinttext,
      required TextInputType textinputype,
      required bool habilitado,
      required String label})
      : _ancho = ancho,
        _controllercategoria = controllercategoria,
        // _hinttext = hinttext,
        _textinputtype = textinputype,
        _enable = habilitado,
        _labeltext = label,
        super(key: key);

  final double _ancho;
  final TextEditingController _controllercategoria;
  // final String _hinttext;
  final TextInputType _textinputtype;
  final bool _enable;
  final String _labeltext;

  @override
  State<textformfield> createState() => _textformfieldState();
}

class _textformfieldState extends State<textformfield> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(border: Border.all(width: 1)),
      width: widget._ancho,
      child: SizedBox(
        width: widget._ancho * .9,
        child: TextFormField(
          validator: (value) {
            if (widget._enable == true) {
              String v = value!.trim();
              if (v.isEmpty) {
                return 'Ingresa un valor válido.';
              } else {
                if ((widget._textinputtype == TextInputType.number &&
                        value.contains(',')) ||
                    widget._textinputtype == TextInputType.number &&
                        value.contains('-')) {
                  return 'Usar punto,no coma,ni guiones.';
                } else {
                  if ((v.indexOf('.') != v.lastIndexOf('.')) ||
                      v.indexOf(',') != v.lastIndexOf(',') ||
                      v.indexOf('-') != v.lastIndexOf('-')) {
                    return 'Usar solo un (1) punto.';
                  }
                  return null;
                }
              }
            }
          },
          controller: widget._controllercategoria,
          keyboardType: widget._textinputtype,
          enabled: widget._enable,
          // decoration: InputDecoration(hintText: _hinttext, label: Text('data')),

          decoration: InputDecoration(
            // hintText: "antiguo",
            // label: Text('data'),
            labelText: widget._labeltext,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
      ),
    );
  }
}

class textformfield_hintText extends StatefulWidget {
  const textformfield_hintText(
      {Key? key,
      required double ancho,
      required TextEditingController controllercategoria,
      required String hinttext,
      required TextInputType textinputype,
      required bool habilitado,
      required String label})
      : _ancho = ancho,
        _controllercategoria = controllercategoria,
        _hinttext = hinttext,
        _textinputtype = textinputype,
        _enable = habilitado,
        _labeltext = label,
        super(key: key);

  final double _ancho;
  final TextEditingController _controllercategoria;
  final String _hinttext;
  final TextInputType _textinputtype;
  final bool _enable;
  final String _labeltext;

  @override
  State<textformfield_hintText> createState() => textformfield_hintTextState();
}

class textformfield_hintTextState extends State<textformfield_hintText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(border: Border.all(width: 1)),
      width: widget._ancho,
      child: SizedBox(
        width: widget._ancho * .9,
        child: TextFormField(
          validator: (value) {
            if (widget._enable == true) {
              String v = value!.trim();
              if (v.isEmpty) {
                return 'Ingresa un valor válido.';
              } else {
                if ((widget._textinputtype == TextInputType.number &&
                        value.contains(',')) ||
                    widget._textinputtype == TextInputType.number &&
                        value.contains('-')) {
                  return 'Usar punto,no coma,ni guiones.';
                } else {
                  if ((v.indexOf('.') != v.lastIndexOf('.')) ||
                      v.indexOf(',') != v.lastIndexOf(',') ||
                      v.indexOf('-') != v.lastIndexOf('-')) {
                    return 'Usar solo un (1) punto.';
                  }
                  return null;
                }
              }
            }
          },
          controller: widget._controllercategoria,
          keyboardType: widget._textinputtype,
          enabled: widget._enable,
          // decoration: InputDecoration(hintText: _hinttext, label: Text('data')),

          decoration: InputDecoration(
            hintText: widget._hinttext,
            // label: Text('data'),
            labelText: widget._labeltext,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
      ),
    );
  }
}

class textformfieldsintitle extends StatefulWidget {
  const textformfieldsintitle(
      {Key? key,
      required String clase,
      required double ancho,
      required TextEditingController controllerfield,
      required String hinttext,
      required TextInputType textinputype,
      required bool habilitado,
      required dynamic prov})
      : _clase = clase,
        _ancho = ancho,
        _controllerfield = controllerfield,
        _hinttext = hinttext,
        _textinputtype = textinputype,
        _enable = habilitado,
        _prov = prov,
        super(key: key);

  final String _clase;
  final double _ancho;
  final TextEditingController _controllerfield;
  final String _hinttext;
  final TextInputType _textinputtype;
  final bool _enable;
  final dynamic _prov;

  @override
  State<textformfieldsintitle> createState() => _textformfieldsintitleState();
}

class _textformfieldsintitleState extends State<textformfieldsintitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black26),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        width: widget._ancho,
        child: Row(
          children: [
            SizedBox(
              width: widget._ancho * .8,
              child: TextFormField(
                onFieldSubmitted: (value) {
                  switch (widget._clase) {
                    case "productos":
                      widget._prov
                          .ObtenerProducto('%${widget._controllerfield.text}%');

                      break;

                    case "categorias":
                      widget._prov.obtenerCategoria(
                          '%${widget._controllerfield.text}%');
                      break;
                    case "clientes":
                      widget._prov
                          .ObtenerClientes('%${widget._controllerfield.text}%');
                      break;
                    case "proveedores":
                      widget._prov.ObtenerProveedores(
                          '%${widget._controllerfield.text}%');
                      break;

                    default:
                  }
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
                  prefixIcon: const Icon(Icons.search),

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
