import 'package:hive/hive.dart';

part 'usuario.g.dart';

@HiveType(typeId: 0)
class Usuario {
@HiveField(0)
  final String rut;
  @HiveField(1)
  final String nombre;
  @HiveField(2)
  final String numeroContacto;
  @HiveField(3)
  final String correoContacto;
  @HiveField(4)
  final bool esAdmin;
  @HiveField(5)
  final String? passwordAdmin;

  Usuario({
    required this.rut,
    required this.nombre,
    required this.numeroContacto,
    required this.correoContacto,
    this.esAdmin = false,
    this.passwordAdmin,
  });

  bool validarRUT() {
    final rutRegex = RegExp(r'^\d+$');
    return rutRegex.hasMatch(rut);
  }

  bool validarEmail() {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(correoContacto);
  }

  @override
  String toString() => 'Usuario(rut: $rut, nombre: $nombre)';
}