import 'package:flutter/material.dart';
import 'package:programa/Clases/usuario.dart';
import 'package:programa/Clases/GestorUsuarios.dart';
import 'package:programa/Styles/app_colors.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores
  final _rutController = TextEditingController();
  final _nombreController = TextEditingController();
  final _contactoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passAdminController = TextEditingController(); 
  final _claveMaestraController = TextEditingController(); 

  bool _esAdmin = false;
  //Clave para registrar nuevos admins
  static const String CLAVE_MAESTRA_SISTEMA = "UDEC2025"; 

  void _mostrarDialogoUsuarioExistente() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(Icons.info_outline, color: AppColors.secondary, size: 40),
          title: const Text("Usuario ya registrado", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(
            "El RUT ${_rutController.text} ya se encuentra registrado.\n¿Deseas iniciar sesión?",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Corregir RUT"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primay,
                foregroundColor: AppColors.fuente,
              ),
              onPressed: () {
                Navigator.of(context).pop(); 
                Navigator.of(context).pop(); 
              },
              child: const Text("Ir al Login"),
            ),
          ],
        );
      },
    );
  }

  void _registrar() {
    if (_formKey.currentState!.validate()) {
      if (_esAdmin) {
        if (_claveMaestraController.text != CLAVE_MAESTRA_SISTEMA) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Clave Maestra incorrecta.')),
          );
          return;
        }
      }
      // Verificar existencia
      if (GestorUsuarios().existeUsuario(_rutController.text)) {
        _mostrarDialogoUsuarioExistente();
        return;
      }

      // Crear Usuario
      final nuevoUsuario = Usuario(
        rut: _rutController.text,
        nombre: _nombreController.text,
        numeroContacto: _contactoController.text,
        correoContacto: _emailController.text,
        esAdmin: _esAdmin,
        passwordAdmin: _esAdmin ? _passAdminController.text : null,
      );

      GestorUsuarios().agregarUsuario(nuevoUsuario);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario registrado con éxito.')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Cuenta"),
        backgroundColor: AppColors.primay, 
        foregroundColor: AppColors.fuente,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campos Comunes
              TextFormField(
                controller: _rutController,
                decoration: const InputDecoration(labelText: 'RUT'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre Completo'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contactoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v!.contains('@') ? null : 'Email inválido',
              ),

              const Divider(height: 40),

              // Zona Admin
              SwitchListTile(
                activeColor: AppColors.primay,
                title: const Text("¿Registrar como Administrador?"),
                subtitle: const Text("Requiere clave institucional"),
                value: _esAdmin,
                onChanged: (val) {
                  setState(() => _esAdmin = val);
                },
              ),

              // Campo extra si es admin
              if (_esAdmin) ...[
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.secondary),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Zona de Seguridad",
                        style: TextStyle(
                          color: AppColors.primay, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _claveMaestraController,
                        decoration: const InputDecoration(
                          labelText: 'Clave de Autorización UDEC',
                          prefixIcon: Icon(Icons.vpn_key, color: AppColors.primay),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        obscureText: true,
                        validator: (v) => _esAdmin && v!.isEmpty ? 'Requerida' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passAdminController,
                        decoration: const InputDecoration(
                          labelText: 'Crea contraseña Admin',
                          prefixIcon: Icon(Icons.lock, color: AppColors.primay),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        obscureText: true,
                        validator: (v) => _esAdmin && v!.isEmpty ? 'Requerida' : null,
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 30),
              
              ElevatedButton(
                onPressed: _registrar,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: AppColors.primay, 
                  foregroundColor: AppColors.fuente, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Registrar Usuario",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}