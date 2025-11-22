import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:programa/ventanas/Ventana_inicio_de_usuario.dart';
import 'package:programa/services/user_service.dart';
import 'package:programa/widgets/app_bar_widget.dart';

class MenuPrincipalScreen extends StatelessWidget {
  const MenuPrincipalScreen({super.key});

  void _cerrarSesion(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: false);
    userService.logout();

    Navigator.of(context).pushReplacementNamed('/');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sesión cerrada correctamente'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Objetos perdidos",
        showLogoutButton: true,
        onLogout: () => _cerrarSesion(context),
      ),
      body: const VentanaInicioDeUsuario(),
    );
  }
}