// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reporte.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReporteAdapter extends TypeAdapter<Reporte> {
  @override
  final int typeId = 1;

  @override
  Reporte read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reporte(
      nombre: fields[0] as String,
      descripcion: fields[1] as String,
      fecha: fields[2] as DateTime,
      imagenUrl: fields[3] as String,
      estado: fields[4] as bool,
      nombreUsuario: fields[5] as String,
      contactoUsuario: fields[6] as String,
      PersonalUdec: fields[7] as bool,
      tipoObjeto: fields[8] as bool,
      rutUsuario: fields[9] as String,
      ubicacion: fields[10] as String, // <--- ESTO APARECERÁ SOLO
    );
  }

  @override
  void write(BinaryWriter writer, Reporte obj) {
    writer
      ..writeByte(11) // <--- Ahora dirá 11 campos
      ..writeByte(0)
      ..write(obj.nombre)
      ..writeByte(1)
      ..write(obj.descripcion)
      ..writeByte(2)
      ..write(obj.fecha)
      ..writeByte(3)
      ..write(obj.imagenUrl)
      ..writeByte(4)
      ..write(obj.estado)
      ..writeByte(5)
      ..write(obj.nombreUsuario)
      ..writeByte(6)
      ..write(obj.contactoUsuario)
      ..writeByte(7)
      ..write(obj.PersonalUdec)
      ..writeByte(8)
      ..write(obj.tipoObjeto)
      ..writeByte(9)
      ..write(obj.rutUsuario)
      ..writeByte(10) // <--- ESTO APARECERÁ SOLO
      ..write(obj.ubicacion); // <--- ESTO APARECERÁ SOLO
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReporteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
