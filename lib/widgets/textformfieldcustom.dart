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
            if (value == null || value.isEmpty) {
              return 'Ingresa un valor válido.';
            }
            return null;
          },
          controller: widget._controllercategoria,
          keyboardType: widget._textinputtype,
          enabled: widget._enable,
          // decoration: InputDecoration(hintText: _hinttext, label: Text('data')),

          decoration: InputDecoration(
            // hintText: widget._hinttext,
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

class textformfieldsintitle extends StatelessWidget {
  const textformfieldsintitle(
      {Key? key,
      required double ancho,
      required TextEditingController controllerfield,
      required String hinttext,
      required TextInputType textinputype,
      required bool habilitado})
      : _ancho = ancho,
        _controllerfield = controllerfield,
        _hinttext = hinttext,
        _textinputtype = textinputype,
        _enable = habilitado,
        super(key: key);

  final double _ancho;
  final TextEditingController _controllerfield;
  final String _hinttext;
  final TextInputType _textinputtype;
  final bool _enable;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black26),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        width: _ancho,
        child: Row(
          children: [
            SizedBox(
              width: _ancho * .8,
              child: TextFormField(
                controller: _controllerfield,
                style: const TextStyle(color: Colors.black54),
                keyboardType: _textinputtype,
                enabled: _enable,
                // decoration: InputDecoration(hintText: _hinttext, label: Text('data')),

                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  prefixIcon: const Icon(Icons.search),

                  // icon: Icon(Icons.search),
                  hintText: _hinttext,
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
