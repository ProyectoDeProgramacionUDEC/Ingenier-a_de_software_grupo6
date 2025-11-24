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
  static const String CLAVE_MAESTRA_SISTEMA = "UDEC2025"; 

  void _registrar() {
    if (_formKey.currentState!.validate()) {
      // Lógica de Admin
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Este RUT ya está registrado.')),
        );
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
        foregroundColor: AppColors.fuente, // Texto e iconos blancos
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

              // SECCIÓN DE ROL
              SwitchListTile(
                // Usamos el color primario para el switch activo
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
                          fillColor: Colors.white, // Para que resalte el input
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
              
              // BOTÓN REFACTORIZADO CON TUS COLORES
              ElevatedButton(
                onPressed: _registrar,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  // FONDO: Azul Udec
                  backgroundColor: AppColors.primay, 
                  // TEXTO: Blanco (Tu nueva variable fuente)
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