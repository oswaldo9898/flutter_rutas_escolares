import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../config.dart';
import '../../models/estudiantes/registro_estudiante_request_model.dart';
import '../../services/api_service_estudiantes.dart';

class EditarEstudiante extends StatefulWidget {
  const EditarEstudiante({Key? key}) : super(key: key);

  @override
  State<EditarEstudiante> createState() => _EditarEstudianteState();
}

class _EditarEstudianteState extends State<EditarEstudiante> {
  TextEditingController _dato = new TextEditingController();
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? foto_est;
  String? _path;
  String? _imagen64;

  late TextEditingController cedulaEst;
  late TextEditingController nombresEst;
  late TextEditingController apellidosEst;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> parametros =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;
    cedulaEst = TextEditingController(text: parametros["cedula_est"]);
    nombresEst = TextEditingController(text: parametros["nombres"]);
    apellidosEst = TextEditingController(text: parametros["apellidos"]);
    foto_est = parametros["foto"];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Editar Estudiante'),
          elevation: 0,
        ),
        backgroundColor: Colors.grey[200],
        body: ProgressHUD(
          child: Form(
            key: globalFormKey,
            child: _editarUI(context),
          ),
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget _editarUI(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(),
        const Padding(
          padding: EdgeInsets.only(left: 20, bottom: 30, top: 50),
          child: Text(
            "Datos del Estudiante",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 6),
          child: TextFormField(
            controller: cedulaEst,
            maxLength: 10,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              FilteringTextInputFormatter.digitsOnly
            ],
            textCapitalization: TextCapitalization.characters,
            style: const TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            enabled: false,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.badge_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.black, width: 2.0),
              ),
              labelText: "Cédula",
              labelStyle: const TextStyle(color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(25.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "No puede estar vacio";
              } else if (value.length < 10) {
                return "Cedula incompleta";
              } else {
                return null;
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: TextFormField(
            controller: nombresEst,
            textCapitalization: TextCapitalization.characters,
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.perm_identity_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.black, width: 2.0),
              ),
              labelText: "Nombres",
              labelStyle: const TextStyle(color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(25.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "No puede estar vacio";
              } else {
                return null;
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: TextFormField(
            controller: apellidosEst,
            textCapitalization: TextCapitalization.characters,
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.perm_identity_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.black, width: 2.0),
              ),
              labelText: "Apellidos",
              labelStyle: const TextStyle(color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(25.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "No puede estar vacio";
              } else {
                return null;
              }
            },
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Column(
              children: [
                TextField(
                  controller: _dato,
                ),
                (_path == null)
                    ? Image.network(
                        Config.apiURL +
                            Config.obtenerFotoEstudianteAPI +
                            foto_est!,
                        width: 200,
                        height: 200)
                    : Image.file(
                        File(_path!),
                        width: 200,
                        height: 200,
                      ),
                TextButton(
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      final XFile? _archivo =
                          await _picker.pickImage(source: ImageSource.gallery);
                      setState(() {
                        if (_archivo != null) {
                          _path = _archivo.path;
                        }
                      });
                      if (_archivo != null) {
                        _imagen64 = base64
                            .encode(await new File(_path!).readAsBytesSync());
                      }
                    },
                    child: const Text("Subir imagen")),
              ],
            )),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: FormHelper.submitButton(
            "Actualizar",
            () {
              if (validateAndSave()) {
                setState(() {
                  isApiCallProcess = true;
                });

                RegisterEstudianteRequestModel model =
                    RegisterEstudianteRequestModel(
                  cedula_est: cedulaEst.text,
                  nombres_est: nombresEst.text,
                  apellidos_est: apellidosEst.text,
                  path: _path,
                  imagen64: _imagen64,
                  latitud: 77.00125570238107,
                  longitud: 0.15375784010679067,
                );

                APIService.editarEstudiante(model).then(
                  (response) {
                    setState(() {
                      isApiCallProcess = false;
                    });

                    if (response.message == 'Exito') {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        Config.appName,
                        "Actualización exitosa",
                        "Aceptar",
                        () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                      );
                    } else {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        Config.appName,
                        response.message,
                        "Aceptar",
                        () {
                          Navigator.of(context).pop();
                        },
                      );
                    }
                  },
                );
              }
            },
            btnColor: HexColor("283B71"),
            borderColor: Colors.white,
            txtColor: Colors.white,
            borderRadius: 10,
          ),
        ),
      ],
    ));
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
