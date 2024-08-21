// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instrument_test_point.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InstrumentTestPointAdapter extends TypeAdapter<InstrumentTestPoint> {
  @override
  final int typeId = 1;

  @override
  InstrumentTestPoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InstrumentTestPoint(
      date: fields[0] as String,
      insulation: (fields[1] as List).cast<double>(),
      continuity: (fields[2] as List).cast<double>(),
      zs: fields[3] as double,
      rcd: fields[4] as double,
      isBaseline: fields[5] as bool,
      state: fields[6] as String,
      isOverridePass: fields[7] as bool,
      id: fields[8] as String,
      remedialAction: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, InstrumentTestPoint obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.insulation)
      ..writeByte(2)
      ..write(obj.continuity)
      ..writeByte(3)
      ..write(obj.zs)
      ..writeByte(4)
      ..write(obj.rcd)
      ..writeByte(5)
      ..write(obj.isBaseline)
      ..writeByte(6)
      ..write(obj.state)
      ..writeByte(7)
      ..write(obj.isOverridePass)
      ..writeByte(8)
      ..write(obj.id)
      ..writeByte(9)
      ..write(obj.remedialAction);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstrumentTestPointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
