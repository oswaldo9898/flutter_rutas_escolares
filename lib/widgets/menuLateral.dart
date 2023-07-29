import 'package:flutter/material.dart';
import '../models/login_registro/login_response_model.dart';
import '../services/api_service_estudiantes.dart';
import '../services/shared_service.dart';

class MenuLateral extends StatefulWidget {
  String opcion;
  MenuLateral(this.opcion, {Key? key}) : super(key: key);

  @override
  State<MenuLateral> createState() => _MenuLateralState();
}

class _MenuLateralState extends State<MenuLateral> {
  bool selectHome = false;
  bool selectEstudiantes = false;
  late String cedula;
  late String nombres;
  late String apellidos;
  late String email;
  late String rol;

  _getOpcion(String opc) {
    switch (opc) {
      case 'Home':
        selectHome = true;
        break;
      case 'Estudiantes':
        selectEstudiantes = true;
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _getOpcion(widget.opcion);
    _obtenerCedula();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Expanded(
                  child: Image.asset("assets/images/logoApp.jpeg"),
                ),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            ),
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 240, 234, 234)),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: selectHome,
            onTap: () {
              if (!selectHome) {
                Navigator.pushNamed(context, '/Home');
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.manage_accounts),
            title: const Text('Configuraciones'),
            selected: selectEstudiantes,
            onTap: () {
              if (!selectEstudiantes) {
                Navigator.popAndPushNamed(context, '/Configuracion',
                    arguments: {'rol': rol, 'cedula': cedula});
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Salir'),
            selected: selectEstudiantes,
            onTap: () {
              SharedService.logout(context);
              APIService.eliminarIdRepresentantes(cedula).then((value) => {});
            },
          ),
        ],
      ),
    );
  }

  _obtenerCedula() async {
    LoginResponseModel? usuario = await SharedService.loginDetails();
    cedula = usuario!.data.cedula;
    nombres = usuario.data.nombres;
    apellidos = usuario.data.apellidos;
    email = usuario.data.email;
    rol = usuario.data.rol;
  }
}
