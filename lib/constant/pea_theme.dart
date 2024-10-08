import 'package:flutter/material.dart';

class PeaTheme {
  static const purpleColor = Color(0xFF65558F);
  static const greyColor = Color(0xFF79747E);
  static const pinkColor = Color(0xFFEEE8EF);
  static const _buttonRadius = 8.0;
  static const _textfieldRadius = 4.0;

  //* = = = = = = = = = = BUTTON = = = = = = = = = =
  static final _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: purpleColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_buttonRadius),
      ),
    ),
  );

  static final _outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: purpleColor,
      side: const BorderSide(color: Colors.grey), // Border color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_buttonRadius),
      ),
    ),
  );

  static final _textButtonTheme = TextButtonThemeData(
    style: ButtonStyle(
      overlayColor:
          MaterialStateColor.resolveWith((states) => Colors.transparent),
    ),
  );

  //* = = = = = = = = = = INPUT DECORATION = = = = = = = = = =
  static final _inputDecorationTheme = InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_textfieldRadius),
      borderSide: const BorderSide(color: greyColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_textfieldRadius),
      borderSide: const BorderSide(color: greyColor),
    ),
    labelStyle: const TextStyle(color: greyColor),
    hintStyle: const TextStyle(color: greyColor),
    suffixIconColor: greyColor,
  );

  //* = = = = = = = = = = THEME = = = = = = = = = =
  static final theme = ThemeData(
    elevatedButtonTheme: _elevatedButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    textButtonTheme: _textButtonTheme,
    inputDecorationTheme: _inputDecorationTheme,
    primaryColor: purpleColor,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: purpleColor,
      onPrimary: Colors.white,
      secondary: purpleColor,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      background: Colors.white,
      onBackground: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
  );
}
