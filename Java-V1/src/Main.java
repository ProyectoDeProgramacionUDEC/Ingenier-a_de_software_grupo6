import java.util.*;

class Informe{
    private int fecha;
    private Casos caso;
}

class Objeto{
    private String nombre;
    private String Detalles;
}

abstract class Casos{
    private int id;

}

class CasosPerdidos extends Casos{}
class CasosEncontrados extends Casos{}

abstract class Usuario{
    private String nombre;
    private int rut;
    private Boolean interno;
    List<Objeto> objetos;
    List<CasosPerdidos> casosPerdidos;
    List<CasosEncontrados> casosEncontrados;

    Usuario(String nombre, int rut, Boolean interno) {
        this.nombre = nombre;
        this.rut = rut;
        this.interno = interno;
    }

    public void reportarEncuentro(){

    }
    public void reportarPerdida(){

    }

}

class UsuarioPierde extends Usuario{
    UsuarioPierde(String nombre, int rut, Boolean interno) {
        super(nombre, rut, interno);
    }
}
class UsuarioEncuentra extends Usuario{
    UsuarioEncuentra(String nombre, int rut, Boolean interno) {
        super(nombre, rut, interno);
    }
}

class Administrador{

}




public class Main {
    public static void main(String[] args) {
        new UsuarioPierde("Alberta", 23, true);

    }
}