import 'package:hive/hive.dart';
import 'instrument.dart';
import 'instrument_test_point.dart';
import 'tester.dart';

part 'instrument_test.g.dart'; // Add this part directive

@HiveType(typeId: 2)
class InstrumentTest {
  @HiveField(0)
  Instrument? instrument;

  @HiveField(1)
  Tester? tester;

  @HiveField(2)
  InstrumentTestPoint? baseValues;

  @HiveField(3)
  List<InstrumentTestPoint> testPoints;

  @HiveField(4)
  String id = DateTime.now().toString();

  @HiveField(5)
  InstrumentTestPoint? activeTestPoint;

  InstrumentTest({
    this.instrument,
    this.tester,
    this.baseValues,
    List<InstrumentTestPoint>? testPoints,
  }) : testPoints = testPoints ?? [];
}
