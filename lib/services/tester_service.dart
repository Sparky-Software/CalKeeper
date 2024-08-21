import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:calcard_app/models/tester.dart';

class TesterService with ChangeNotifier {
  final Box<Tester> _testersBox = Hive.box<Tester>('testers');
  Tester? _activeTester;
  bool inTestCreation = false;

  List<Tester> get testers => _testersBox.values.toList();
  Tester? getActiveTester() => _activeTester;

  void setActiveTester(Tester? tester) {
    _activeTester = tester;
    notifyListeners();
  }

  void clearActiveTester() {
    _activeTester = null;
    notifyListeners();
  }

  void addTester(Tester tester) {
    _testersBox.put(tester.id, tester);
    notifyListeners();
  }

  void deleteTester(String id) {
    _testersBox.delete(id);
    notifyListeners();
  }
}
