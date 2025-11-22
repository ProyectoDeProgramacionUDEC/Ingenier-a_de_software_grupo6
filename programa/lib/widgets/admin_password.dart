import 'package:flutter/material.dart';
import 'package:programa/services/user_service.dart';

class AdminPasswordDialog extends StatefulWidget {
  final UserService userService;

  const AdminPasswordDialog({
    super.key,
    required this.userService,
  });

  @override
  State<AdminPasswordDialog> createState() => _AdminPasswordDialogState();
}

class _AdminPasswordDialogState extends State<AdminPasswordDialog> {
  final TextEditingController _passwordController = TextEditingController();

  void _verificarPassword(BuildContext context) {
    final password = _passwordController.text;
    if (widget.userService.verificarPasswordAdmin(password)) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/menu_principal');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contraseña incorrecta'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _cancelar(BuildContext context) {
    widget.userService.cancelarLoginAdmin();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Contraseña de Administrador'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Bienvenido ${widget.userService.usuarioLogueado?.nombre}'),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Contraseña de administrador',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => _cancelar(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => _verificarPassword(context),
          child: const Text('Ingresar'),
        ),
      ],
    );
  }
}