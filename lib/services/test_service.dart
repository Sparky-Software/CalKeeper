import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:Cal_Keeper/models/instrument_test.dart';
import 'package:Cal_Keeper/models/instrument_test_point.dart';

import '../models/instrument.dart';
import '../models/tester.dart';

class TestService with ChangeNotifier {
  final Box<InstrumentTest> _instrumentTestsBox = Hive.box<InstrumentTest>('instrument_tests');
  InstrumentTest? _activeTest;

  List<InstrumentTest> get instrumentTests => _instrumentTestsBox.values.toList();
  InstrumentTest? getActiveTest() => _activeTest;

  void setActiveTest(InstrumentTest? test) {
    _activeTest = test;
    notifyListeners();
  }

  void clearActiveTest() {
    _activeTest = null;
    notifyListeners();
  }

  void newInstrumentTest(InstrumentTest test) {
    _instrumentTestsBox.put(test.id, test);
    _activeTest = test;
    notifyListeners();
  }

  void updateInstrument(InstrumentTest? test, Instrument newInstrument) {
    if (test == null) {
      final newTest = InstrumentTest(instrument: newInstrument);
      newInstrumentTest(newTest);
      notifyListeners();
      return;
    }

    test.instrument = newInstrument;
    _instrumentTestsBox.put(test.id, test);
    _activeTest = test;
    notifyListeners();
  }

  Instrument? getInstrument(InstrumentTest test) => test.instrument;

  void addTestPoint(InstrumentTest test, InstrumentTestPoint testPoint, {bool isBase = false}) {
    if (isBase) {
      test.baseValues = testPoint;
      test.baseValues?.isBaseline = true;
    } else {
      test.testPoints.add(testPoint);
    }
    _instrumentTestsBox.put(test.id, test);
    notifyListeners();
  }

  void updateTestPoint(InstrumentTest test, InstrumentTestPoint testPoint) {
    test.testPoints[test.testPoints.indexWhere((element) => element.id == testPoint.id)] = testPoint;
    _instrumentTestsBox.put(test.id, test);
    notifyListeners();
  }

  void updateBaseValues(InstrumentTest test, InstrumentTestPoint testPoint) {
    test.baseValues = testPoint;
    _instrumentTestsBox.put(test.id, test);
    notifyListeners();
  }

  void deleteActiveTestPoint(InstrumentTest test) {
    test.testPoints.remove(test.activeTestPoint);
    test.activeTestPoint = null;
    _instrumentTestsBox.put(test.id, test);
    notifyListeners();
  }

  void deleteBaseline(InstrumentTest test) {
    test.baseValues = null;
    test.activeTestPoint = null;
    _instrumentTestsBox.put(test.id, test);
    notifyListeners();
  }

  void updateTester(InstrumentTest test, Tester newTester) {
    test.tester = newTester;
    _instrumentTestsBox.put(test.id, test);
    _activeTest = test;
    notifyListeners();
  }

  void removeInstrumentTest(InstrumentTest test) {
    _instrumentTestsBox.delete(test.id);
    _activeTest = null;
    notifyListeners();
  }
}
