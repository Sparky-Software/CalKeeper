import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calcard_app/core/utils/theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = false;
  double _tolerance = 0.15;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _tolerance = prefs.getDouble('tolerance') ?? 0.15;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notificationsEnabled', _notificationsEnabled);
    prefs.setDouble('tolerance', _tolerance);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Notify me monthly when instrument checks are due.'),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                  _saveSettings();
                });
              },
            ),
            const Divider(),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tolerance level:',
                  style: TextStyle(fontSize: AppTheme.textSizeMedium),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      '${(100*_tolerance).toStringAsFixed(0)}%',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: AppTheme.textSizeLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Slider(
                  min: 0.0,
                  max: 0.3,
                  divisions: 30,
                  value: _tolerance,
                  onChanged: (value) {
                    setState(() {
                      _tolerance = value;
                      _saveSettings();
                    });
                  },
                ),
                const Text(
                  "Highlights when instrument monthly checks fall outside this tolerance level from the baseline reference.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: AppTheme.textSizeSmall,
                      color: AppTheme.textColor2
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Go back to the previous screen
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(120, 50),
                  textStyle: const TextStyle(fontSize: 20),
                  foregroundColor: AppTheme.buttonTextColor,
                  backgroundColor: AppTheme.primaryColor,
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
