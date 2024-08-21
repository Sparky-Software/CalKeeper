import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/theme.dart';
import 'package:calcard_app/models/tester.dart';

import '../../../services/tester_service.dart'; // Import the Tester model

class TesterInfo extends StatelessWidget {
  final Tester tester;

  const TesterInfo({super.key, required this.tester});

  @override
  Widget build(BuildContext context) {
    final List<String> subtitleLines = [];
    if(tester.name.isNotEmpty) subtitleLines.add('Tested by: ${tester.name}');
    if(tester.email.isNotEmpty) subtitleLines.add('Email: ${tester.email}');
    if(tester.phone.isNotEmpty) subtitleLines.add('Phone: ${tester.phone}');
    if(tester.companyName.isNotEmpty) subtitleLines.add('Company: ${tester.companyName}');
    if(tester.NICEICNumber.isNotEmpty) subtitleLines.add('NICEIC Number: ${tester.NICEICNumber}');
    if(tester.calcardSerialNumber.isNotEmpty) subtitleLines.add('Calcard Serial Number: ${tester.calcardSerialNumber}');

    return Card(
        color: AppTheme.textBoxColor,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          title: const Text(
            'Test Engineer Details',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppTheme.textSizeLarge, height: 1.2),
          ),
          subtitle: Text(
            subtitleLines.join('\n'),
            style: const TextStyle(fontSize: AppTheme.textSizeMedium),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit, color: AppTheme.accentColor), // Set icon color and size
            color: AppTheme.accentColor,
            onPressed: () {
              Provider.of<TesterService>(context, listen: false).setActiveTester(tester);
              Navigator.pushNamed(context, '/testerDetailsPage');
            },
          ),
        ),
    );
  }
}
