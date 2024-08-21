import 'package:calcard_app/pages/home/home_page.dart';
import 'package:calcard_app/pages/test_creation/instrument_details_page.dart';
import 'package:calcard_app/pages/test_creation/select_tester_page.dart';
import 'package:calcard_app/pages/test_creation/tester_details_page.dart';
import 'package:calcard_app/pages/view_test/new_test_point_page.dart';
import 'package:calcard_app/pages/view_test/test_overview_page.dart';
import 'package:calcard_app/services/test_service.dart';
import 'package:calcard_app/services/tester_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import 'core/utils/theme.dart';
import 'models/instrument.dart';
import 'models/instrument_test.dart';
import 'models/instrument_test_point.dart';
import 'models/tester.dart'; // Required for Hive storage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);

  // Register Adapters
  Hive.registerAdapter(InstrumentAdapter());
  Hive.registerAdapter(InstrumentTestPointAdapter());
  Hive.registerAdapter(InstrumentTestAdapter());
  Hive.registerAdapter(TesterAdapter());

  // Open Boxes
  await Hive.openBox<InstrumentTest>('instrument_tests');
  await Hive.openBox<Tester>('testers');

  runApp(
    ShowCaseWidget(
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TesterService()),
          ChangeNotifierProvider(create: (context) => TestService()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themeData(),
          home: const HomePage(),
          routes: {
            '/instrumentDetails': (context) => const InstrumentDetailsPage(),
            '/testerDetailsPage': (context) => const TesterDetailsPage(),
            '/selectTesterPage': (context) => const SelectTesterPage(),
            '/home': (context) => const HomePage(),
            '/testOverview': (context) => const TestOverviewPage(),
            '/newTestPointPage': (context) => const NewTestPointPage(),
            // Add other routes here
          },
        ),
      ),
    ),
  );
}
