import 'package:Cal_Keeper/core/utils/theme.dart';
import 'package:flutter/material.dart';

class WarningDialog extends StatelessWidget {
  final VoidCallback onProceed;
  final double tolerance;

  const WarningDialog({super.key, required this.onProceed, required this.tolerance});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Warning",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppTheme.textSizeLarge,
          color: AppTheme.textColor1,
        ),
      ),
      content: Text(
        'One or more of the fields entered are more than ${(tolerance*100).toInt()}% outside what is expected. Are you sure you have entered the correct values?',
        style: const TextStyle(
          fontSize: AppTheme.textSizeSmall,
          color: AppTheme.textColor2,
        ),
        textAlign: TextAlign.center,
      ),
      actions: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  fixedSize: const Size(130, 50),
                  backgroundColor: AppTheme.textColor2,
                  foregroundColor: AppTheme.buttonTextColor,
                ),
                child: const Text('Ok'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
