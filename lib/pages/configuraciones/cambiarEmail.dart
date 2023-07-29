import 'package:flutter/material.dart';
import 'package:frontend_flutter/services/api_service_conductores.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import '../../config.dart';
import '../../models/conductores/registro_conductor_request_model.dart';

class CambiarEmail extends StatefulWidget {
  const CambiarEmail({Key? key}) : super(key: key);

  @override
  State<CambiarEmail> createState() => _CambiarEmailState();
}

class _CambiarEmailState extends State<CambiarEmail> {
  bool isApiCallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  TextEditingController _dato = new TextEditingController();
  String? foto = '';
  String? _path;
  String? _imagen64;
  late String cedula;
  late TextEditingController email;
  late String nombres;
  late String apellidos;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> parametros =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;
    cedula = parametros["cedula"];
    nombres = parametros["nombres"];
    apellidos = parametros["apellidos"];
    email = TextEditingController(text: parametros["email"]);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cambiar correo electronico'),
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
            "Datos del Perfil",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: TextFormField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.alternate_email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.black, width: 2.0),
              ),
              labelText: "Correo electrónico",
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
              } else if (!RegExp(Config.validarEmail).hasMatch(value)) {
                return "El correo electrónico no es valido";
              } else {
                return null;
              }
            },
          ),
        ),
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

                RegisterConductorRequestModel model =
                    RegisterConductorRequestModel(
                        cedula: cedula,
                        nombres: nombres,
                        apellidos: apellidos,
                        email: email.text,
                        path: _path,
                        imagen64: _imagen64);

                APIServiceConductores.editarConductor(model).then(
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
