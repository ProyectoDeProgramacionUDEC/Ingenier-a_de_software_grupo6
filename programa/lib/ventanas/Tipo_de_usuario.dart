import 'package:flutter/material.dart';
import 'package:programa/Styles/appBar.dart';

import 'package:programa/componenetes/BotonPersonalUdec.dart';
import 'package:programa/ventanas/Ventana_inicio_de_usuario.dart'; // si aquí vive BotonVentanaPersona
import 'package:programa/ventanas/agregar_reporte_screen.dart';

// ✅ Define el WIDGET correcto
class VentanaDeReporteObjeto extends StatefulWidget {
  const VentanaDeReporteObjeto({super.key});

  @override
  State<VentanaDeReporteObjeto> createState() => _VentanaDeReporteObjetoState();
}

// ✅ Y su STATE asociado
class _VentanaDeReporteObjetoState extends State<VentanaDeReporteObjeto> {
  bool esPersona = false;
  bool tipoDeObjeto = false;

  void _abrirFormulario() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AgregarReporteScreen(
          personalUdec: esPersona,
          esEncontrado: tipoDeObjeto,
          onReporteAgregado: (reporte) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Reporte agregado')));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.background;

    return Scaffold(
      appBar: const UdecAppBarRightLogo(title: "OBJETOS PERDIDOS"),
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BotonDeTipoDeUsuario(
                  value: esPersona,
                  onChanged: (v) => setState(() => esPersona = v),
                  pregunta: '¿Cómo estás relacionado con el campus?',
                  opcion1: 'Estudiante',
                  opcion2: 'Persona',
                  icono1: Icons.school,
                  icono2: Icons.badge,
                ),
              ),
              BotonDeTipoDeUsuario(
                value: tipoDeObjeto,
                onChanged: (v) => setState(() => tipoDeObjeto = v),
                pregunta: '¿Qué tipo de reporte quiere realizar?',
                opcion1: 'Quiero reportar un objeto perdido',
                opcion2: 'Quiero reportar un objeto encontrado',
                icono1: Icons.search,
                icono2: Icons.find_in_page,
              ),
              // Puedes usar _abrirFormulario() directo o tus rutas
              BotonVentanaPersona(
                texto: "Realizar reporte",
                personal: esPersona,
                tipoDeObjeto: tipoDeObjeto,
                rutas: BotonVentanaPersonaRutas(
                  perdidoEstudiante: (_) => AgregarReporteScreen(
                    personalUdec: true,
                    esEncontrado: false,
                    onReporteAgregado: (r) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reporte agregado')),
                      );
                    },
                  ),
                  perdidoPersona: (_) => AgregarReporteScreen(
                    personalUdec: false,
                    esEncontrado: false,
                    onReporteAgregado: (r) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reporte agregado')),
                      );
                    },
                  ),
                  encontradoEstudiante: (_) => AgregarReporteScreen(
                    personalUdec: true,
                    esEncontrado: true,
                    onReporteAgregado: (r) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reporte agregado')),
                      );
                    },
                  ),
                  encontradoPersona: (_) => AgregarReporteScreen(
                    personalUdec: false,
                    esEncontrado: true,
                    onReporteAgregado: (r) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reporte agregado')),
                      );
                    },
                  ),
                ),
                icono: Icons.send,
                tooltip: "Ir al formulario",
              ),
              // Si prefieres un botón simple que use _abrirFormulario():
              // ElevatedButton(onPressed: _abrirFormulario, child: const Text('Realizar reporte')),
            ],
          ),
        ),
      ),
    );
  }
}
