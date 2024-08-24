import 'package:Cal_Keeper/models/tester.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/theme.dart';
import '../../../services/test_service.dart';
import '../../../services/tester_service.dart';

class TesterButton extends StatelessWidget {
  final Tester tester;
  const TesterButton({super.key, required this.tester});

  @override
  Widget build(BuildContext context) {
    final List<String> subtitleLines = [];

    if(tester.name.isNotEmpty) {
      subtitleLines.add('Name: ${tester.name}');
    }

    if(tester.companyName.isNotEmpty) {
      subtitleLines.add('Company: ${tester.companyName}');
    }

    if (tester.email.isNotEmpty) {
      subtitleLines.add('Email: ${tester.email}');
    }
    if (tester.address.isNotEmpty) {
      subtitleLines.add('Address: ${tester.address}');
    }
    if (tester.phone.isNotEmpty) {
      subtitleLines.add('Phone: ${tester.phone}');
    }
    if (tester.NICEICNumber.isNotEmpty) {
      subtitleLines.add('NICEIC Number: ${tester.NICEICNumber}');
    }
    if (tester.calcardSerialNumber.isNotEmpty) {
      subtitleLines.add('Calcard Serial Number: ${tester.calcardSerialNumber}');
    }

    return Card(
      color: AppTheme.textBoxColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        title: Text(
          tester.name.isNotEmpty ? tester.name : (tester.companyName.isNotEmpty ? tester.companyName : 'Unknown Tester'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, height: 1.2),
        ),
        subtitle: Text(
          subtitleLines.join('\n'),
          style: const TextStyle(fontSize: 18),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: AppTheme.accentColor, size: 40.0),
          onPressed: () {
            TesterService testerService = Provider.of<TesterService>(context, listen: false);
            testerService.setActiveTester(tester);
            testerService.inTestCreation = true;
            Navigator.pushNamed(context, '/testerDetailsPage');
          },
        ),
        onTap: () {
          TestService testService = Provider.of<TestService>(context, listen: false);
          testService.updateTester(testService.getActiveTest()!, tester);
          TesterService testerService = Provider.of<TesterService>(context, listen: false);
          testerService.clearActiveTester();
          testService.clearActiveTest();
          Navigator.pushNamed(context, '/home');
        },
      ),
    );
  }
}
