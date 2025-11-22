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

  static Usuario? autenticar(String rut) {
    try {
      return UsuariosIniciales.listaUsuarios.firstWhere(
        (usuario) => usuario.rut == rut
      );
    } catch (e) {
      return null;
    }
  }

  bool validarRUT() {
    final rutRegex = RegExp(r'^\d+$');
    return rutRegex.hasMatch(rut);
  }

  bool validarEmail() {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(correoContacto);
  }

  Map<String, dynamic> toMap() {
    return {
      'rut': rut,
      'nombre': nombre,
      'numeroContacto': numeroContacto,
      'correoContacto': correoContacto,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      rut: map['rut'] ?? '',
      nombre: map['nombre'] ?? '',
      numeroContacto: map['numeroContacto'] ?? '',
      correoContacto: map['correoContacto'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Usuario(rut: $rut, nombre: $nombre, teléfono: $numeroContacto, email: $correoContacto)';
  }
}

class UsuariosIniciales {
  static final List<Usuario> listaUsuarios = [
    Usuario(
      rut: '218012493',
      nombre: 'Benjamin Diaz Ulloa',
      numeroContacto: '+56999999999',
      correoContacto: 'benja@udec.cl',
      esAdmin: true,
      passwordAdmin: 'admin123',
    ),
    Usuario(
      rut: '111111111',
      nombre: 'Admin Juan Perez',
      numeroContacto: '+56988888888',
      correoContacto: 'JPerez.admin@udec.cl',
      esAdmin: true,
    ),
    Usuario(
      rut: '456789123',
      nombre: 'María Fernández Silva',
      numeroContacto: '+56901010101',
      correoContacto: 'maria.fernandez@udec.cl',
      esAdmin: false
    ),
  ];

  static Usuario? buscarPorRUT(String rut) {
    try {
      return listaUsuarios.firstWhere((usuario) => usuario.rut == rut);
    } catch (e) {
      return null;
    }
  }

  static bool existeUsuario(String rut) {
    return listaUsuarios.any((usuario) => usuario.rut == rut);
  }

  static List<Usuario> obtenerTodos() {
    return listaUsuarios;
  }
}
