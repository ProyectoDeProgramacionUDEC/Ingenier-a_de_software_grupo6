import 'package:flutter/material.dart';

class FilterDropdown extends StatelessWidget {
  final List<String> filtros;
  final String filtroSeleccionado;
  final ValueChanged<String?> alCambiarFiltro;

  const FilterDropdown({
    super.key,
    required this.filtros,
    required this.filtroSeleccionado,
    required this.alCambiarFiltro,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButtonFormField<String>(
        initialValue: filtroSeleccionado,
        decoration: InputDecoration(
          labelText: 'Filtrar por',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        items: filtros
            .map((f) => DropdownMenuItem(value: f, child: Text(f)))
            .toList(),
        onChanged: alCambiarFiltro,
      ),
    );
  }
}
