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

  Reporte copyWith({
    String? nombre,
    String? descripcion,
    DateTime? fecha,
    String? imagenUrl,
    bool? encontrado,
    String? nombreUsuario,
    String? contactoUsuario,
    bool? PersonalUdec,
    bool? tipoObjeto,
  }) {
    return Reporte(
      nombre: nombre ?? this.nombre,
      fecha: fecha ?? this.fecha,
      imagenUrl: imagenUrl ?? this.imagenUrl,
      encontrado: encontrado ?? this.encontrado,
      descripcion: descripcion ?? this.descripcion,
      nombreUsuario: nombreUsuario ?? this.nombreUsuario,
      contactoUsuario: contactoUsuario ?? this.contactoUsuario,
      PersonalUdec: PersonalUdec ?? this.PersonalUdec,
      tipoObjeto: tipoObjeto ?? this.tipoObjeto,
    );
  }
}
