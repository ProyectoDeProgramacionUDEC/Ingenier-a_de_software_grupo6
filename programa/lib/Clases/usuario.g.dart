// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsuarioAdapter extends TypeAdapter<Usuario> {
  @override
  final int typeId = 0;

  @override
  Usuario read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Usuario(
      rut: fields[0] as String,
      nombre: fields[1] as String,
      numeroContacto: fields[2] as String,
      correoContacto: fields[3] as String,
      esAdmin: fields[4] as bool,
      passwordAdmin: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Usuario obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.rut)
      ..writeByte(1)
      ..write(obj.nombre)
      ..writeByte(2)
      ..write(obj.numeroContacto)
      ..writeByte(3)
      ..write(obj.correoContacto)
      ..writeByte(4)
      ..write(obj.esAdmin)
      ..writeByte(5)
      ..write(obj.passwordAdmin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsuarioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
