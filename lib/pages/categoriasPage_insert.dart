import 'dart:developer';

import 'package:firebase_orders_flutter/controllers/controllerCategorias.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/textformfieldcustom.dart';

class categoriasPage_insert extends StatefulWidget {
  const categoriasPage_insert({
    Key? key,
    this.id,
    this.categ,
  }) : super(key: key);
  final String? id;
  final String? categ;

  @override
  State<categoriasPage_insert> createState() => _categoriasPage_insertState();
}

class _categoriasPage_insertState extends State<categoriasPage_insert> {
  final _formKey = GlobalKey<FormState>();
  final contr = TextEditingController();
  final valores = [];
  final _controllernombcateg = TextEditingController();
  final _controlleridcateg = TextEditingController();
  String estado = 'Nueva';

  @override
  void initState() {
    super.initState();

    if (widget.id != null) {
      _controlleridcateg.text = widget.id.toString();
      _controllernombcateg.text = widget.categ.toString();
      setState(() {
        estado = 'Actualizar';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProviderCategorias>(context, listen: true);
    final ancho = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink[400],
          elevation: 1,
          title: Text("$estado categoria"),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 15),
                child: IconButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.pink,
                                color: Colors.yellow,
                              ),
                            );
                          });

                      if (_formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        String id = _controlleridcateg.value.text.toString();
                        String nombre =
                            _controllernombcateg.value.text.toString().trim();

                        int est = 0;
                        if (widget.id != null) {
                          est = await prov.actualizarCategoria(
                              int.parse(id), nombre);
                        } else {
                          est = await prov.agregarCategoria(nombre);
                        }

                        if (est == 1) {
                          Timer(const Duration(milliseconds: 1900), () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Datos registrados/actualizados.')),
                                      
                            );
                          });
                        } else {
                          Timer(const Duration(milliseconds: 300), () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Hubo un error al intentar registrar/actualizar.')),
                            );
                          });
                        }
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    icon: Icon(
                      widget.id != null
                          ? Icons.refresh
                          : Icons.save_alt_outlined,
                      size: 30,
                    )))
          ],
        ),
        body: body(ancho));
  }

  GestureDetector body(double ancho) {
    return GestureDetector(
      child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 12, left: 12, right: 12, top: 12),
              child: SizedBox(
                width: ancho,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: ancho * .33,
                          height: ancho * .33,
                          decoration: BoxDecoration(
                              color: Colors.pink[100],
                              borderRadius: BorderRadius.circular(25)),
                          child: GestureDetector(
                              onTap: () {},
                              child: const ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                clipBehavior: Clip.antiAlias,
                                child: Image(
                                  image: AssetImage('assets/logo.png'),
                                  width: 50,
                                  fit: BoxFit.fill,
                                  // height: 400,
                                ),
                              )),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textformfield(
                          ancho: ancho * .25,
                          controllercategoria: _controlleridcateg,
                          // hinttext: '',
                          textinputype: TextInputType.text,
                          habilitado: false,
                          label: 'Codigo',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        textformfield(
                          ancho: ancho * .75,
                          controllercategoria: _controllernombcateg,
                          // hinttext: '',
                          textinputype: TextInputType.text,
                          habilitado: true,
                          label: 'Nombre de la categoria',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
