class Reporte {
  final String nombre;
  final String descripcion;
  final DateTime fecha;
  final String imagenUrl;
  final bool encontrado;
  final String nombreUsuario;
  final String contactoUsuario;
  final bool PersonalUdec;
  final bool tipoObjeto;

  Reporte({
    required this.nombre,
    required this.fecha,
    required this.imagenUrl,
    required this.encontrado,
    this.descripcion = '',
    this.nombreUsuario = '',
    this.contactoUsuario = '',
    required this.PersonalUdec,
    required this.tipoObjeto,
  });
}
