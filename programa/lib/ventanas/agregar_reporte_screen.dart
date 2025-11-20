import 'package:flutter/material.dart';
import 'package:programa/Clases/reporte.dart';
import 'package:programa/Clases/ReporteService.dart';
import 'package:provider/provider.dart';

class AgregarReporteScreen extends StatefulWidget {
  final bool personalUdec; // true=Estudiante, false=Persona externa
  final bool esEncontrado; // true=Encontrado, false=Perdido

  const AgregarReporteScreen({
    super.key,
    required this.esEncontrado,
    required this.personalUdec,
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

  DateTime _fechaSeleccionada = DateTime.now();
  bool _encontrado = false;

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
      final nuevoReporte = Reporte(
        nombre: _nombreController.text,
        fecha: _fechaSeleccionada,
        imagenUrl: _imagenUrlController.text.isEmpty
            ? 'https://via.placeholder.com/150'
            : _imagenUrlController.text,
        encontrado: _encontrado,
        descripcion: _descripcionController.text,
        nombreUsuario: _nombreUsuarioController.text,
        contactoUsuario: _contactoUsuarioController.text,
        PersonalUdec: true,
        tipoObjeto: true,
      );
        Provider.of<ReporteService>(context, listen: false)
          .agregarNuevoReporte(nuevoReporte);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reporte agregado'))
    );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Reporte'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
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

              const Text(
                'Información de contacto',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _nombreUsuarioController,
                decoration: const InputDecoration(
                  labelText: 'Tu nombre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _contactoUsuarioController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono o email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.contact_phone),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              Card(
                child: SwitchListTile(
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
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _agregarReporte,
                icon: const Icon(Icons.add),
                label: const Text('Agregar Reporte'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
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
