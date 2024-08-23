import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calcard_app/core/utils/theme.dart';
import 'package:calcard_app/models/instrument_test.dart';
import 'package:calcard_app/services/test_service.dart';
import 'package:showcaseview/showcaseview.dart';
class InstrumentTestButton extends StatelessWidget {
  final InstrumentTest test;
  final GlobalKey showcaseKey;

  const InstrumentTestButton({super.key, required this.test, required this.showcaseKey});

  @override
  Widget build(BuildContext context) {
    final instrument = test.instrument;
    String lastTestDate;

    if (test.baseValues == null) {
      lastTestDate = 'No checks recorded';
    } else if (test.testPoints.isEmpty) {
      lastTestDate = test.baseValues!.date;
    } else {
      lastTestDate = test.testPoints.last.date;
    }
    final List<String> subtitleLines = [];

    subtitleLines.add('Last Check: $lastTestDate');
    subtitleLines.add('Tested by: ${test.tester?.name ?? 'Unknown'}');

    final String title = '${instrument?.make} ${instrument?.model}';

    return GestureDetector(
      onTap: () {
        TestService testService = Provider.of<TestService>(context, listen: false);
        testService.setActiveTest(test);
        Navigator.pushNamed(context, test.tester == null ? '/selectTesterPage' : '/testOverview');
      },
      child: Card(
        color: AppTheme.textBoxColor,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppTheme.textSizeLarge,
              height: 1.2,
            ),
          ),
          subtitle: Text(
            subtitleLines.join('\n'),
            style: const TextStyle(fontSize: AppTheme.textSizeMedium),
          ),
          trailing: Showcase(
            key: showcaseKey,
            title: 'Go to instrument overview page',
            description:
            'Tap the "new check" icon to view an instrument\'s past monthly checks and perform new ones.',
            targetBorderRadius: BorderRadius.circular(20),
            targetPadding: const EdgeInsets.all(5),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.buttonTextColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 2), // Shadow position
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8.0), // Padding inside the button
              child: const Icon(
                Icons.add_chart,
                color: AppTheme.accentColor,
                size: 40.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

