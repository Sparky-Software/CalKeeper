import 'package:calcard_app/core/utils/theme.dart';
import 'package:flutter/material.dart';

class WarningDialog extends StatelessWidget {
  final VoidCallback onProceed;

  WarningDialog({required this.onProceed});

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
      content: const Text.rich(
        TextSpan(
          text: 'The address entered only spans 1 line, are you sure this is what you meant? We recommend entering an address of the form: \n',
          style: TextStyle(
            fontSize: AppTheme.textSizeSmall,
            color: AppTheme.textColor2,
          ),
          children: [
            TextSpan(
              text: '\nLine 1,\nLine 2,\n...\nPostcode\n',
              style: TextStyle(
                fontSize: AppTheme.textSizeSmall,
                color: AppTheme.textColor2,
                fontStyle: FontStyle.italic,
              ),
            ),
            TextSpan(
              text: '\nto ensure it is displayed correctly.',
              style: TextStyle(
                fontSize: AppTheme.textSizeSmall,
                color: AppTheme.textColor2,
              ),
            ),
          ],
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
                child: Text('Ok'),
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  fixedSize: const Size(130, 50),
                  backgroundColor: AppTheme.textColor2,
                  foregroundColor: AppTheme.buttonTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
