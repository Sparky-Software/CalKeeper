import 'package:flutter/material.dart';
import 'package:Cal_Keeper/models/instrument.dart';
import '../../../core/utils/theme.dart';

class InstrumentInfo extends StatelessWidget {
  final Instrument instrument;
  const InstrumentInfo({super.key, required this.instrument});

  @override
  Widget build(BuildContext context) {
    final List<String> infoLines = [];

    if (instrument.make.isNotEmpty) infoLines.add('Make: ${instrument.make}');
    if (instrument.model.isNotEmpty) infoLines.add('Model: ${instrument.model}');
    if (instrument.serialNum.isNotEmpty) infoLines.add('Serial Number: ${instrument.serialNum}');
    if (instrument.acquisitionDate.isNotEmpty) infoLines.add('Acquisition Date: ${instrument.acquisitionDate}');

    return Card(
      color: AppTheme.textBoxColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        title: const Text(
          'Instrument Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppTheme.textSizeLarge, height: 1.2),
        ),
        subtitle: Text(
          infoLines.join('\n'),
          style: const TextStyle(fontSize: AppTheme.textSizeMedium),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: AppTheme.accentColor), // Set icon color and size
          onPressed: () {
            Navigator.pushNamed(context, '/instrumentDetails');
          },
        ),
      ),
    );
  }
}
