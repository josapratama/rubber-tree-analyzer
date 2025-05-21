import 'package:flutter/material.dart';
import 'ui_config.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.green,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: UIConfig.backgroundColor,
      
      appBarTheme: AppBarTheme(
        backgroundColor: UIConfig.primaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: UIConfig.fontSizeXLarge,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: UIConfig.primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: UIConfig.paddingMedium,
            vertical: UIConfig.paddingSmall,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UIConfig.borderRadiusSmall),
          ),
        ),
      ),
      
      cardTheme: CardTheme(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: UIConfig.paddingMedium,
          vertical: UIConfig.paddingSmall,
        ),
      ),
      
      textTheme: TextTheme(
        headlineMedium: UIConfig.headingStyle,
        titleLarge: UIConfig.subheadingStyle,
        bodyLarge: UIConfig.bodyStyle,
        bodySmall: UIConfig.captionStyle,
      ),
    );
  }
}