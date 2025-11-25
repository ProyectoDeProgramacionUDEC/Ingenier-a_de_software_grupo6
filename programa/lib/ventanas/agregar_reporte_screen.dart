import 'package:flutter/material.dart';
import 'package:programa/Clases/ReporteService.dart';
import 'package:programa/Clases/reporte.dart';
import 'package:programa/ventanas/api_google_maps_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  // Controladores
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _nombreUsuarioController = TextEditingController();
  final _contactoUsuarioController = TextEditingController();
  final _imagenUrlController = TextEditingController();
  final _ubicacionManualController =
      TextEditingController(); // Viene del GPS Feature

  late DateTime _fechaSeleccionada;
  late bool _encontrado;
  LatLng? _ubicacionGPS; // Viene del GPS Feature

  @override
  void initState() {
    super.initState();

    // Caso: Edición
    if (widget.reporteParaEditar != null) {
      _nombreController.text = widget.reporteParaEditar!.nombre;
      _descripcionController.text = widget.reporteParaEditar!.descripcion;
      _nombreUsuarioController.text = widget.reporteParaEditar!.nombreUsuario;
      _contactoUsuarioController.text =
          widget.reporteParaEditar!.contactoUsuario;
      _imagenUrlController.text = widget.reporteParaEditar!.imagenUrl;
      _fechaSeleccionada = widget.reporteParaEditar!.fecha;

      // Fusión: Cargamos estado y ubicación
      _encontrado = widget.reporteParaEditar!.estado;
      _ubicacionManualController.text = widget.reporteParaEditar!.ubicacion;
    }
    // Caso: Nuevo Reporte
    else {
      _fechaSeleccionada = DateTime.now();
      _encontrado = widget.esEncontrado;

      // Fusión: Pre-cargar datos del usuario logueado (Lógica de Login)
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
    if (fecha != null) setState(() => _fechaSeleccionada = fecha);
  }

  // --- Lógica GPS (Del Feature) ---
  Future<void> _seleccionarUbicacion() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapaSeleccionScreen()),
    );

    if (resultado != null && resultado is LatLng) {
      setState(() {
        _ubicacionGPS = resultado;
        String etiquetaGPS =
            " [GPS: ${resultado.latitude.toStringAsFixed(5)}, ${resultado.longitude.toStringAsFixed(5)}]";
        String textoActual = _ubicacionManualController.text;

        if (textoActual.contains(" [GPS:")) {
          textoActual = textoActual.split(" [GPS:")[0];
        }

        if (textoActual.isEmpty) {
          _ubicacionManualController.text = "Ubicación GPS$etiquetaGPS";
        } else {
          _ubicacionManualController.text = "$textoActual$etiquetaGPS";
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("¡Ubicación precisa guardada y escrita!")),
      );
    }
  }

  void _agregarReporte() {
    if (_formKey.currentState!.validate()) {
      final userService = Provider.of<UserService>(context, listen: false);
      final usuarioLogueado = userService.usuarioLogueado;

      // Lógica de RUT (Del HEAD - Seguridad)
      String rutFirma = usuarioLogueado != null
          ? usuarioLogueado.rut
          : 'ANONIMO';
      if (widget.reporteParaEditar != null) {
        rutFirma = widget.reporteParaEditar!.rutUsuario;
      }

      // Lógica de Ubicación (Del Feature - GPS)
      String ubicacionFinal = _ubicacionManualController.text;

      final nuevoReporte = Reporte(
        // Removido: id ya no se usa (Hive gestiona esto internamente)
        nombre: _nombreController.text,
        fecha: _fechaSeleccionada,
        imagenUrl: _imagenUrlController.text.isEmpty
            ? 'https://via.placeholder.com/150'
            : _imagenUrlController.text,
        estado: widget.reporteParaEditar?.estado ?? false,
        descripcion: _descripcionController.text,
        nombreUsuario: _nombreUsuarioController.text,
        contactoUsuario: _contactoUsuarioController.text,
        PersonalUdec:
            widget.reporteParaEditar?.PersonalUdec ?? widget.personalUdec,
        tipoObjeto: _encontrado,
        rutUsuario: rutFirma,
        ubicacion: ubicacionFinal,
      );

      final service = Provider.of<ReporteService>(context, listen: false);

      if (widget.reporteParaEditar != null) {
        // Usar el método actualizar (más limpio)
        service.actualizarReporte(widget.reporteParaEditar!, nuevoReporte);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Reporte actualizado')));
      } else {
        service.agregarNuevoReporte(nuevoReporte);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Reporte agregado')));
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final esEdicion = widget.reporteParaEditar != null;
    final esAdmin = userService.usuarioLogueado?.esAdmin ?? false;
    final camposBloqueados =
        userService.isLoggedIn && !esAdmin; // Lógica de seguridad

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
              // --- DATOS OBJETO ---
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del objeto *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Por favor ingresa un nombre'
                    : null,
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

              // --- SECCIÓN UBICACIÓN + GPS (Fusión) ---
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
                        icon: const Icon(
                          Icons.my_location,
                          color: Colors.white,
                        ),
                        tooltip: 'Ubicación Precisa',
                      ),
                      Text(
                        _ubicacionGPS != null ? "¡Listo!" : "GPS",
                        style: TextStyle(
                          fontSize: 10,
                          color: _ubicacionGPS != null
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- IMAGEN ---
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

              // --- DATOS CONTACTO (Con lógica de bloqueo) ---
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
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Por favor ingresa tu nombre'
                    : null,
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
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Por favor ingresa un contacto'
                    : null,
              ),

              const SizedBox(height: 16),
              const Divider(),

              // --- SWITCH ESTADO ---
              Card(
                child: esEdicion
                    ? SwitchListTile(
                        title: const Text('¿Encontrado?'),
                        subtitle: Text(
                          _encontrado ? 'Objeto encontrado' : 'Objeto perdido',
                        ),
                        value: _encontrado,
                        onChanged: (value) =>
                            setState(() => _encontrado = value),
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
                        trailing: const Icon(
                          Icons.lock_outline,
                          color: Colors.grey,
                        ),
                      ),
              ),

              const SizedBox(height: 24),

              // --- BOTÓN FINAL ---
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
