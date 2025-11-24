import 'package:hive/hive.dart';

part 'reporte.g.dart';

@HiveType(typeId: 1) // ID único para Reporte 
class Reporte extends HiveObject {
  @HiveField(0)
  final String nombre;
  @HiveField(1)
  final String descripcion;
  @HiveField(2)
  final DateTime fecha;
  @HiveField(3)
  final String imagenUrl;
  @HiveField(4)
  final bool encontrado;
  @HiveField(5)
  final String nombreUsuario;
  @HiveField(6)
  final String contactoUsuario;
  @HiveField(7)
  final bool PersonalUdec;
  @HiveField(8)
  final bool tipoObjeto;
  @HiveField(9)
  final String rutUsuario;

  Reporte ({
    required this.nombre,
    required this.fecha,
    required this.imagenUrl,
    required this.encontrado,
    this.descripcion = '',
    this.nombreUsuario = '',
    this.contactoUsuario = '',
    required this.PersonalUdec,
    required this.tipoObjeto,
    required this.rutUsuario
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
    String? rutUsuario, 
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
      rutUsuario: rutUsuario ?? this.rutUsuario
    );
  }
}
