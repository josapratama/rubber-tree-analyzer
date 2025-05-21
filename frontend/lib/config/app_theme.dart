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
      
      cardTheme: CardThemeData(
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
  
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: Colors.green.shade700,
      scaffoldBackgroundColor: Color(0xFF121212),
      
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.green.shade700,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: UIConfig.fontSizeXLarge,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade700,
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
      
      cardTheme: CardThemeData(
        elevation: 4,
        color: Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: UIConfig.paddingMedium,
          vertical: UIConfig.paddingSmall,
        ),
      ),
    );
  }
}