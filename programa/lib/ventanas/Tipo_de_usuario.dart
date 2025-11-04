import 'package:flutter/material.dart';
import 'package:programa/Styles/Text.dart';
import 'package:programa/Styles/appBar.dart';
import 'package:programa/Styles/app_colors.dart';
import 'package:programa/componenetes/BotonPersonalUdec.dart';

class VentanaDeReporteObjeto extends StatefulWidget {
  const VentanaDeReporteObjeto({super.key});

  @override
  State<VentanaDeReporteObjeto> createState() => _VentanaDeReporteObjetoState();
}

class _VentanaDeReporteObjetoState extends State<VentanaDeReporteObjeto> {
  bool esPersona = false;
  bool TipoDeOjbeto = false;
  bool icon = false;
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
                  value: esPersona, // bool en el State del padre
                  onChanged: (v) => setState(() => esPersona = v),
                  pregunta: '¿Cómo estás relacionado con el campus?',
                  opcion1: 'Estudiante',
                  opcion2: 'Persona',
                  icono1: Icons.school,
                  icono2: Icons.badge,
                ),
              ),
              BotonDeTipoDeUsuario(
                value: TipoDeOjbeto,
                onChanged: (v) => setState(() => TipoDeOjbeto = v),
                pregunta: 'Qué tipo de reporte quiere realizar',
                opcion1: 'Quiero reportar un objeto perdido',
                opcion2: 'Quiero reportar un objeto encontrado',
                icono1: Icons.search,
                icono2: Icons.find_in_page,
              ),
              /* BotonVentanaPersona(
                texto: "Realizar reporte",
                personal: esPersona,
                tipoDeObjeto: TipoDeOjbeto, // tu boolean actual
                rutas: BotonVentanaPersonaRutas(
                  perdidoEstudiante: (_) => FormularioPerdidoEstudiante(),
                  perdidoPersona: (_) => FormularioPerdidoPersona(),
                  encontradoEstudiante: (_) => FormularioEncontradoEstudiante(),
                  encontradoPersona: (_) => FormularioEncontradoPersona(),
                ),
                icono: Icons.send, // opcional
                tooltip: "Ir al formulario", // opcional
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
