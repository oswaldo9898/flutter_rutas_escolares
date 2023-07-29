import 'package:flutter/material.dart';
import 'package:frontend_flutter/services/api_service_estudiantes.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import '../../config.dart';

class CambiarPassword extends StatefulWidget {
  const CambiarPassword({Key? key}) : super(key: key);

  @override
  State<CambiarPassword> createState() => _CambiarPasswordState();
}

class _CambiarPasswordState extends State<CambiarPassword> {
  bool isApiCallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String cedula = '';
  final passwordAnterior = TextEditingController();
  final passwordNueva = TextEditingController();
  late bool passwordVisible;
  late bool passwordVisible2;

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
    passwordVisible2 = false;
  }

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> parametros =
        ModalRoute.of(context)?.settings.arguments as Map<dynamic, dynamic>;
    cedula = parametros["cedula"];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cambiar contraseña'),
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
          padding: const EdgeInsets.all(15),
          child: TextFormField(
            controller: passwordAnterior,
            obscureText: !passwordVisible,
            autocorrect: false,
            keyboardType: TextInputType.visiblePassword,
            style: const TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.black, width: 2.0),
              ),
              labelText: "Contraseña Actual",
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
          padding: const EdgeInsets.all(15),
          child: TextFormField(
            controller: passwordNueva,
            obscureText: !passwordVisible2,
            autocorrect: false,
            keyboardType: TextInputType.visiblePassword,
            style: const TextStyle(color: Colors.black),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  passwordVisible2 ? Icons.visibility : Icons.visibility_off,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    passwordVisible2 = !passwordVisible2;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.black, width: 2.0),
              ),
              labelText: "Nueva Contraseña",
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
              } else if (!RegExp(Config.validarPassword).hasMatch(value)) {
                return "La contraseña no es valida";
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

                APIService.cambiarPassword(
                        passwordAnterior.text, passwordNueva.text, cedula)
                    .then(
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
