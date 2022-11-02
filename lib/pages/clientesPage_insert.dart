import 'package:firebase_orders_flutter/controllers/controllerClientes.dart';
import 'package:firebase_orders_flutter/widgets/inputsValidator.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class clientesPage_insert extends StatefulWidget {
  const clientesPage_insert(
      {Key? key, this.id, this.nomb, this.doc, this.dir, this.cel})
      : super(key: key);
  final String? id;
  final String? nomb;
  final String? doc;
  final String? dir;
  final String? cel;

  @override
  State<clientesPage_insert> createState() => _clientesPage_insertState();
}

class _clientesPage_insertState extends State<clientesPage_insert> {
  final _formKey = GlobalKey<FormState>();
  final valores = [];
  final _controlleridclie = TextEditingController();
  final _controllernombclie = TextEditingController();
  final _controllerdoc = TextEditingController();
  final _controllerdir = TextEditingController();
  final _controllercel = TextEditingController();
  String estado = 'Nuevo';
  @override
  void initState() {
    super.initState();

    if (widget.id != null) {
      _controlleridclie.text = widget.id.toString();
      _controllernombclie.text = widget.nomb.toString();
      _controllerdir.text = widget.dir.toString();
      _controllercel.text = widget.cel.toString();
      _controllerdoc.text = widget.doc.toString();
      setState(() {
        estado = 'Actualizar';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProviderClientes>(context, listen: true);
    final ancho = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink[400],
          elevation: 1,
          title: Text("$estado cliente"),
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
                        String id = _controlleridclie.value.text.toString();
                        String nombre =
                            _controllernombclie.value.text.toString().trim();
                        String dir =
                            _controllerdir.value.text.toString().trim();
                        String cel =
                            _controllercel.value.text.toString().trim();
                        String doc =
                            _controllerdoc.value.text.toString().trim();
                        int est = 0;
                        if (widget.id != null) {
                          est = await prov.actualizarCLientes(
                              int.parse(id), nombre, doc, dir, cel);
                        } else {
                          est =
                              await prov.agregarCliente(nombre, doc, dir, cel);
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
                      widget.id != null ? Icons.refresh : Icons.save,
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
                          child: const ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            clipBehavior: Clip.antiAlias,
                            child: Image(
                              image: AssetImage('assets/logo.png'),
                              width: 50,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textFormField_inputCod(
                          ancho: ancho * .25,
                          controller: _controlleridclie,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        textFormField_inputText(
                            ancho: ancho * .75,
                            controller: _controllernombclie,
                            label: 'Nombre del cliente',
                            hint: 'Ejm: Pedrito Mendoza'),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            textFormField_inputInteger(
                                ancho: ancho * .44,
                                controller: _controllerdoc,
                                label: 'Documento',
                                hint: 'Ejm: 12557788'),
                            SizedBox(
                              width: ancho * .02,
                            ),
                            textFormField_inputInteger(
                                ancho: ancho * .44,
                                controller: _controllercel,
                                label: 'Celular',
                                hint: 'Ejm: 934 542 675')
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        textFormField_inputText(
                            ancho: ancho * .9,
                            controller: _controllerdir,
                            label: 'Dir. del cliente',
                            hint: 'Ejm: Calle Los loros rojos nº265'),
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
