import 'package:calcard_app/core/utils/theme.dart';
import 'package:calcard_app/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:provider/provider.dart';
import 'package:calcard_app/services/test_service.dart';
import 'package:calcard_app/pages/view_test/widgets/instrument_info.dart';
import 'package:calcard_app/pages/view_test/widgets/tester_info.dart';
import 'package:calcard_app/pages/view_test/widgets/test_point_grid.dart';
import 'package:calcard_app/core/pdf/pdf_service.dart';
import 'package:printing/printing.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestOverviewPage extends StatefulWidget {
  const TestOverviewPage({super.key});

  @override
  TestOverviewPageState createState() => TestOverviewPageState();
}

class TestOverviewPageState extends State<TestOverviewPage> {
  final GlobalKey _addTestPointButtonKey = GlobalKey();
  bool _showcased = false;

  @override
  void initState() {
    super.initState();
    _checkShowcaseStatus();
  }

  Future<void> _checkShowcaseStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _showcased = prefs.getBool('showcase_shown') ?? false;

    if (!_showcased) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([_addTestPointButtonKey]);
        prefs.setBool('showcase_shown', true); // Mark showcase as shown
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final testService = Provider.of<TestService>(context);
    final activeTest = testService.getActiveTest();

    if (activeTest == null || activeTest.instrument == null || activeTest.tester == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Test Overview'),
        ),
        body: const Center(
          child: Text('No active test or instrument available.'),
        ),
      );
    }
    else {
      final instrument = activeTest.instrument!;
      final tester = activeTest.tester;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Instrument Test Overview'),
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _performDelete(context);
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 150.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InstrumentInfo(instrument: instrument),
                  TesterInfo(tester: tester!),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(),
                  ),
                  if (activeTest.baseValues == null)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          "You haven't recorded a baseline reference yet, tap the '+' button to get started. Ideally, this should be done when the instrument is new or recently calibrated.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppTheme.textSizeMedium,
                            color: AppTheme.textColor1,
                          ),
                        ),
                      ),
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Baseline Reference',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Performed when the instrument is new or recently calibrated.',
                            style: TextStyle(
                              fontSize: AppTheme.textSizeSmall,
                              color: AppTheme.textColor2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (activeTest.baseValues != null)
                    TestPointGrid(testPoint: activeTest.baseValues!),
                  if (activeTest.baseValues != null)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Monthly Checks',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Monthly records of test instrument accuracy.',
                            style: TextStyle(
                              fontSize: AppTheme.textSizeSmall,
                              color: AppTheme.textColor2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (activeTest.testPoints.isNotEmpty)
                    for (final testPoint in activeTest.testPoints)
                      TestPointGrid(testPoint: testPoint),
                  if (!activeTest.testPoints.isNotEmpty&& activeTest.baseValues != null)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          "You haven't recorded any monthly checks yet.\nTap the '+' button each month to check instrument values are within tolerance.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.textColor1,
                            fontSize: AppTheme.textSizeMedium,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  // Align to the end (right)
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Showcase(
                      key: _addTestPointButtonKey,
                      title: 'Perform monthly check',
                      description: 'Tap this button to record the baseline reference values for a new instrument',
                      targetBorderRadius: BorderRadius.circular(100),
                      targetPadding: const EdgeInsets.all(10),
                      child: FloatingActionButton(
                        heroTag: 'addTestPointButton',
                        onPressed: () {
                          final activeTest = Provider.of<TestService>(
                              context, listen: false).getActiveTest();
                          activeTest?.activeTestPoint = null;
                          Navigator.pushNamed(context, '/newTestPointPage');
                        },
                        tooltip: 'Record a new monthly test point',
                        child: const Icon(Icons.add),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    FloatingActionButton.extended(
                      heroTag: 'exportPdfButton',
                      onPressed: () async {
                        final activeTest = Provider.of<TestService>(
                            context, listen: false).getActiveTest();
                        if (activeTest != null) {
                          final pdfService = PdfService();
                          final pdfData = await pdfService
                              .generateTestOverviewPdf(activeTest);
                          await Printing.layoutPdf(onLayout: (
                              PdfPageFormat format) async => pdfData);
                        }
                      },
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('Export to PDF'),
                      tooltip: 'Export test data to PDF',
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  void _performDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          onConfirm: () {
            final testService = Provider.of<TestService>(context, listen: false);
            testService.removeInstrumentTest(testService.getActiveTest()!);
            Navigator.pushNamed(context, '/home');
          }, title: 'Confirm Delete', content: 'Are you sure you want to delete the instrument? This will delete all the data about the instrument, and its test points. This action cannot be undone.',
        );
      },
    );
  }
}
