import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; 
import 'package:provider/provider.dart';
import 'package:programa/Clases/reporte.dart';
import 'package:programa/Clases/ReporteService.dart';
import 'package:programa/services/user_service.dart';
import 'package:programa/Styles/app_colors.dart';
import 'package:programa/ventanas/api_google_maps_screen.dart';

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
  final _ubicacionManualController = TextEditingController();

  late DateTime _fechaSeleccionada;
  late bool _encontrado;
  LatLng? _ubicacionGPS;

  @override
  void initState() {
    super.initState();
    
    if (widget.reporteParaEditar != null) {
      _nombreController.text = widget.reporteParaEditar!.nombre;
      _descripcionController.text = widget.reporteParaEditar!.descripcion;
      _nombreUsuarioController.text = widget.reporteParaEditar!.nombreUsuario;
      _contactoUsuarioController.text = widget.reporteParaEditar!.contactoUsuario;
      _imagenUrlController.text = widget.reporteParaEditar!.imagenUrl;
      _fechaSeleccionada = widget.reporteParaEditar!.fecha;
      _encontrado = widget.reporteParaEditar!.estado;
      _ubicacionManualController.text = widget.reporteParaEditar!.ubicacion;
    } 
    else {
      _fechaSeleccionada = DateTime.now();
      _encontrado = widget.esEncontrado;
      
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
    _ubicacionManualController.dispose();
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

  Future<void> _seleccionarImagenGaleria() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(source: ImageSource.gallery);

    if (imagen != null) {
      setState(() {
        _imagenUrlController.text = imagen.path; 
      });
    }
  }

  Future<void> _seleccionarUbicacion() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapaSeleccionScreen()),
    );

    if (resultado != null && resultado is Map) {
      setState(() {
        _ubicacionGPS = resultado["coords"];
        String direccion = resultado["direccion"];
        _ubicacionManualController.text = direccion;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("¡Ubicación guardada!")),
      );
    }
  }

  void _agregarReporte() {
    if (_formKey.currentState!.validate()) {
      final userService = Provider.of<UserService>(context, listen: false);
      final usuarioLogueado = userService.usuarioLogueado;
      
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
        estado: _encontrado,
        descripcion: _descripcionController.text,
        nombreUsuario: _nombreUsuarioController.text,
        contactoUsuario: _contactoUsuarioController.text,
        PersonalUdec: widget.reporteParaEditar?.PersonalUdec ?? widget.personalUdec,
        tipoObjeto: widget.reporteParaEditar?.tipoObjeto ?? true,
        rutUsuario: rutFirma,
        ubicacion: _ubicacionManualController.text,
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
    final esAdmin = userService.usuarioLogueado?.esAdmin ?? false;
    final camposBloqueados = userService.isLoggedIn && !esAdmin;

    String tituloBase = esEdicion ? 'Editar Reporte' : 'Agregar Reporte';
    String sufijoTipo = _encontrado ? ' (Hallazgo)' : ' (Pérdida)';

    return Scaffold(
      appBar: AppBar(
        title: Text(tituloBase + sufijoTipo),
        backgroundColor: AppColors.primay,
        foregroundColor: AppColors.fuente,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ubicacionManualController,
                      decoration: const InputDecoration(
                        labelText: 'Ubicación / Referencia',
                        hintText: 'Ej: Sala 204...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.place),
                      ),
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      IconButton.filled(
                        onPressed: _seleccionarUbicacion,
                        style: IconButton.styleFrom(
                          backgroundColor: _ubicacionGPS != null
                              ? Colors.green
                              : AppColors.primay,
                        ),
                        icon: const Icon(Icons.my_location, color: Colors.white),
                        tooltip: 'Ubicación Precisa',
                      ),
                      Text(
                        _ubicacionGPS != null ? "¡Listo!" : "GPS",
                        style: TextStyle(
                          fontSize: 10,
                          color: _ubicacionGPS != null ? Colors.green : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              InkWell(
                onTap: _seleccionarImagenGaleria,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _imagenUrlController.text.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                            Text("Toca para subir una foto", style: TextStyle(color: Colors.grey)),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _imagenUrlController.text.startsWith('http')
                              // Mantenemos la lógica antigua para no romper los casos anteriores
                              ? Image.network(
                                  _imagenUrlController.text,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c,e,s) => const Icon(Icons.broken_image),
                                )
                              // Nueva imagen seleccionada desde galería
                              : kIsWeb
                                  ? Image.network(
                                      _imagenUrlController.text,
                                      fit: BoxFit.cover,
                                      errorBuilder: (c, e, s) => const Icon(Icons.broken_image),
                                    )
                                  : Image.file(
                                      File(_imagenUrlController.text),
                                      fit: BoxFit.cover,
                                    ),
                        ),
                ),
              ),
              
              if (_imagenUrlController.text.isNotEmpty)
                Center(
                  child: TextButton.icon(
                    onPressed: _seleccionarImagenGaleria,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Cambiar foto"),
                  ),
                ),
              
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),

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