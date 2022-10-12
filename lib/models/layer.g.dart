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
    return Layer()
      ..depth = fields[0] as double
      ..moisture = fields[1] as String
      ..colour = fields[2] as String
      ..consistency = fields[3] as String
      ..structure = fields[4] as String
      ..soilTypes = (fields[5] as List).cast<String>()
      ..origin = fields[6] as String
      ..wtDepth = fields[7] as double?
      ..pwtDepth = fields[8] as double?
      ..smplDepth = fields[9] as double?
      ..notes = fields[10] as String?
      ..createdDate = fields[11] as DateTime
      ..originType = fields[12] as String?
      ..colourPattern = fields[13] as String?
      ..otherColour = fields[14] as String?;
  }

  @override
  void write(BinaryWriter writer, Layer obj) {
    writer
      ..writeByte(15)
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
      ..write(obj.smplDepth)
      ..writeByte(10)
      ..write(obj.notes)
      ..writeByte(11)
      ..write(obj.createdDate)
      ..writeByte(12)
      ..write(obj.originType)
      ..writeByte(13)
      ..write(obj.colourPattern)
      ..writeByte(14)
      ..write(obj.otherColour);
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
