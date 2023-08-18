import 'package:cartalogue/core/app_constants.dart';
import 'package:flutter/material.dart';

abstract class AppSpacing {
  // Empty Space
  static const emptySpace = SizedBox.shrink();

  // Horizontal Spacing
  static const horizontalSpacing2 = SizedBox(width: AppConstants.spacing2);
  static const horizontalSpacing4 = SizedBox(width: AppConstants.spacing4);
  static const horizontalSpacing8 = SizedBox(width: AppConstants.spacing8);
  static const horizontalSpacing12 = SizedBox(width: AppConstants.spacing12);
  static const horizontalSpacing16 = SizedBox(width: AppConstants.spacing16);
  static const horizontalSpacing24 = SizedBox(width: AppConstants.spacing24);

  // Vertical Spacing
  static const verticalSpacing2 = SizedBox(height: AppConstants.spacing2);
  static const verticalSpacing4 = SizedBox(height: AppConstants.spacing4);
  static const verticalSpacing8 = SizedBox(height: AppConstants.spacing8);
  static const verticalSpacing12 = SizedBox(height: AppConstants.spacing12);
  static const verticalSpacing16 = SizedBox(height: AppConstants.spacing16);
  static const verticalSpacing24 = SizedBox(height: AppConstants.spacing24);
}
