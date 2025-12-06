import 'package:hive/hive.dart';
import 'package:programa/Clases/usuario.dart';

class GestorUsuarios {
  static final GestorUsuarios _instancia = GestorUsuarios._internal();
  
  factory GestorUsuarios() {
    return _instancia;
  }

  late Box<Usuario> _caja;

  GestorUsuarios._internal() {
    // Obtenemos la caja que ya abrimos en el main.dart
    _caja = Hive.box<Usuario>('box_usuarios');

    // Solo si la caja está vacía registramos los usuarios por default
    if (_caja.isEmpty) {
      _cargarUsuariosIniciales();
    }
  }

  // Obtener todos: Convertimos los valores de Hive a una lista
  List<Usuario> obtenerTodos() => _caja.values.toList();

  // Agregar nuevo usuario (Persistente)
  bool agregarUsuario(Usuario nuevoUsuario) {
    if (existeUsuario(nuevoUsuario.rut)) {
      print("Error: El usuario ya existe.");
      return false; 
    }
    
    // Usamos el RUT como 'key' en Hive
    _caja.put(nuevoUsuario.rut, nuevoUsuario);
    
    print("Usuario ${nuevoUsuario.nombre} guardado en disco correctamente.");
    return true;
  }

  Usuario? buscarPorRUT(String rut) {
    return _caja.get(rut);
  }

  bool existeUsuario(String rut) {
    // Verificamos si la llave (RUT) existe en la caja
    return _caja.containsKey(rut);
  }

  bool eliminarUsuario(String rut) {
    if (existeUsuario(rut)) {
      _caja.delete(rut); // Borramos de disco
      return true;
    }
    return false;
  }

  // Esta función es privada y solo se llama si la caja está vacía
  void _cargarUsuariosIniciales() {
    print("Inicializando base de datos con usuarios por defecto...");
    
    final listaInicial = [
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
    ];

    // Guardamos cada uno usando su RUT como llave
    for (var usuario in listaInicial) {
      _caja.put(usuario.rut, usuario);
    }
  }
}