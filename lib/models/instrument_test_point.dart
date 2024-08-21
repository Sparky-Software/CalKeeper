import 'package:hive/hive.dart';

part 'instrument_test_point.g.dart';
@HiveType(typeId: 1)
class InstrumentTestPoint {
  @HiveField(0)
  String date;

  @HiveField(1)
  List<double> insulation;

  @HiveField(2)
  List<double> continuity;

  @HiveField(3)
  double zs;

  @HiveField(4)
  double rcd;

  @HiveField(5)
  bool isBaseline;

  @HiveField(6)
  String state;

  @HiveField(7)
  bool isOverridePass;

  @HiveField(8)
  String id;

  @HiveField(9)
  String? remedialAction;

  InstrumentTestPoint({
    required this.date,
    required this.insulation,
    required this.continuity,
    required this.zs,
    required this.rcd,
    this.isBaseline = false,
    this.state = "pass",
    this.isOverridePass = false,
    required this.id,
    this.remedialAction,
  });
}