import 'package:flutter/material.dart';
import '../config/ui_config.dart';

class CommonWidgets {
  // Loading Indicator
  static Widget loadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(UIConfig.primaryColor),
      ),
    );
  }
  
  // Error Message
  static Widget errorMessage(String message, {VoidCallback? onRetry}) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(UIConfig.paddingMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            SizedBox(height: UIConfig.paddingMedium),
            Text(
              message,
              textAlign: TextAlign.center,
              style: UIConfig.subheadingStyle,
            ),
            if (onRetry != null) ...[
              SizedBox(height: UIConfig.paddingMedium),
              ElevatedButton(
                onPressed: onRetry,
                child: Text('Coba Lagi'),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  // Info Row (Label: Value)
  static Widget infoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.only(bottom: UIConfig.paddingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: UIConfig.fontSizeMedium,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: UIConfig.fontSizeMedium,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Standard Card
  static Widget standardCard({
    required Widget child,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
  }) {
    final content = Padding(
      padding: padding ?? EdgeInsets.all(UIConfig.paddingMedium),
      child: child,
    );
    
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: UIConfig.paddingMedium,
        vertical: UIConfig.paddingSmall,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConfig.borderRadiusMedium),
      ),
      elevation: 4,
      child: onTap != null ? InkWell(onTap: onTap, child: content) : content,
    );
  }
  
  // Section Header
  static Widget sectionHeader(String title, {Color? color}) {
    return Padding(
      padding: EdgeInsets.only(
        top: UIConfig.paddingMedium,
        bottom: UIConfig.paddingSmall,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: UIConfig.fontSizeLarge,
          fontWeight: FontWeight.bold,
          color: color ?? UIConfig.primaryColorDark,
        ),
      ),
    );
  }
}