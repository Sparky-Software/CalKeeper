import 'package:calcard_app/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:calcard_app/services/test_service.dart';
import 'package:calcard_app/models/instrument_test_point.dart'; //
import 'package:calcard_app/widgets/custom_text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/instrument_test.dart';
import '../view_test/widgets/warning_dialog.dart';

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
  double _tolerance = 0.15;

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
      return shouldPop;
    }
    return true;
  }

  void _saveTestPoint({void Function()? onConfirm}) {
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
        final remedialAction = _remedialActionController.text;
        final isBaseline = activeTest?.activeTestPoint?.isBaseline ?? false;
        final id = activeTest?.activeTestPoint?.id ?? DateTime.now().toString();

        // Reference values for insulation and continuity
        final List<double> referenceInsulationValues = [0.5, 1, 2, 10, 20];
        final List<double> referenceContinuityValues = [0.25, 0.5, 1, 2, 5];

        bool exceedsThreshold = _checkThresholdExceeded(
          insulationValues,
          continuityValues,
          referenceInsulationValues,
          referenceContinuityValues,
        );

        if (isBaseline && exceedsThreshold) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ConfirmationDialog(
                onConfirm: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _continueSave(testService, activeTest, insulationValues, continuityValues, zsValue, rcdValue, remedialAction, isBaseline, id);
                },
                title: "Value warning",
                content: 'One or more of the fields entered are more than ${(_tolerance * 100).toInt()}% outside what is expected. Are you sure you have entered the correct values?',
              );
            },
          );
          return;
        } else {
          _continueSave(testService, activeTest, insulationValues, continuityValues, zsValue, rcdValue, remedialAction, isBaseline, id);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Invalid data entered.')),
        );
      }
    }
  }

  void _continueSave(
      TestService testService,
      InstrumentTest? activeTest,
      List<double> insulationValues,
      List<double> continuityValues,
      double zsValue,
      double rcdValue,
      String remedialAction,
      bool isBaseline,
      String id,
      ) {
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
  }

  Future<void> _loadTolerance() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tolerance = prefs.getDouble('tolerance') ?? 0.15;
    });
  }

  bool _checkThresholdExceeded(List<double> insulationValues, List<double> continuityValues, List<double> referenceInsulationValues, List<double> referenceContinuityValues) {

    _loadTolerance();
    for (int i = 0; i < insulationValues.length; i++) {
      if (insulationValues[i]!=-1.0 &&
          (insulationValues[i] - referenceInsulationValues[i]).abs() / referenceInsulationValues[i] > _tolerance)  {
        return true;
      }
    }

    for (int i = 0; i < continuityValues.length; i++) {
      if (continuityValues[i]!=-1.0 &&
          (continuityValues[i] - referenceContinuityValues[i]).abs() / referenceContinuityValues[i] > _tolerance) {
        return true;
      }
    }

    return false;
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
    final testService = Provider.of<TestService>(context, listen: false);
    final activeTest = testService.getActiveTest();
    final baseValues = activeTest?.baseValues;

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
          return shouldPop;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            (activeTest?.activeTestPoint != null
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
            if (activeTest?.activeTestPoint != null)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  if (testService.getActiveTest()?.activeTestPoint?.isBaseline == true) {
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
                      decoration: const InputDecoration(labelText: 'Date of Test'),
                      keyboardType: TextInputType.datetime,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                    const Divider(),
                    const Text('Insulation Values:'),
                    ...List.generate(5, (index) {
                      final value = _isBaseline ? null : baseValues?.insulation[index];
                      if (_isBaseline || (value != null && value != -1.0)) {
                        return CustomTextFormField(
                          controller: _insulationControllers[index],
                          decoration: InputDecoration(
                            labelText: _getInsulationLabel(index),
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          unit: 'MΩ',
                        );
                      }
                      return SizedBox.shrink(); // No widget if condition not met
                    }),
                    const Divider(),
                    const Text('Continuity Values:'),
                    ...List.generate(5, (index) {
                      final value = _isBaseline ? null : baseValues?.continuity[index];
                      if (_isBaseline || (value != null && value != -1.0)) {
                        return CustomTextFormField(
                          controller: _continuityControllers[index],
                          decoration: InputDecoration(
                            labelText: _getContinuityLabel(index),
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          unit: 'Ω',
                        );
                      }
                      return SizedBox.shrink(); // No widget if condition not met
                    }),
                    const Divider(),
                    if (_isBaseline || (baseValues?.zs != null && baseValues?.zs != -1.0)) ...[
                      CustomTextFormField(
                        controller: _zsController,
                        decoration: const InputDecoration(
                          labelText: 'Zs:',
                          border: OutlineInputBorder(),
                        ),
                        unit: 'Ω',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                    if (_isBaseline || (baseValues?.rcd != null && baseValues?.rcd != -1.0)) ...[
                      CustomTextFormField(
                        controller: _rcdController,
                        decoration: const InputDecoration(
                          labelText: 'Rcd:',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        unit: 'ms',
                      ),
                    ],
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
                    SizedBox(
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
      case 0: return '0.5M\u2126:';
      case 1: return '1M\u2126:';
      case 2: return '2M\u2126:';
      case 3: return '10M\u2126:';
      case 4: return '20M\u2126:';
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

