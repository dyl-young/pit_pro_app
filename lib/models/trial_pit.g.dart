// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trial_pit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrialPitAdapter extends TypeAdapter<TrialPit> {
  @override
  final int typeId = 2;

  @override
  TrialPit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrialPit()
      ..pitNumber = fields[0] as String
      ..createdDate = fields[1] as DateTime
      ..elevation = fields[3] as double
      ..wtDepth = fields[4] as double
      ..pwtDepth = fields[5] as double
      ..pmDepth = fields[6] as double
      ..layersList = (fields[7] as List).cast<Layer>();
  }

  @override
  void write(BinaryWriter writer, TrialPit obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.pitNumber)
      ..writeByte(1)
      ..write(obj.createdDate)
      ..writeByte(2)
      ..write(obj.coordinates)
      ..writeByte(3)
      ..write(obj.elevation)
      ..writeByte(4)
      ..write(obj.wtDepth)
      ..writeByte(5)
      ..write(obj.pwtDepth)
      ..writeByte(6)
      ..write(obj.pmDepth)
      ..writeByte(7)
      ..write(obj.layersList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrialPitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
