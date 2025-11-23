import 'package:flutter/material.dart';
import 'app_colors.dart';

class TextStyles {
  static const TextStyle sansBody = TextStyle(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: 'sans-serif',
    fontFamilyFallback: ['Helvetica Neue', 'Arial', 'Roboto'],
    height: 1.3,
  );

  static const TextStyle sansTitle = TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    fontFamily: 'sans-serif',
    fontFamilyFallback: ['Helvetica Neue', 'Arial', 'Roboto'],
  );

  static const TextStyle serifBody = TextStyle(
    color: Colors.white,
    fontFamily: 'serif',
    fontSize: 18,
    height: 1.4,
  );

  static const TextStyle serifTitle = TextStyle(
    color: Colors.white,
    fontFamily: 'serif',
    fontSize: 28,
    fontWeight: FontWeight.w600,
  );
}
