import 'package:flutter/material.dart';
import 'package:programa/Styles/Text.dart';
import 'package:programa/Styles/app_colors.dart';
import 'package:programa/ventanas/Ventana_inicio_de_usuario.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Objetos perdidos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const MenuPrincipal(),
    );
  }
}

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Barra_arriba(),
      body: const VentanaInicioDeUsuario(),
    );
  }

  AppBar Barra_arriba() {
    return AppBar(
      backgroundColor: AppColors.primay,
      foregroundColor: AppColors.secondary,
      centerTitle: true,
      leadingWidth: 200,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: SizedBox(
          width: 100,
          height: 48,
          child: Image.asset('assets/images/LogoUdec.png', fit: BoxFit.contain),
        ),
      ),
      title: Text("Objetos perdidos", style: TextStyles.sansTitle),
    );
  }
}
