import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:calcard_app/services/test_service.dart';
import 'package:calcard_app/models/instrument.dart';
import 'package:calcard_app/widgets/custom_text_form_field.dart';
import '../../core/utils/theme.dart';
import '../../services/tester_service.dart';

class InstrumentDetailsPage extends StatefulWidget {
  const InstrumentDetailsPage({super.key});

  @override
  InstrumentDetailsPageState createState() => InstrumentDetailsPageState();
}

class InstrumentDetailsPageState extends State<InstrumentDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _makeController;
  late TextEditingController _modelController;
  late TextEditingController _serialNumController;
  late TextEditingController _acquisitionDateController;
  double _tolerance = 0.3;

  @override
  void initState() {
    super.initState();
    final testService = Provider.of<TestService>(context, listen: false);
    final activeTest = testService.getActiveTest();

    final instrument = activeTest?.instrument;
    _makeController = TextEditingController(text: instrument?.make ?? '');
    _modelController = TextEditingController(text: instrument?.model ?? '');
    _serialNumController =
        TextEditingController(text: instrument?.serialNum ?? '');
    _acquisitionDateController =
        TextEditingController(text: instrument?.acquisitionDate ?? '');
    _tolerance = instrument?.tolerance ?? 0.3;
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _serialNumController.dispose();
    _acquisitionDateController.dispose();
    super.dispose();
  }

  void _handleNavigation() {
    final testService = Provider.of<TestService>(context, listen: false);
    final testerService = Provider.of<TesterService>(context, listen: false);
    final activeTest = testService.getActiveTest();

    if (activeTest?.tester == null) {
      if (testerService.testers.isEmpty) {
        TesterService testerService = Provider.of<TesterService>(context, listen: false);
        testerService.inTestCreation = true;
        Navigator.pushNamed(context, '/testerDetailsPage');
      } else {
        Navigator.pushNamed(context, '/selectTesterPage');
      }
    } else {
      Navigator.pop(context);
    }
  }

  void _saveInstrument() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      final testService = Provider.of<TestService>(context, listen: false);
      final activeTest = testService.getActiveTest();

      final instrument = Instrument(
        make: _makeController.text,
        model: _modelController.text,
        serialNum: _serialNumController.text,
        acquisitionDate: _acquisitionDateController.text,
        tolerance: _tolerance,
      );

      try {
        testService.updateInstrument(activeTest, instrument);
        _handleNavigation();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<TestService>(context, listen: false).getActiveTest() == null ? 'Enter details of new instrument ' : 'Edit Instrument Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              CustomTextFormField(
                controller: _makeController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Make'),
              ),
              CustomTextFormField(
                controller: _modelController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Model'),
              ),
              CustomTextFormField(
                controller: _serialNumController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Serial Number'),
              ),
              CustomTextFormField(
                controller: _acquisitionDateController,
                decoration:
                const InputDecoration(labelText: 'Acquisition Date'),
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              const Text(
                "Tolerance level:",
                style: TextStyle(
                  fontSize: AppTheme.textSizeMedium,
                ),
              ),
              Padding(
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
              Slider(
                min: 0.0,
                max: 1.0,
                divisions: 100,
                value: _tolerance,
                onChanged: (value) {
                  setState(() {
                    _tolerance = value;
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveInstrument,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}