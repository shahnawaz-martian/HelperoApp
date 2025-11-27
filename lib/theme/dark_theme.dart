import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

final ThemeData darkTheme = ThemeData(
  fontFamily: 'Poppins',
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
  primaryColor: Colors.indigoAccent,
  highlightColor: const Color(0xFF252525),
  hintColor: const Color(0xFFc7c7c7),
  scaffoldBackgroundColor: Colors.black,
  // appBarTheme: const AppBarTheme(
  //   backgroundColor: Colors.indigoAccent,
  //   foregroundColor: Colors.white,
  // ),
  colorScheme: ColorScheme.dark(
    primary: Colors.indigoAccent,
    onPrimary: Colors.white,
    outline: Colors.white70,
    surface: Colors.black87,
    // onSurface: Colors.white,
    background: Colors.black,
    onBackground: Colors.white70,
    error: Colors.redAccent,
    onError: Colors.white,
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFF1A1A1A),
    modalBackgroundColor: Color(0xFF1A1A1A),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(fontSize: 22.sp),
    headlineMedium: TextStyle(fontSize: 17.sp),
    bodyLarge: TextStyle(fontSize: 20.sp),
    bodyMedium: TextStyle(fontSize: 14.sp),
    bodySmall: TextStyle(fontSize: 13.5.sp),
    labelLarge: TextStyle(fontSize: 15.5.sp),
    labelMedium: TextStyle(fontSize: 15.sp),
    labelSmall: TextStyle(fontSize: 11.sp),
  ),
);
