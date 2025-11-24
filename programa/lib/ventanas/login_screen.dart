import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:programa/widgets/VideoBackground.dart';
import 'package:programa/Styles/Text.dart';
import 'package:programa/Styles/app_colors.dart';
import 'package:programa/services/user_service.dart';
import 'package:programa/widgets/app_bar_widget.dart';
import 'package:programa/widgets/admin_password.dart';
import 'package:programa/ventanas/registros_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _rutController = TextEditingController();

  void _mostrarDialogoUsuarioNoRegistrado(String rutIngresado) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.person_add, color: AppColors.primay, size: 40),
          title: const Text("Usuario no encontrado", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
            "El RUT $rutIngresado no aparece en nuestros registros.\n\n¿Te gustaría crear una cuenta nueva?",
            textAlign: TextAlign.center,
          ),
          actions: [
            // Opción 1: Cancelar (quizás escribió mal el RUT)
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Intentar de nuevo"),
            ),
            
            // Opción 2: Ir a registrarse
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primay,
                foregroundColor: AppColors.secondary,
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                // Navega a la pantalla de registro
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const RegistroScreen()),
                );
              },
              child: const Text("Registrarme"),
            ),
          ],
        );
      },
    );
  }

void _iniciarSesion(BuildContext context) {
    final rut = _rutController.text.trim();

    if (rut.isEmpty) {
      _mostrarError('Por favor ingresa tu RUT');
      return;
    }

    final userService = Provider.of<UserService>(context, listen: false);
    
    // Intentamos loguear
    final loginExitoso = userService.login(rut);

    if (loginExitoso) {
      if (userService.requierePasswordAdmin) {
        _mostrarDialogoPasswordAdmin(context, userService);
      } else {
        _irAMenuPrincipal(context);
      }
    } else {
      //Si no está registrado, lanzamos la invitación a registrarse
      _mostrarDialogoUsuarioNoRegistrado(rut);
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
      extendBodyBehindAppBar: true, 
      appBar: const CustomAppBar(
        title: "Objetos perdidos",
        showLogoutButton: false,
        // backgroundColor: Colors.transparent, 
      ),
      body: Stack(
        children: [
          const VideoBackground(),

          // Filtro Oscuro
          Container(
            color: AppColors.primay.withOpacity(0.6), 
          ),

          // CAPA 3: TU CONTENIDO (Formulario)
          Center(
            child: SingleChildScrollView(
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

                  // Texto blanco o secundario para que resalte sobre el fondo oscuro
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
                      // Sombra para que se separe del video
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _rutController,
                          decoration: const InputDecoration(
                            labelText: 'RUT',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
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
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text(
                              'Iniciar Sesión',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        
                        // Botón de registro
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const RegistroScreen()),
                            );
                          },
                          child: const Text(
                            '¿No tienes cuenta? Regístrate aquí',
                            style: TextStyle(
                              color: AppColors.primay,
                              fontWeight: FontWeight.w600
                            ), 
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}