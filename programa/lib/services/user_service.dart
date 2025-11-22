import 'package:flutter/material.dart';
import 'package:programa/Clases/usuario.dart';

class UserService extends ChangeNotifier {
  Usuario? _usuarioLogueado;
  bool _requierePasswordAdmin = false;
  
  Usuario? get usuarioLogueado => _usuarioLogueado;
  bool get isLoggedIn => _usuarioLogueado != null;
  bool get requierePasswordAdmin => _requierePasswordAdmin;
  
  bool login(String rut) {
    final usuario = UsuariosIniciales.buscarPorRUT(rut);
    if (usuario != null) {
      _usuarioLogueado = usuario;
      
      // Si es admin, requiere contraseña adicional
      if (usuario.esAdmin) {
        _requierePasswordAdmin = true;
      } else {
        _requierePasswordAdmin = false;
      }
      
      notifyListeners();
      return true;
    }
    return false;
  }
  
  bool verificarPasswordAdmin(String password) {
    if (_usuarioLogueado?.esAdmin == true && 
        _usuarioLogueado?.passwordAdmin == password) {
      _requierePasswordAdmin = false;
      notifyListeners();
      return true;
    }
    return false;
  }
  
  void cancelarLoginAdmin() {
    _usuarioLogueado = null;
    _requierePasswordAdmin = false;
    notifyListeners();
  }
  
  void logout() {
    _usuarioLogueado = null;
    _requierePasswordAdmin = false;
    notifyListeners();
  }
}