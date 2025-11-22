import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:programa/Styles/Text.dart';
import 'package:programa/Styles/app_colors.dart';
import 'package:programa/services/user_service.dart';
import 'package:programa/widgets/app_bar_widget.dart';
import 'package:programa/widgets/admin_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _rutController = TextEditingController();

  void _iniciarSesion(BuildContext context) {
    final rut = _rutController.text.trim();

    if (rut.isEmpty) {
      _mostrarError('Por favor ingresa tu RUT');
      return;
    }

    final userService = Provider.of<UserService>(context, listen: false);
    final loginExitoso = userService.login(rut);

    if (loginExitoso) {
      if (userService.requierePasswordAdmin) {
        _mostrarDialogoPasswordAdmin(context, userService);
      } else {
        _irAMenuPrincipal(context);
      }
    } else {
      _mostrarError('RUT no encontrado');
    }
  }

  void _mostrarDialogoPasswordAdmin(
    BuildContext context,
    UserService userService,
  ) {
    showDialog(
      context: context,
      builder: (context) => AdminPasswordDialog(userService: userService),
    );
  }

  void _irAMenuPrincipal(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/menu_principal');
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Objetos perdidos",
        showLogoutButton: false,
      ),
      backgroundColor: AppColors.primay,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset(
                  'assets/images/LogoUdec.png',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Inicia sesión en tu cuenta",
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 30),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _rutController,
                      decoration: const InputDecoration(
                        labelText: 'RUT',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _iniciarSesion(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primay,
                          foregroundColor: AppColors.secondary,
                        ),
                        child: const Text('Iniciar Sesión'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}