import 'package:calcard_app/pages/view_test/widgets/deletion_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:calcard_app/services/test_service.dart';
import 'package:calcard_app/models/instrument_test_point.dart'; // Import your data model
import 'package:calcard_app/widgets/custom_text_form_field.dart';

class NewTestPointPage extends StatefulWidget {
  const NewTestPointPage({super.key});

  @override
  NewTestPointPageState createState() => NewTestPointPageState();
}
class NewTestPointPageState extends State<NewTestPointPage> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  late TextEditingController _dateController;
  final List<TextEditingController> _insulationControllers = List.generate(5, (_) => TextEditingController());
  final List<TextEditingController> _continuityControllers = List.generate(5, (_) => TextEditingController());
  late TextEditingController _zsController;
  late TextEditingController _rcdController;
  late TextEditingController _remedialActionController;
  bool _isBaseline = false;
  bool _isFailed = false;
  late List<String> _initialInsulationValues;
  late List<String> _initialContinuityValues;
  late String _initialZsValue;
  late String _initialRcdValue;
  late String _initialRemedialActionValue;

  bool _isOverridePass = false;

  @override
  void initState() {
    super.initState();
    final testService = Provider.of<TestService>(context, listen: false);
    final activeTest = testService.getActiveTest();
    InstrumentTestPoint? testPoint;

    if (activeTest?.baseValues == null || activeTest?.activeTestPoint?.isBaseline == true) {
      _isBaseline = true;
    }

    if (activeTest?.activeTestPoint != null) {
      testPoint = activeTest?.activeTestPoint;
      _isFailed = testPoint?.state == 'fail';
      _isOverridePass = testPoint?.isOverridePass ?? false; // Initialize the override flag
    }

    DateTime date = DateTime.now();
    _dateController = TextEditingController(text: testPoint?.date ?? '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}');

    for (int i = 0; i < 5; i++) {
      _insulationControllers[i] = TextEditingController(
        text: (testPoint?.insulation[i] == null || testPoint?.insulation[i] == -1)
            ? ''
            : testPoint?.insulation[i].toString(),
      );

      _continuityControllers[i] = TextEditingController(
        text: (testPoint?.continuity[i] == null || testPoint?.continuity[i] == -1)
            ? ''
            : testPoint?.continuity[i].toString(),
      );
    }
    _zsController = TextEditingController(
      text: (testPoint?.zs == null || testPoint?.zs == -1)
          ? ''
          : testPoint?.zs.toString(),
    );

    _rcdController = TextEditingController(
      text: (testPoint?.rcd == null || testPoint?.rcd == -1)
          ? ''
          : testPoint?.rcd.toString(),
    );

    _remedialActionController = TextEditingController(
      text: testPoint?.remedialAction ?? '',
    );


    _initialInsulationValues = _insulationControllers.map((controller) => controller.text).toList();
    _initialContinuityValues = _continuityControllers.map((controller) => controller.text).toList();
    _initialZsValue = _zsController.text;
    _initialRcdValue = _rcdController.text;
    _initialRemedialActionValue = _remedialActionController.text;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    for (TextEditingController controller in _insulationControllers) {
      controller.dispose();
    }
    for (TextEditingController controller in _continuityControllers) {
      controller.dispose();
    }
    _zsController.dispose();
    _rcdController.dispose();
    _remedialActionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<bool> didPopRoute() async {
    if (_hasUnsavedChanges()) {
      bool shouldPop = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConfirmationDialog(
            title: 'Unsaved Changes',
            content: 'You have unsaved changes. Are you sure you want to go back?',
            onConfirm: () {
              Navigator.of(context).pop(true);
            },
          );
        },
      );
      return shouldPop ?? false;
    }
    return true;
  }

  void _saveTestPoint() {
    if (_formKey.currentState?.validate() ?? false) {
      final testService = Provider.of<TestService>(context, listen: false);
      final activeTest = testService.getActiveTest();

      try {
        final insulationValues = _insulationControllers
            .map((controller) => _parseDouble(controller.text))
            .toList();
        final continuityValues = _continuityControllers
            .map((controller) => _parseDouble(controller.text))
            .toList();
        final zsValue = _parseDouble(_zsController.text);
        final rcdValue = _parseDouble(_rcdController.text);
        final remedialAction = _remedialActionController.text; // Capture the remedial action
        final isBaseline = activeTest?.activeTestPoint?.isBaseline ?? false;
        final id = activeTest?.activeTestPoint?.id ?? DateTime.now().toString();


        final testPoint = InstrumentTestPoint(
          date: _dateController.text,
          insulation: insulationValues,
          continuity: continuityValues,
          zs: zsValue,
          rcd: rcdValue,
          state: _isFailed ? 'fail' : 'pass',
          isOverridePass: _isOverridePass,
          id: id,
          remedialAction: remedialAction.isNotEmpty ? remedialAction : null,
          isBaseline: isBaseline,
        );

        if (activeTest?.activeTestPoint != null) {
          if (activeTest?.activeTestPoint?.isBaseline == true) {
            testService.updateBaseValues(activeTest!, testPoint);
          } else {
            testService.updateTestPoint(activeTest!, testPoint);
            activeTest.activeTestPoint = null;
          }
        } else if (activeTest?.baseValues == null) {
          testService.addTestPoint(activeTest!, testPoint, isBase: true);
        } else {
          testService.addTestPoint(activeTest!, testPoint);
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Invalid data entered.')),
        );
      }
    }
  }

  double _parseDouble(String value) {
    if (value.isEmpty) {
      return -1;
    }
    try {
      return double.parse(value);
    } catch (e) {
      return 0.0;
    }
  }

  bool _hasUnsavedChanges() {
    bool insulationChanged = !_initialInsulationValues.asMap().entries.every(
          (entry) => entry.value == _insulationControllers[entry.key].text,
    );
    bool continuityChanged = !_initialContinuityValues.asMap().entries.every(
          (entry) => entry.value == _continuityControllers[entry.key].text,
    );
    bool zsChanged = _initialZsValue != _zsController.text;
    bool rcdChanged = _initialRcdValue != _rcdController.text;
    bool remedialActionChanged = _initialRemedialActionValue != _remedialActionController.text;

    return insulationChanged || continuityChanged || zsChanged || rcdChanged || remedialActionChanged;
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients&&_isFailed) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_hasUnsavedChanges()) {
          bool shouldPop = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return ConfirmationDialog(
                title: 'Unsaved Changes',
                content: 'You have unsaved changes. Are you sure you want to go back?',
                onConfirm: () {
                  Navigator.of(context).pop(true);
                },
              );
            },
          );
          return shouldPop ?? false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            (Provider.of<TestService>(context, listen: false).getActiveTest()?.activeTestPoint != null
                ? (_isBaseline
                ? 'Edit Baseline Reference'
                : 'Edit Instrument Test Data'
            )
                : (_isBaseline
                ? 'Enter Baseline Reference'
                : 'Enter Instrument Test Data'
            )
            ),
          ),
          actions: [
            if (Provider.of<TestService>(context, listen: false).getActiveTest()?.activeTestPoint != null)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  final testService = Provider.of<TestService>(context, listen: false);
                  if(testService.getActiveTest()?.activeTestPoint?.isBaseline == true) {
                    testService.deleteBaseline(testService.getActiveTest()!);
                  } else {
                    testService.deleteActiveTestPoint(testService.getActiveTest()!);
                  }
                  Navigator.pop(context);
                },
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            controller: _scrollController,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      controller: _dateController,
                      decoration:
                      const InputDecoration(labelText: 'Date of Test'),
                      keyboardType: TextInputType.datetime,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                    const Divider(),
                    Text('Insulation Values:'),
                    ...List.generate(5, (index) => CustomTextFormField(
                      controller: _insulationControllers[index],
                      decoration: InputDecoration(
                        labelText: _getInsulationLabel(index),
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      unit: 'MΩ',
                    )),
                    const Divider(),
                    Text('Continuity Values:'),
                    ...List.generate(5, (index) => CustomTextFormField(
                      controller: _continuityControllers[index],
                      decoration: InputDecoration(
                        labelText: _getContinuityLabel(index),
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      unit: 'Ω',
                    )),
                    const Divider(),
                    CustomTextFormField(
                      controller: _zsController,
                      decoration: const InputDecoration(
                        labelText: 'Zs:',
                        border: OutlineInputBorder(),
                      ),
                      unit: 'Ω',
                      keyboardType: TextInputType.number,
                    ),
                    CustomTextFormField(
                      controller: _rcdController,
                      decoration: const InputDecoration(
                        labelText: 'Rcd:',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      unit: 'ms',
                    ),

                    if (_isFailed) ...[
                      const Divider(),
                      const Text('One or more values in this check fall outside the allowed threshold of the baseline reference. Please describe the remedial action that was taken to repair the instrument, then perform a new check. If this is wrong, you can override the check as a pass.'),
                      const SizedBox(height: 4.0),
                      CustomTextFormField(
                        controller: _remedialActionController,
                        decoration: const InputDecoration(
                          labelText: 'Describe remedial action taken',
                          border: OutlineInputBorder(),
                        ),
                        multiLine: true,
                        textInputAction: TextInputAction.newline,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text('Override fail as pass'),
                          ),
                          Switch(
                            value: _isOverridePass,
                            onChanged: (bool newValue) {
                              setState(() {
                                _isOverridePass = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveTestPoint,
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInsulationLabel(int index) {
    switch (index) {
      case 0: return '0.5M:';
      case 1: return '1M:';
      case 2: return '2M:';
      case 3: return '10M:';
      case 4: return '20M:';
      default: return '';
    }
  }

  String _getContinuityLabel(int index) {
    switch (index) {
      case 0: return '0.25\u2126:';
      case 1: return '0.5\u2126:';
      case 2: return '1\u2126:';
      case 3: return '2\u2126:';
      case 4: return '5\u2126:';
      default: return '';
    }
  }
}

