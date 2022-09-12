// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layer.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LayerAdapter extends TypeAdapter<Layer> {
  @override
  final int typeId = 3;

  @override
  Layer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Layer(
      fields[0] as double,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      (fields[5] as List).cast<String>(),
      fields[6] as String,
      fields[10] as String?,
    )
      ..wtDepth = fields[7] as double
      ..pwtDepth = fields[8] as double
      ..pmDepth = fields[9] as double;
  }

  @override
  void write(BinaryWriter writer, Layer obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.depth)
      ..writeByte(1)
      ..write(obj.moisture)
      ..writeByte(2)
      ..write(obj.colour)
      ..writeByte(3)
      ..write(obj.consistency)
      ..writeByte(4)
      ..write(obj.structure)
      ..writeByte(5)
      ..write(obj.soilTypes)
      ..writeByte(6)
      ..write(obj.origin)
      ..writeByte(7)
      ..write(obj.wtDepth)
      ..writeByte(8)
      ..write(obj.pwtDepth)
      ..writeByte(9)
      ..write(obj.pmDepth)
      ..writeByte(10)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LayerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
