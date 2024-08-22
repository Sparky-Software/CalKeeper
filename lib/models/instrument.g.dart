// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instrument.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InstrumentAdapter extends TypeAdapter<Instrument> {
  @override
  final int typeId = 0;

  @override
  Instrument read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Instrument(
      make: fields[0] as String,
      model: fields[1] as String,
      serialNum: fields[2] as String,
      acquisitionDate: fields[3] as String,
      tolerance: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Instrument obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.make)
      ..writeByte(1)
      ..write(obj.model)
      ..writeByte(2)
      ..write(obj.serialNum)
      ..writeByte(3)
      ..write(obj.acquisitionDate)
      ..writeByte(4)
      ..write(obj.tolerance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstrumentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
