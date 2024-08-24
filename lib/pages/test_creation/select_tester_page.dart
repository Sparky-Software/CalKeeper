import 'package:Cal_Keeper/services/tester_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/tester_button.dart';

class SelectTesterPage extends StatefulWidget {
  const SelectTesterPage({super.key});

  @override
  State<SelectTesterPage> createState() => _SelectTesterPageState();
}

class _SelectTesterPageState extends State<SelectTesterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select person performing test'),
      ),
      body: Consumer<TesterService>(
        builder: (context, testerService, child) {
          final testers = testerService.testers;
          if (testers.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "You haven't entered the details of the person performing the tests yet. Tap the '+' button to enter details of a new tester",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: testers.length,
              itemBuilder: (context, index) {
                return TesterButton(tester: testers[index]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/testerDetailsPage');
          Provider.of<TesterService>(context, listen: false).clearActiveTester();
        },
        icon: const Icon(Icons.add),
        label: const Text('New Tester'),
        tooltip: 'Enter details for a new person doing the tests',
      ),
    );
  }
}
