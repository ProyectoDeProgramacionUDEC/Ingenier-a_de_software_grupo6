import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:programa/ventanas/agregar_reporte_screen.dart';
import 'package:programa/services/user_service.dart';
import 'package:programa/Clases/ReporteService.dart';
import 'package:programa/Clases/usuario.dart';
import 'package:programa/Clases/reporte.dart';

class MockUserService extends ChangeNotifier implements UserService {
  @override
  Usuario? get usuarioLogueado => Usuario(
    rut: '12345678-9',
    nombre: 'Tester',
    numeroContacto: '123',
    correoContacto: 'test@mail.com',
    esAdmin: false
  );
  
  @override bool get isLoggedIn => true;
  @override bool login(String r) => true;
  @override bool requierePasswordAdmin = false;
  @override void cancelarLoginAdmin() {}
  @override void logout() {}
  @override bool verificarPasswordAdmin(String p) => true;
}

class MockReporteService extends ChangeNotifier implements ReporteService {
  Reporte? ultimoReporteAgregado;

  @override
  void agregarNuevoReporte(Reporte r) {
    ultimoReporteAgregado = r; 
  }

  @override void actualizarEstadoReporte(Reporte a, bool b) {}
  @override void actualizarReporte(Reporte a, Reporte b) {}
  @override void borrarReporte(Reporte r) {}
  @override List<Reporte> obtenerReportesVisibles(Usuario? u) => [];
  @override get todosLosReportes => []; 
}

void main() {
  group('Pruebas Historia #05 - Ubicación en Reporte', () {
    
    testWidgets('Debe mostrar campo de ubicación y botón de GPS', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<UserService>(create: (_) => MockUserService()),
            ChangeNotifierProvider<ReporteService>(create: (_) => MockReporteService()),
          ],
          child: const MaterialApp(
            home: AgregarReporteScreen(esEncontrado: false, personalUdec: true),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final campoUbicacion = find.widgetWithText(TextFormField, 'Ubicación / Referencia');
      final botonGPS = find.byIcon(Icons.my_location);

      expect(campoUbicacion, findsOneWidget, reason: "El campo de texto para ubicación debe existir");
      expect(botonGPS, findsOneWidget, reason: "El botón de GPS debe estar presente");
    });

    testWidgets('Al guardar el reporte, la ubicación escrita debe persistir', (WidgetTester tester) async {
      
      tester.view.physicalSize = const Size(1080, 4000); 
      tester.view.devicePixelRatio = 1.0;
      
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final mockReporteService = MockReporteService();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<UserService>(create: (_) => MockUserService()),
            ChangeNotifierProvider<ReporteService>(create: (_) => mockReporteService),
          ],
          child: const MaterialApp(
            home: AgregarReporteScreen(esEncontrado: false, personalUdec: true),
          ),
        ),
      );

      await tester.pumpAndSettle(); 

      // Simulamos el relleno de un reporte
      await tester.enterText(find.widgetWithText(TextFormField, 'Nombre del objeto *'), 'Mochila Test');
      
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Ubicación / Referencia'), 
        'Biblioteca Central, Piso 3'
      );

      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();

      final botonGuardarFinder = find.text('Agregar Reporte');
      expect(botonGuardarFinder, findsOneWidget, reason: "El botón debe ser visible tras cerrar el teclado");

      await tester.tap(botonGuardarFinder);
      
      await tester.pump(); 
      await tester.pump(); 

      expect(mockReporteService.ultimoReporteAgregado, isNotNull, reason: "El servicio no recibió el reporte");
      expect(mockReporteService.ultimoReporteAgregado!.nombre, 'Mochila Test');
      expect(
        mockReporteService.ultimoReporteAgregado!.ubicacion, 
        'Biblioteca Central, Piso 3',
        reason: "La ubicación escrita no se guardó en el objeto Reporte final"
      );
    });
  });
}