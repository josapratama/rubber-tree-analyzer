import 'package:flutter/material.dart';

class UIConfig {
  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  
  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeRegular = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeXLarge = 20.0;
  static const double fontSizeXXLarge = 24.0;
  
  // Colors
  static const Color primaryColor = Colors.green;
  static const Color primaryColorLight = Color(0xFF81C784);
  static const Color primaryColorDark = Color(0xFF388E3C);
  static const Color accentColor = Colors.blue;
  static const Color textColorPrimary = Color(0xFF212121);
  static const Color textColorSecondary = Color(0xFF757575);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  
  // Card Styles
  static final cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(borderRadiusMedium),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  );
  
  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: fontSizeLarge,
    fontWeight: FontWeight.bold,
    color: textColorPrimary,
  );
  
  static const TextStyle subheadingStyle = TextStyle(
    fontSize: fontSizeMedium,
    fontWeight: FontWeight.w500,
    color: textColorPrimary,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: fontSizeRegular,
    color: textColorPrimary,
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: fontSizeSmall,
    color: textColorSecondary,
  );
}