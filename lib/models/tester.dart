import 'package:hive/hive.dart';

part 'tester.g.dart'; // Add this part directive

@HiveType(typeId: 3)
class Tester {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String address;

  @HiveField(3)
  String phone;

  @HiveField(4)
  String companyName;

  @HiveField(5)
  String NICEICNumber;

  @HiveField(6)
  String calcardSerialNumber;

  @HiveField(7)
  String id = DateTime.now().toString();

  Tester({
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
    required this.companyName,
    required this.NICEICNumber,
    required this.calcardSerialNumber,
  });
}
