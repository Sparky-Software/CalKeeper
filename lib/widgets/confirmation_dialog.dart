import 'package:Cal_Keeper/core/utils/theme.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  ConfirmationDialog({required this.title, required this.content, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppTheme.textSizeLarge,
          color: AppTheme.textColor1,
        ),
      ),
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppTheme.textSizeSmall,
          color: AppTheme.textColor2,
        ),
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
                child: Text('Cancel'),
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  fixedSize: const Size(120, 50),
                  backgroundColor: AppTheme.textColor2,
                  foregroundColor: AppTheme.buttonTextColor,
                ),
              ),
              const SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  onConfirm(); // Call the callback to handle the action
                },
                child: Text('Confirm'),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(120, 50),
                  textStyle: const TextStyle(fontSize: 20),
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
