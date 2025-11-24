class Usuario {
  final String rut;
  final String nombre;
  final String numeroContacto;
  final String correoContacto;
  final bool esAdmin;
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