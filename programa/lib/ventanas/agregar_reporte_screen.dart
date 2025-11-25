import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:programa/Clases/reporte.dart';
import 'package:programa/Clases/ReporteService.dart';
import 'package:programa/services/user_service.dart';
import 'package:programa/Styles/app_colors.dart';

class AgregarReporteScreen extends StatefulWidget {
  final bool personalUdec;
  final bool esEncontrado;
  final Reporte? reporteParaEditar;

  final bool esAdministrador;

  const AgregarReporteScreen({
    super.key,
    required this.esEncontrado,
    required this.personalUdec,
    this.reporteParaEditar,
    this.esAdministrador = false,
  });

  @override
  State<AgregarReporteScreen> createState() => _AgregarReporteScreenState();
}

class _AgregarReporteScreenState extends State<AgregarReporteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _nombreUsuarioController = TextEditingController();
  final _contactoUsuarioController = TextEditingController();
  final _imagenUrlController = TextEditingController();

  late DateTime _fechaSeleccionada;
  late bool _encontrado;

  @override
  void initState() {
    super.initState();
    
    // Caso: edición
    if (widget.reporteParaEditar != null) {
      _nombreController.text = widget.reporteParaEditar!.nombre;
      _descripcionController.text = widget.reporteParaEditar!.descripcion;
      // Carga los datos históricos del reporte
      _nombreUsuarioController.text = widget.reporteParaEditar!.nombreUsuario;
      _contactoUsuarioController.text = widget.reporteParaEditar!.contactoUsuario;
      _imagenUrlController.text = widget.reporteParaEditar!.imagenUrl;
      _fechaSeleccionada = widget.reporteParaEditar!.fecha;
      _encontrado = widget.reporteParaEditar!.encontrado;
    } 
    // Caso: nuevo reporte
    else {
      _fechaSeleccionada = DateTime.now();
      _encontrado = widget.esEncontrado;
      
      // Si es nuevo, intentamos pre-cargar los datos del usuario logueado
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _cargarDatosUsuario();
      });
    }
  }

  void _cargarDatosUsuario() {
    final userService = Provider.of<UserService>(context, listen: false);
    if (userService.isLoggedIn && userService.usuarioLogueado != null) {
      final usuario = userService.usuarioLogueado!;
      setState(() {
        _nombreUsuarioController.text = usuario.nombre;
        _contactoUsuarioController.text = usuario.correoContacto;
      });
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _nombreUsuarioController.dispose();
    _contactoUsuarioController.dispose();
    _imagenUrlController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (fecha != null) {
      setState(() {
        _fechaSeleccionada = fecha;
      });
    }
  }

  void _agregarReporte() {
    if (_formKey.currentState!.validate()) {
      final userService = Provider.of<UserService>(context, listen: false);
      final usuarioLogueado = userService.usuarioLogueado;
      
      // Determinamos el RUT del autor:
      // - Si es edición, mantenemos el RUT original (¡Importante!)
      // - Si es nuevo, usamos el del usuario logueado o 'ANONIMO'
      String rutFirma = usuarioLogueado != null ? usuarioLogueado.rut : 'ANONIMO';
      if (widget.reporteParaEditar != null) {
        rutFirma = widget.reporteParaEditar!.rutUsuario;
      }

      final nuevoReporte = Reporte(
        nombre: _nombreController.text,
        fecha: _fechaSeleccionada,
        imagenUrl: _imagenUrlController.text.isEmpty
            ? 'https://via.placeholder.com/150'
            : _imagenUrlController.text,
        encontrado: _encontrado,
        descripcion: _descripcionController.text,
        // Aquí tomamos lo que dicen los controladores.
        // Como los bloqueamos visualmente para el usuario,
        // se enviará lo que se cargó automáticamente.
        nombreUsuario: _nombreUsuarioController.text,
        contactoUsuario: _contactoUsuarioController.text,
        PersonalUdec: widget.reporteParaEditar?.PersonalUdec ?? widget.personalUdec,
        tipoObjeto: widget.reporteParaEditar?.tipoObjeto ?? true,
        rutUsuario: rutFirma,
      );

      final service = Provider.of<ReporteService>(context, listen: false);

      if (widget.reporteParaEditar != null) {
        service.actualizarReporte(widget.reporteParaEditar!, nuevoReporte);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reporte actualizado')),
        );
      } else {
        service.agregarNuevoReporte(nuevoReporte);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reporte agregado')),
        );
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final esEdicion = widget.reporteParaEditar != null;
    
    // Verificamos si es admin real desde el servicio
    final esAdmin = userService.usuarioLogueado?.esAdmin ?? false;

    // Definimos si los campos de contacto deben bloquearse
    final camposBloqueados = userService.isLoggedIn && !esAdmin;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? 'Editar Reporte' : 'Agregar Reporte'),
        backgroundColor: AppColors.primay,
        foregroundColor: AppColors.fuente,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Datos del objeto (editables)
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del objeto *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.notes),
                  hintText: 'Describe el objeto...',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _seleccionarFecha,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Fecha *',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}',
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imagenUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL de la imagen (opcional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                  hintText: 'https://ejemplo.com/imagen.jpg',
                ),
              ),
              
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),

              // Datos de contacto (no editables)
              const Text(
                'Información de contacto',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primay,
                ),
              ),
              const SizedBox(height: 8),
              
              TextFormField(
                controller: _nombreUsuarioController,
                readOnly: camposBloqueados, 
                decoration: InputDecoration(
                  labelText: 'Tu nombre',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person),
                  suffixIcon: camposBloqueados
                      ? const Icon(Icons.lock, color: Colors.grey)
                      : null,
                  helperText: camposBloqueados ? "Vinculado a tu cuenta" : null,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contactoUsuarioController,
                readOnly: camposBloqueados,
                decoration: InputDecoration(
                  labelText: 'Teléfono o email',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.contact_phone),
                  suffixIcon: camposBloqueados
                      ? const Icon(Icons.lock, color: Colors.grey)
                      : null,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              
              const SizedBox(height: 16),
              const Divider(),
              
              Card(
                child: esEdicion 
                  ? SwitchListTile(
                      title: const Text('¿Encontrado?'),
                      subtitle: Text(
                        _encontrado ? 'Objeto encontrado' : 'Objeto perdido',
                      ),
                      value: _encontrado,
                      onChanged: (value) {
                        setState(() {
                          _encontrado = value;
                        });
                      },
                      secondary: Icon(
                        _encontrado ? Icons.check_circle : Icons.search,
                        color: _encontrado ? Colors.green : Colors.orange,
                      ),
                    )
                  : ListTile(
                      title: const Text('Tipo de Reporte'),
                      subtitle: Text(
                        _encontrado ? 'Objeto encontrado' : 'Objeto perdido',
                        style: TextStyle(
                          color: _encontrado ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      leading: Icon(
                        _encontrado ? Icons.check_circle : Icons.search,
                        color: _encontrado ? Colors.green : Colors.orange,
                      ),
                      trailing: const Icon(Icons.lock_outline, color: Colors.grey), // Candado visual
                    ),
              ),
              
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _agregarReporte,
                icon: Icon(esEdicion ? Icons.save : Icons.add),
                label: Text(esEdicion ? 'Guardar Cambios' : 'Agregar Reporte'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primay,
                  foregroundColor: AppColors.fuente,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}