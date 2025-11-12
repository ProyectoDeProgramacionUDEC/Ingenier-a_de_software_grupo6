import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String> alCambiarBusqueda;

  const SearchBarWidget({super.key, required this.alCambiarBusqueda});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: alCambiarBusqueda,
        decoration: InputDecoration(
          hintText: 'Ingresa objeto para buscar',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
