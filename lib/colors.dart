import 'package:flutter/material.dart';

const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
  50: Color(0xFFE5E8EC),
  100: Color(0xFFBEC6CF),
  200: Color(0xFF93A0B0),
  300: Color(0xFF687990),
  400: Color(0xFF475D78),
  500: Color(_primaryPrimaryValue),
  600: Color(0xFF233A58),
  700: Color(0xFF1D324E),
  800: Color(0xFF172A44),
  900: Color(0xFF0E1C33),
});
const int _primaryPrimaryValue = 0xFF274060;

const MaterialColor primaryAccent = MaterialColor(_primaryAccentValue, <int, Color>{
  100: Color(0xFF6FA2FF),
  200: Color(_primaryAccentValue),
  400: Color(0xFF0961FF),
  700: Color(0xFF0055EF),
});
const int _primaryAccentValue = 0xFF3C81FF;

const MaterialColor secondary = MaterialColor(_secondaryPrimaryValue, <int, Color>{
  50: Color(0xFFF7FEFE),
  100: Color(0xFFECFCFE),
  200: Color(0xFFE0FAFD),
  300: Color(0xFFD3F8FC),
  400: Color(0xFFC9F7FB),
  500: Color(_secondaryPrimaryValue),
  600: Color(0xFFBAF4F9),
  700: Color(0xFFB2F2F9),
  800: Color(0xFFAAF0F8),
  900: Color(0xFF9CEEF6),
});
const int _secondaryPrimaryValue = 0xFFC0F5FA;

const MaterialColor secondaryAccent = MaterialColor(_secondaryAccentValue, <int, Color>{
  100: Color(0xFFFFFFFF),
  200: Color(_secondaryAccentValue),
  400: Color(0xFFFFFFFF),
  700: Color(0xFFFFFFFF),
});
const int _secondaryAccentValue = 0xFFFFFFFF;