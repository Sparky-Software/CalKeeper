// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tester.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TesterAdapter extends TypeAdapter<Tester> {
  @override
  final int typeId = 3;

  @override
  Tester read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tester(
      name: fields[0] as String,
      email: fields[1] as String,
      address: fields[2] as String,
      phone: fields[3] as String,
      companyName: fields[4] as String,
      NICEICNumber: fields[5] as String,
      calcardSerialNumber: fields[6] as String,
    )..id = fields[7] as String;
  }

  @override
  void write(BinaryWriter writer, Tester obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.companyName)
      ..writeByte(5)
      ..write(obj.NICEICNumber)
      ..writeByte(6)
      ..write(obj.calcardSerialNumber)
      ..writeByte(7)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TesterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
