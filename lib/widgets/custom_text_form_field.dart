import 'package:Cal_Keeper/core/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final TextCapitalization textCapitalization;
  final InputDecoration decoration;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool multiLine;
  final TextInputAction textInputAction;
  final String unit;

  // Default label style
  final TextStyle defaultLabelStyle = const TextStyle(color: AppTheme.textColor2); // Default color

  const CustomTextFormField({
    super.key,
    this.controller,
    this.textCapitalization = TextCapitalization.none,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.multiLine = false,
    this.textInputAction = TextInputAction.next,
    this.unit = '',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        textCapitalization: textCapitalization,
        decoration: decoration.copyWith(
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(12.0),
          labelStyle: defaultLabelStyle,
          suffixText: unit,
        ),
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        maxLines: multiLine ? null : 1,
        textInputAction: textInputAction,
      ),
    );
  }
}
