import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Cal_Keeper/core/utils/theme.dart';
import 'package:Cal_Keeper/services/test_service.dart';
import 'package:Cal_Keeper/pages/home/widgets/instrument_test_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey _newInstrumentKey = GlobalKey();
  final Map<int, GlobalKey> _chartButtonKeys = {}; // Map to hold keys for each button

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
        ShowCaseWidget.of(context).startShowCase([_newInstrumentKey]);
        prefs.setBool('hasShownNewInstrumentHint', true);
      });
    } else if (!hasShownChartHint) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Check if any keys have been created before starting the showcase
        if (_chartButtonKeys.isNotEmpty) {
          ShowCaseWidget.of(context).startShowCase(_chartButtonKeys.values.toList());
          prefs.setBool('hasShownChartHint', true);
        }
      });
    }
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
              onPressed: () { Navigator.pushNamed(context, '/settingsPage'); }
          ),
        ],
      ),
      body: Consumer<TestService>(
        builder: (context, testService, child) {
          final instrumentTests = testService.instrumentTests;

          // Generate unique keys for each button
          _chartButtonKeys.clear();
          for (var i = 0; i < instrumentTests.length; i++) {
            _chartButtonKeys[i] = GlobalKey();
          }

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
                  padding: const EdgeInsets.only(bottom: 80.0),
                  child: Column(
                    children: instrumentTests.asMap().entries.map((entry) {
                      int index = entry.key;
                      var test = entry.value;
                      return InstrumentTestButton(
                        test: test,
                        showcaseKey: _chartButtonKeys[index]!,
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
