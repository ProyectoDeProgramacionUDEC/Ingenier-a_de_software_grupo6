import 'package:flutter/material.dart';
import 'package:programa/Clases/reporte_list.dart';
import 'package:programa/Styles/appBar.dart';
import 'package:provider/provider.dart';
import 'package:programa/Clases/ReporteService.dart';
import 'package:programa/services/user_service.dart';

class PerdidosScreen extends StatelessWidget {
  const PerdidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos el usuario y verificamos si es admin
    final usuarioLogueado = Provider.of<UserService>(context).usuarioLogueado;
    final bool esAdmin = usuarioLogueado?.esAdmin ?? false;

    return Consumer<ReporteService>(
      builder: (context, reporteService, child) {
        // Obtenemos la lista base (Filtrada por seguridad de Hive/Usuario)
        final listaSegura = reporteService.obtenerReportesVisibles(
          usuarioLogueado,
        );

        // Filtramos solo los que no están encontrados (Perdidos)
        final perdidos = listaSegura.where((r) => !r.estado).toList();

        return Scaffold(
          appBar: UdecAppBarRightLogo(title: "OBJETOS Perdidos"),
          body: perdidos.isEmpty
              ? const Center(child: Text("No tienes objetos perdidos activos"))
              : ListaReportes(reportes: perdidos, esAdministrador: esAdmin),
        );
      },
    );
  }
}
