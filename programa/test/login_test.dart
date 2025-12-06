import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:programa/Clases/usuario.dart';
import 'package:programa/Clases/reporte.dart';
import 'package:programa/ventanas/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:programa/services/user_service.dart';
import 'package:programa/Clases/ReporteService.dart';

class MockUserService extends ChangeNotifier implements UserService {
  @override
  Usuario? usuarioLogueado;
  @override
  bool isLoggedIn = false;
  
  @override
  bool login(String rut) {
    if (rut == '123') return true; // Simulación de logueo exitoso
    return false;
  }

  @override
  bool requierePasswordAdmin = false;
  @override
  void cancelarLoginAdmin() {}
  @override
  void logout() {}
  @override
  bool verificarPasswordAdmin(String password) => true;
}

class MockReporteService extends ChangeNotifier implements ReporteService {
  // Implementación de 'agregarNuevoReporte'
  @override
  void agregarNuevoReporte(Reporte r) {}

  // obtenerReportesVisibles debe retornar una lista, aunque sea vacía...
  @override
  List<Reporte> obtenerReportesVisibles(Usuario? usuarioLogueado) {
    return [];
  }
  // Implementación de 'actualizarEstadoReporte'
  @override
  void actualizarEstadoReporte(Reporte reporteOriginal, bool nuevoEstado) {}

  //  Implementación de 'actualizarReporte'
  @override
  void actualizarReporte(Reporte reporteAntiguo, Reporte reporteNuevo) {}

  // Implementación de 'borrarReporte'
  @override
  void borrarReporte(Reporte reporte) {}
}

// Testeos Unitarios y de Widget

void main() {
  
  group('Pruebas Unitarias - Clase Usuario', () {
    test('Un usuario nuevo debería no ser administrador por defecto', () {
      final usuario = Usuario(
        rut: '11111111-1',
        nombre: 'Test User',
        numeroContacto: '123456',
        correoContacto: 'test@udec.cl',
      );

      expect(usuario.esAdmin, false);
    });

    test('Un usuario creado como admin debe guardar el estado', () {
      final admin = Usuario(
        rut: '22222222-2',
        nombre: 'Admin User',
        numeroContacto: '123456',
        correoContacto: 'admin@udec.cl',
        esAdmin: true,
      );

      expect(admin.esAdmin, true);
    });
  });

  // Widget Tests para LoginScreen
  group('Pruebas de UI - LoginScreen', () {
    testWidgets('La pantalla de login debe mostrar input de RUT y botones', (WidgetTester tester) async {
      
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<UserService>(create: (_) => MockUserService()),
            ChangeNotifierProvider<ReporteService>(create: (_) => MockReporteService()),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Simulamos la búsqueda de elementos en pantalla
      final campoRut = find.byType(TextField); 
      final botonLogin = find.text('Iniciar Sesión');
      final botonRegistro = find.textContaining('Regístrate');

      expect(campoRut, findsOneWidget);
      expect(botonLogin, findsOneWidget);
      expect(botonRegistro, findsOneWidget);
    });

    testWidgets('Mostrar error si se intenta login vacío', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<UserService>(create: (_) => MockUserService()),
            ChangeNotifierProvider<ReporteService>(create: (_) => MockReporteService()),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Intentamos hacer tap en el botón de login sin ingresar RUT
      await tester.tap(find.text('Iniciar Sesión'));
      
      // Esperar que el sistema entregue una animación 
      await tester.pump(); 

      // Verificar que retorne mensaje de error
      expect(find.text('Por favor ingresa tu RUT'), findsOneWidget);
    });
  });
}