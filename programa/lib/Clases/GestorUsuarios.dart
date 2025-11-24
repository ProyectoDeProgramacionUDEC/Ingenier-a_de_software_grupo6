import 'package:programa/Clases/usuario.dart';

class GestorUsuarios {
  // 1. Patrón Singleton: la lista será única en toda la app
  static final GestorUsuarios _instancia = GestorUsuarios._internal();
  
  factory GestorUsuarios() {
    return _instancia;
  }

  GestorUsuarios._internal() {
    // Aquí cargamos los datos iniciales solo una vez
    _usuarios.addAll(_usuariosIniciales);
  }

  // 2. La lista es privada (_usuarios) para protegerla
  final List<Usuario> _usuarios = [];

  // Datos semilla (opcional, solo para pruebas)
  final List<Usuario> _usuariosIniciales = [
     Usuario(
      rut: '218012493',
      nombre: 'Benjamin Diaz Ulloa',
      numeroContacto: '+56999999999',
      correoContacto: 'benja@udec.cl',
      esAdmin: true,
      passwordAdmin: 'admin123',
    ),
    Usuario(
      rut: '219066457',
      nombre: 'Ariel Fernández Fuentealba',
      numeroContacto: '+56999999999',
      correoContacto: 'ariel@udec.cl',
      esAdmin: false,
      passwordAdmin: null,
    ),
    Usuario(
      rut: '215347956',
      nombre: 'Kurt Koserak Ortiz',
      numeroContacto: '+56999999999',
      correoContacto: 'kurt@udec.cl',
      esAdmin: false,
      passwordAdmin: null,
    ),
    // ... otros usuarios iniciales
  ];

  // --- MÉTODOS PÚBLICOS

  // Obtener todos (devuelve una copia para seguridad)
  List<Usuario> obtenerTodos() => List.unmodifiable(_usuarios);

  // Agregar nuevo usuario dinámicamente
  bool agregarUsuario(Usuario nuevoUsuario) {
    if (existeUsuario(nuevoUsuario.rut)) {
      print("Error: El usuario ya existe.");
      return false; 
    }
    _usuarios.add(nuevoUsuario);
    print("Usuario ${nuevoUsuario.nombre} agregado correctamente.");
    return true;
  }

  Usuario? buscarPorRUT(String rut) {
    try {
      return _usuarios.firstWhere((u) => u.rut == rut);
    } catch (e) {
      return null;
    }
  }

  bool existeUsuario(String rut) {
    return _usuarios.any((u) => u.rut == rut);
  }

  bool eliminarUsuario(String rut) {
    int inicial = _usuarios.length;
    _usuarios.removeWhere((u) => u.rut == rut);
    return _usuarios.length < inicial;
  }
}