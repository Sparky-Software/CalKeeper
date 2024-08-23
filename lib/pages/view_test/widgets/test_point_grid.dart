import 'package:flutter/material.dart';
import 'package:calcard_app/models/instrument_test_point.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/utils/theme.dart';
import '../../../services/test_service.dart';

class TestPointGrid extends StatefulWidget {
  final InstrumentTestPoint testPoint;

  const TestPointGrid({super.key, required this.testPoint});

  @override
  _TestPointGridState createState() => _TestPointGridState();
}

class _TestPointGridState extends State<TestPointGrid> {
  bool _isExpanded = false;
  double _tolerance = 0.15;

  Future<void> _loadTolerance() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tolerance = prefs.getDouble('tolerance') ?? 0.15;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadTolerance();
    final activeTest = Provider.of<TestService>(context).getActiveTest();
    final baseValues = activeTest?.baseValues;
    final tolerance = _tolerance;

    if (baseValues == null) {
      return const Center(child: Text('No base values available'));
    }

    final isOutOfRange = _isAnyValueOutOfRange(widget.testPoint, baseValues, tolerance);

    Color borderColor;
    if (widget.testPoint.isOverridePass) {
      borderColor = AppTheme.successColor;
    } else if(_emptyBaseValues(widget.testPoint, baseValues)){
      borderColor = Colors.red;
    }
    else if (widget.testPoint.remedialAction != null) {
      borderColor = Colors.yellow;
    } else if (isOutOfRange) {
      borderColor = Colors.orange;
    } else {
      borderColor = AppTheme.successColor;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: widget.testPoint.isBaseline
            ? null
            : Border(
          left: BorderSide(
            color: borderColor,
            width: 6.0,
          ),
        ),
      ),
      child: Card(
        margin: EdgeInsets.zero,
        color: AppTheme.textBoxColor,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            onExpansionChanged: (expanded) {
              setState(() {
                _isExpanded = expanded;
              });
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: ${widget.testPoint.date.isNotEmpty ? widget.testPoint.date : '-'}',
                  style: const TextStyle(
                    fontSize: AppTheme.textSizeMedium,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor1,
                  ),
                ),
                Row(
                  children: [
                    if (_isExpanded) ...[
                      IconButton(
                        icon: const Icon(Icons.edit, color: AppTheme.accentColor),
                        onPressed: () {
                          activeTest?.activeTestPoint = widget.testPoint;
                          Navigator.pushNamed(context, '/newTestPointPage');
                        },
                      ),
                    ],
                  ],
                ),
              ],
            ),
            children: <Widget>[
              if (_isExpanded && _emptyBaseValues(widget.testPoint, baseValues))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red[50], // Light red background
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red, width: 1),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          activeTest?.activeTestPoint = widget.testPoint;
                          Navigator.pushNamed(context, '/newTestPointPage');
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 8.0, top: 2.0),
                                padding: const EdgeInsets.all(0),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.info,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Warning: One or more values have been recorded in this check that don\'t have a corresponding base reference value, please update the base reference values.',
                                      style: TextStyle(
                                        fontSize: AppTheme.textSizeSmall,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                      overflow: TextOverflow.visible, // Allow multiline text
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (_isExpanded && isOutOfRange && !widget.testPoint.isOverridePass && widget.testPoint.remedialAction == null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange[50], // Background color
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange, width: 1),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          activeTest?.activeTestPoint = widget.testPoint;
                          Navigator.pushNamed(context, '/newTestPointPage');
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 8.0, top: 2.0),
                                padding: const EdgeInsets.all(0),
                                decoration: const BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.info,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Warning: One or more values are outside the tolerance range from the base values, tap for more details.',
                                      style: TextStyle(
                                        fontSize: AppTheme.textSizeSmall,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                      overflow: TextOverflow.visible, // Allow multiline text
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (_isExpanded && isOutOfRange && !widget.testPoint.isOverridePass && widget.testPoint.remedialAction != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow[50], // Background color
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.yellow, width: 1),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          activeTest?.activeTestPoint = widget.testPoint;
                          Navigator.pushNamed(context, '/newTestPointPage');
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 8.0, top: 2.0),
                                padding: const EdgeInsets.all(0),
                                decoration: const BoxDecoration(
                                  color: Colors.yellow,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.info,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Remedial action was required as 1 or more values were out of base values tolerance: ${widget.testPoint.remedialAction}',
                                      style: const TextStyle(
                                        fontSize: AppTheme.textSizeSmall,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFB0910D),
                                      ),
                                      overflow: TextOverflow.visible, // Allow multiline text
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (_isExpanded && isOutOfRange) const SizedBox(height: 4.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Insulation Text
                    const Text(
                      'Insulation:',
                      style: TextStyle(
                        fontSize: AppTheme.textSizeMedium,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor1,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Center(child: Text('0.5M', style: _labelTextStyle))),
                        Expanded(child: Center(child: Text('1M', style: _labelTextStyle))),
                        Expanded(child: Center(child: Text('2M', style: _labelTextStyle))),
                        Expanded(child: Center(child: Text('10M', style: _labelTextStyle))),
                        Expanded(child: Center(child: Text('20M', style: _labelTextStyle))),
                      ],
                    ),
                    const Divider(thickness: 1.0, color: AppTheme.textColor2),
                    const SizedBox(height: 4.0),

                    // Insulation Values
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (index) {
                        final value = widget.testPoint.insulation[index];
                        final baseValue = baseValues.insulation[index];
                        final min = baseValue - (baseValue * tolerance);
                        final max = baseValue + (baseValue * tolerance);
                        final isOutOfRange = value != -1.0 && (value < min || value > max);

                        return Expanded(
                          child: Center(
                            child: Text(
                              value == -1.0 ? '-' : '$value Ω',
                              style: TextStyle(
                                fontSize: AppTheme.textSizeSmall,
                                color: isOutOfRange ? baseValue==-1 ? Colors.red : Colors.orange : AppTheme.textColor2,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8.0),

                    // Continuity Text
                    const Text(
                      'Continuity:',
                      style: TextStyle(
                        fontSize: AppTheme.textSizeMedium,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor1,
                      ),
                    ),
                    const SizedBox(height: 4.0),

                    // Continuity Column Labels
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Center(child: Text('0.25Ω', style: _labelTextStyle))),
                        Expanded(child: Center(child: Text('0.5Ω', style: _labelTextStyle))),
                        Expanded(child: Center(child: Text('1Ω', style: _labelTextStyle))),
                        Expanded(child: Center(child: Text('2Ω', style: _labelTextStyle))),
                        Expanded(child: Center(child: Text('5Ω', style: _labelTextStyle))),
                      ],
                    ),
                    const Divider(thickness: 1.0, color: AppTheme.textColor2),
                    const SizedBox(height: 4.0),

                    // Continuity Values
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (index) {
                        final value = widget.testPoint.continuity[index];
                        final baseValue = baseValues.continuity[index];
                        final min = baseValue - (baseValue * tolerance);
                        final max = baseValue + (baseValue * tolerance);
                        final isOutOfRange = value != -1.0 && (value < min || value > max);

                        return Expanded(
                          child: Center(
                            child: Text(
                              value == -1.0 ? '-' : '$value Ω',
                              style: TextStyle(
                                fontSize: AppTheme.textSizeSmall,
                                color: isOutOfRange ? baseValue==-1 ? Colors.red : Colors.orange : AppTheme.textColor2,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ensures proper spacing between the texts
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: widget.testPoint.zs == -1.0 ? '' : 'Zs: ',
                                style: const TextStyle(
                                  fontSize: AppTheme.textSizeMedium,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textColor1,
                                ),
                              ),
                              TextSpan(
                                text: widget.testPoint.zs == -1.0 ? '' : '${widget.testPoint.zs} Ω',
                                style: TextStyle(
                                  fontSize: AppTheme.textSizeMedium,
                                  fontWeight: FontWeight.normal,
                                  color: _getValueColor(widget.testPoint.zs, baseValues.zs, tolerance),
                                ),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: widget.testPoint.rcd == -1.0 ? '' : 'Rcd: ',
                                style: const TextStyle(
                                  fontSize: AppTheme.textSizeMedium,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textColor1,
                                ),
                              ),
                              TextSpan(
                                text: widget.testPoint.rcd == -1.0 ? '' : '${widget.testPoint.rcd} ms',
                                style: TextStyle(
                                  fontSize: AppTheme.textSizeMedium,
                                  fontWeight: FontWeight.normal,
                                  color: _getValueColor(widget.testPoint.rcd, baseValues.rcd, tolerance),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle get _labelTextStyle => const TextStyle(
    fontSize: AppTheme.textSizeSmall,
    fontWeight: FontWeight.bold,
    color: AppTheme.textColor2,
  );

  bool _emptyBaseValues(InstrumentTestPoint testPoint, InstrumentTestPoint baseValues) {
    final insulationEmpty = testPoint.insulation.asMap().entries.any((entry) {
      final index = entry.key;
      final value = entry.value;
      final baseValue = baseValues.insulation[index];
      return value != -1.0 && baseValue == -1.0;
    });

    final continuityEmpty = testPoint.continuity.asMap().entries.any((entry) {
      final index = entry.key;
      final value = entry.value;
      final baseValue = baseValues.continuity[index];
      return value != -1.0 && baseValue == -1.0;
    });

    final zsEmpty = testPoint.zs != -1.0 && baseValues.zs == -1.0;
    final rcdEmpty = testPoint.rcd != -1.0 && baseValues.rcd == -1.0;

    return insulationEmpty || continuityEmpty || zsEmpty || rcdEmpty;
  }

  Color _getValueColor(double value, double? baseValue, double tolerance) {
    if (baseValue == null) return AppTheme.textColor1;
    if(baseValue == -1.0) return Colors.red;
   final min = baseValue - (baseValue * tolerance);
    final max = baseValue + (baseValue * tolerance);
    return (value < min || value > max) ? Colors.orange : AppTheme.textColor1;
  }

  bool _isAnyValueOutOfRange(
      InstrumentTestPoint testPoint,
      InstrumentTestPoint baseValues,
      double tolerance,
      ) {
    final insulationOutOfRange = testPoint.insulation.asMap().entries.any((entry) {
      final index = entry.key;
      final value = entry.value;
      final baseValue = baseValues.insulation[index];
      final min = baseValue - (baseValue * tolerance);
      final max = baseValue + (baseValue * tolerance);
      return value != -1.0 && (value < min || value > max && baseValue != -1.0);
    });

    final continuityOutOfRange = testPoint.continuity.asMap().entries.any((entry) {
      final index = entry.key;
      final value = entry.value;
      final baseValue = baseValues.continuity[index];
      final min = baseValue - (baseValue * tolerance);
      final max = baseValue + (baseValue * tolerance);
      return value != -1.0 && (value < min || value > max) && baseValue != -1.0;
    });

    final zsOutOfRange = baseValues.zs!=-1 && testPoint.zs != -1.0 &&
        (testPoint.zs < baseValues.zs - (baseValues.zs * tolerance) ||
            testPoint.zs > baseValues.zs + (baseValues.zs * tolerance));
    final rcdOutOfRange = baseValues.rcd!=-1 && testPoint.rcd != -1.0 &&
        (testPoint.rcd < baseValues.rcd - (baseValues.rcd * tolerance) ||
            testPoint.rcd > baseValues.rcd + (baseValues.rcd * tolerance));

    if (insulationOutOfRange ||
        continuityOutOfRange ||
        zsOutOfRange ||
        rcdOutOfRange) {
      if (testPoint.state != "fail") {
        setState(() {
          testPoint.state = "fail";
        });
      }
      return true;
    } else {
      if (testPoint.state != "pass") {
        setState(() {
          testPoint.state = "pass";
        });
      }
      return false;
    }
  }
}

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final Widget child;

  const CustomExpansionTile({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  CustomExpansionTileState createState() => CustomExpansionTileState();
}

class CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            color: AppTheme.textBoxColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: AppTheme.textSizeMedium,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor1,
                  ),
                ),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: AppTheme.textColor1,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: widget.child,
          ),
      ],
    );
  }
}
