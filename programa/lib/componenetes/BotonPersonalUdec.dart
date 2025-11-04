import 'package:flutter/material.dart';
import 'package:programa/Styles/Text.dart';
import 'package:programa/Styles/app_colors.dart';

/// Dos opciones: Estudiante | Persona (funcionario/visitante)

//Boton para ver si eres de la universidad
class BotonDeTipoDeUsuario extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String pregunta;
  final String opcion1;
  final String opcion2;
  final IconData icono1;
  final IconData icono2;

  const BotonDeTipoDeUsuario({
    super.key,
    required this.value,
    required this.onChanged,
    required this.pregunta,
    required this.opcion1,
    required this.opcion2,
    required this.icono1,
    required this.icono2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 100,
          width: 400,
          decoration: BoxDecoration(
            color: AppColors.boton,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(pregunta, style: TextStyles.sansBody),
              const SizedBox(height: 12),
              SegmentedButton<bool>(
                segments: [
                  ButtonSegment(
                    value: false,
                    label: Text(opcion1),
                    icon: Icon(icono1),
                  ),
                  ButtonSegment(
                    value: true,
                    label: Text(opcion2),
                    icon: Icon(icono2),
                  ),
                ],
                selected: {value},
                multiSelectionEnabled: false,
                emptySelectionAllowed: false,
                onSelectionChanged: (set) => onChanged(set.first),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//boton de si quieres reportar un objeto perdido o encontrado
class BotonVentanaPersonaRutas {
  final WidgetBuilder? perdidoEstudiante;
  final WidgetBuilder? perdidoPersona;
  final WidgetBuilder? encontradoEstudiante;
  final WidgetBuilder? encontradoPersona;

  const BotonVentanaPersonaRutas({
    this.perdidoEstudiante,
    this.perdidoPersona,
    this.encontradoEstudiante,
    this.encontradoPersona,
  });

  WidgetBuilder? resolver({
    required bool personal,
    required bool tipoDeObjeto,
  }) {
    final esEncontrado = tipoDeObjeto;
    final esPersona = personal;

    if (!esEncontrado && !esPersona) return perdidoEstudiante;
    if (!esEncontrado && esPersona) return perdidoPersona;
    if (esEncontrado && !esPersona) return encontradoEstudiante;
    if (esEncontrado && esPersona) return encontradoPersona;
    return null;
  }
}

/// Botón CTA que navega según `personal` y `tipoDeObjeto`.
class BotonVentanaPersona extends StatelessWidget {
  final String texto;
  final bool personal; // true: Persona | false: Estudiante
  final bool tipoDeObjeto; // false: Perdido | true: Encontrado
  final BotonVentanaPersonaRutas rutas;

  final bool busy; // opcional: loading
  final IconData? icono; // opcional
  final String? tooltip; // opcional

  const BotonVentanaPersona({
    super.key,
    required this.texto,
    required this.personal,
    required this.tipoDeObjeto,
    required this.rutas,
    this.busy = false,
    this.icono,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final destino = rutas.resolver(
      personal: personal,
      tipoDeObjeto: tipoDeObjeto,
    );
    final enabled = !busy && destino != null;

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (busy) ...[
          const SizedBox(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
        ] else if (icono != null) ...[
          Icon(icono),
          const SizedBox(width: 8),
        ],
        Text(texto),
      ],
    );

    final button = ElevatedButton(
      onPressed: enabled
          ? () =>
                Navigator.of(context).push(MaterialPageRoute(builder: destino!))
          : null,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(220, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: child,
    );

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: tooltip == null
          ? button
          : Tooltip(message: tooltip!, child: button),
    );
  }
}
