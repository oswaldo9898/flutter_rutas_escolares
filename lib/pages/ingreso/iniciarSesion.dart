import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/config.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import '../../models/login_registro/login_request_model.dart';
import '../../models/login_registro/login_response_model.dart';
import '../../services/api_service_estudiantes.dart';
import '../../config.dart';
import '../../services/shared_service.dart';

class IniciarSesion extends StatefulWidget {
  const IniciarSesion({Key? key}) : super(key: key);

  @override
  State<IniciarSesion> createState() => _IniciarSesionState();
}

class _IniciarSesionState extends State<IniciarSesion> {
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  late String cedula = '';
  late bool passwordVisible;

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#283B71"),
        body: ProgressHUD(
          child: Form(
            key: globalFormKey,
            child: _InicioSesionUI(context),
          ),
          inAsyncCall: isAPIcallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget _InicioSesionUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(100),
                bottomLeft: Radius.circular(100),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/logoApp.jpeg",
                    fit: BoxFit.contain,
                    width: 250,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, bottom: 30, top: 50),
            child: Text(
              "Iniciar Sesión",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextFormField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                ),
                labelText: "Correo electrónico",
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty ||
                    !RegExp(Config.validarEmail).hasMatch(value)) {
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
              controller: password,
              obscureText: !passwordVisible,
              autocorrect: false,
              keyboardType: TextInputType.visiblePassword,
              style: const TextStyle(color: Colors.white),
              cursorColor: Colors.white,
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
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                ),
                labelText: "Contraseña",
                labelStyle: const TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
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
          // Align(
          //   alignment: Alignment.bottomRight,
          //   child: Padding(
          //     padding: const EdgeInsets.only(
          //       right: 25,
          //     ),
          //     child: RichText(
          //       text: TextSpan(
          //         style: const TextStyle(color: Colors.grey, fontSize: 14.0),
          //         children: <TextSpan>[
          //           TextSpan(
          //             text: 'Recuperar Contraseña',
          //             style: const TextStyle(
          //               color: Colors.white,
          //               decoration: TextDecoration.underline,
          //             ),
          //             recognizer: TapGestureRecognizer()..onTap = () {},
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          const SizedBox(
            height: 20,
          ),
          Center(
              child: FormHelper.submitButton(
            "Iniciar sesión",
            () {
              if (validateAndSave()) {
                setState(() {
                  isAPIcallProcess = true;
                });
                LoginRequestModel model = LoginRequestModel(
                  email: email.text,
                  password: password.text,
                );

                APIService.login(model).then(
                  (response) {
                    setState(() {
                      isAPIcallProcess = false;
                    });

                    if (response != "null") {
                      _obtenerCedula();
                      if (response == "ADMINISTRADOR") {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/Home',
                          (route) => false,
                        );
                      } else if (response == "REPRESENTANTE") {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/HomeRepresentante',
                          (route) => false,
                        );
                      } else if (response == "CONDUCTOR") {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/HomeConductor',
                          (route) => false,
                        );
                      }
                    } else {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        Config.appName,
                        "Correo eletrónico / contraseña invalida!!",
                        "OK",
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
          )),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              "Ó",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 25,
              ),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.white, fontSize: 14.0),
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'No tienes una cuenta? ',
                    ),
                    TextSpan(
                      text: 'Registrarse',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(
                            context,
                            '/Registrarse',
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _obtenerCedula() async {
    LoginResponseModel? usuario = await SharedService.loginDetails();
    cedula = usuario!.data.cedula;
    await OneSignal.shared.setAppId("");
    await OneSignal.shared.getDeviceState().then((value) => {
          APIService.registerIdRepresentantes(cedula, value!.userId)
              .then((value) => {})
        });
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
