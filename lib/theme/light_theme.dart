import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

final ThemeData lightTheme = ThemeData(
  fontFamily: 'Poppins',
  brightness: Brightness.light,
  primaryColor: Color(0xFF0483D0),
  highlightColor: Color(0xFFF6F6F6),
  hintColor: Color(0xFFc7c7c7),
  scaffoldBackgroundColor: Colors.white,
  // appBarTheme: const AppBarTheme(
  //   backgroundColor: Colors.blue,
  //   foregroundColor: Colors.white,
  // ),
  colorScheme: ColorScheme.light(
    primary: Color(0xFF0483D0),
    onPrimary: Colors.white,
    outline: Colors.grey.shade400,
    surface: Colors.white,
    //onSurface: Colors.black,
    background: Colors.white,
    onBackground: Colors.black54,
    error: Colors.redAccent,
    onError: Colors.white,
  ),

  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFFF2F2F2),
    modalBackgroundColor: Color(0xFFF2F2F2),
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
