import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:programa/services/user_service.dart';
import 'package:programa/Clases/ReporteService.dart';
import 'package:programa/ventanas/login_screen.dart';
import 'package:programa/ventanas/menu_principal_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ReporteService()),
        ChangeNotifierProvider(create: (context) => UserService()),
      ],
      child: MaterialApp(
        title: 'Objetos perdidos',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: const LoginScreen(),
        routes: {
          '/menu_principal': (context) => const MenuPrincipalScreen(),
        },
      ),
    );
  }
}