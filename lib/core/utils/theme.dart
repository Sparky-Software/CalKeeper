import 'dart:ui';

import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFe84a45);
  static const Color backgroundColor = Color(0xF5F5F6F8);
  static const Color textColor1 = Color(0xFF333333);
  static const Color textColor2 = Color(0xFF666666);
  static const Color accentColor = Color(0xFF0057D7);
  static const Color buttonTextColor = backgroundColor;
  static const Color textBoxColor = Color(0xFFF6F6F6);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF49BD51);
  static const double textSizeSmall = 16.0;
  static const double textSizeMedium = 18.0;
  static const double textSizeLarge = 22.0;

  static ThemeData themeData() {
    return ThemeData(
      primaryColor: primaryColor,
      hintColor: accentColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        color: primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(primaryColor),
          foregroundColor: MaterialStateProperty.all(buttonTextColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: buttonTextColor,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: accentColor,
        selectionColor: Color(0x9A669CFF),
        selectionHandleColor: accentColor,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: textBoxColor,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accentColor, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        labelStyle: TextStyle(color: textColor1),
        hintStyle: TextStyle(color: textColor1),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
        colorScheme: ColorScheme.light().copyWith(
          primary: buttonTextColor,
        ),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        collapsedIconColor: accentColor,
        iconColor: accentColor,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textColor1,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return accentColor; // Color when switch is on
            }
            return textColor2; // Color when switch is off
          },
        ),
        trackColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return accentColor.withOpacity(0.6); // Track color when switch is on
            }
          return textColor2.withOpacity(0.5); // Track color when switch is off
        },
      ),
    ),
    );
  }
}
