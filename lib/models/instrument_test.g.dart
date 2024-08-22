// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instrument_test.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InstrumentTestAdapter extends TypeAdapter<InstrumentTest> {
  @override
  final int typeId = 2;

  @override
  InstrumentTest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InstrumentTest(
      instrument: fields[0] as Instrument?,
      tester: fields[1] as Tester?,
      baseValues: fields[2] as InstrumentTestPoint?,
      testPoints: (fields[3] as List?)?.cast<InstrumentTestPoint>(),
    )
      ..id = fields[4] as String
      ..activeTestPoint = fields[5] as InstrumentTestPoint?;
  }

  @override
  void write(BinaryWriter writer, InstrumentTest obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.instrument)
      ..writeByte(1)
      ..write(obj.tester)
      ..writeByte(2)
      ..write(obj.baseValues)
      ..writeByte(3)
      ..write(obj.testPoints)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.activeTestPoint);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstrumentTestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
