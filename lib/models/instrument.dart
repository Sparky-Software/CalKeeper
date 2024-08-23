import 'package:hive/hive.dart';
part 'instrument.g.dart'; // Add this part directive

@HiveType(typeId: 0)
class Instrument {

  @HiveField(0)
  String make;

  @HiveField(1)
  String model;

  @HiveField(2)
  String serialNum;

  @HiveField(3)
  String acquisitionDate;

  Instrument({
    required this.make,
    required this.model,
    required this.serialNum,
    required this.acquisitionDate,
  });
}
