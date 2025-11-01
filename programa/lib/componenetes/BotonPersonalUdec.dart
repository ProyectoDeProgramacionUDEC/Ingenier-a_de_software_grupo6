import 'dart:math';

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
class BotonTipoDeReporte extends StatelessWidget {
  const BotonTipoDeReporte({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}

/// Botón reutilizable; corrige el tipo `Bool` -> `bool`
class BotonVentanaPersona extends StatelessWidget {
  final WidgetBuilder navegar;
  final String texto;
  final bool personal; // true: persona, false: estudiante (si lo necesitas)

  const BotonVentanaPersona({
    super.key,
    required this.navegar,
    required this.texto,
    required this.personal,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            if (personal) {
              Navigator.push(context, MaterialPageRoute(builder: navegar));
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(200, 48),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(texto),
        ),
      ),
    );
  }
}
