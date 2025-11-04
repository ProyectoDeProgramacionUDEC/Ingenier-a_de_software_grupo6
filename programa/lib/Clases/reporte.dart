class Reporte {
  final String nombre;
  final String descripcion;
  final DateTime fecha;
  final String imagenUrl;
  final bool encontrado;
  final String nombreUsuario;
  final String contactoUsuario;

  Reporte({
    required this.nombre,
    required this.fecha,
    required this.imagenUrl,
    required this.encontrado,
    this.descripcion = '',
    this.nombreUsuario = '',
    this.contactoUsuario = '',
  });
}
