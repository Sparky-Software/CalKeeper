import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:calcard_app/core/utils/theme.dart';
import 'package:calcard_app/services/test_service.dart';
import 'package:calcard_app/pages/home/widgets/instrument_test_button.dart';
import 'package:calcard_app/widgets/settings_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey _newInstrumentKey = GlobalKey();
  final GlobalKey _chartButtonKey = GlobalKey(); // Key for the chart showcase

  @override
  void initState() {
    super.initState();
    _checkShowcaseStatus();
  }

  Future<void> _checkShowcaseStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasShownNewInstrumentHint = prefs.getBool('hasShownNewInstrumentHint') ?? false;
    final hasShownChartHint = prefs.getBool('hasShownChartHint') ?? false;

    if (!hasShownNewInstrumentHint) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context)?.startShowCase([_newInstrumentKey]);
        prefs.setBool('hasShownNewInstrumentHint', true);
      });
    } else if (!hasShownChartHint) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context)?.startShowCase([_chartButtonKey]);
        prefs.setBool('hasShownChartHint', true);
      });
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SettingsDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Electrical Test Instruments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      body: Consumer<TestService>(
        builder: (context, testService, child) {
          final instrumentTests = testService.instrumentTests;
          return Stack(
            children: [
              if (instrumentTests.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "You haven't tested any instruments yet.\nTap the '+ New Instrument' button to add a new instrument to be tested.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppTheme.textSizeMedium,
                      ),
                    ),
                  ),
                )
              else
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 80.0), // Add bottom padding to prevent overlap
                  child: Column(
                    children: instrumentTests.map((test) {
                      final uniqueChartButtonKey = GlobalKey(); // Create a unique GlobalKey for each button
                      return InstrumentTestButton(
                        test: test,
                        showcaseKey: uniqueChartButtonKey, // Pass the unique key
                      );
                    }).toList(),
                  ),
                ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Showcase(
                    key: _newInstrumentKey,
                    title: 'Add New Instrument',
                    description: 'Tap this button to add a new instrument to be tested.',
                    targetBorderRadius: BorderRadius.circular(20),
                    targetPadding: const EdgeInsets.all(8),
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        Provider.of<TestService>(context, listen: false).clearActiveTest();
                        Navigator.pushNamed(context, '/instrumentDetails');
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('New Instrument'),
                      tooltip: 'Create a test for a new instrument',
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}