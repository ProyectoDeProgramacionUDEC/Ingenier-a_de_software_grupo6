import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:programa/services/user_service.dart';
import 'package:programa/Clases/ReporteService.dart';
import 'package:programa/ventanas/login_screen.dart';
import 'package:programa/ventanas/menu_principal_screen.dart';
import 'package:programa/Clases/usuario.dart';
import 'package:programa/Clases/reporte.dart';
// import 'package:flutter_localizations/flutter_localizations.dart'; // Opcional: Para eventualmente poner las fechas en español

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UsuarioAdapter());
  Hive.registerAdapter(ReporteAdapter());
  
  await Hive.openBox<Usuario>('box_usuarios');
  await Hive.openBox<Reporte>('box_reportes');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserService()),
        ChangeNotifierProvider(create: (context) => ReporteService()),
      ],
      child: MaterialApp(
        title: 'Objetos perdidos UdeC',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
        home: const LoginScreen(),
        routes: {'/menu_principal': (context) => const MenuPrincipalScreen()},
      ),
    );
  }
}
