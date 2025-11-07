import 'package:flutter/material.dart';
import 'package:programa/Styles/Text.dart';
import 'package:programa/Styles/app_colors.dart';
import 'package:programa/ventanas/Administrador.dart';
import 'package:programa/ventanas/Tipo_de_usuario.dart';
import 'package:programa/ventanas/objetos_perdidos_screen.dart';

class VentanaInicioDeUsuario extends StatelessWidget {
  const VentanaInicioDeUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Ir a la ventana de reportar objeto
        BotonVentanaInicio(
          navegar: (context) => const VentanaDeReporteObjeto(),
          texto: "REPORTAR OBJETO",
        ),
        BotonVentanaInicio(
          navegar: (context) => const PerdidosScreen(),
          texto: "VER OBJETOS",
        ),
        BotonVentanaInicio(
          navegar: (context) => const VentanaAdministrador(),
          texto: "ADMINISTRADOR",
        ),
      ],
    );
  }
}

class BotonVentanaInicio extends StatelessWidget {
  final WidgetBuilder navegar;
  final String texto;

  const BotonVentanaInicio({
    super.key,
    required this.navegar,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: navegar));
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(200, 48),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            backgroundColor: AppColors.boton,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(texto, style: TextStyles.sansBody),
        ),
      ),
    );
  }
}
