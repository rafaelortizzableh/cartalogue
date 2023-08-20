import 'package:flutter/material.dart';

abstract class AppConstants {
  // Border Radius
  static const borderRadius4 = BorderRadius.all(circularRadius4);
  static const borderRadius8 = BorderRadius.all(circularRadius8);
  static const borderRadius12 = BorderRadius.all(circularRadius12);
  static const borderRadius16 = BorderRadius.all(circularRadius16);
  static const circularRadius4 = Radius.circular(4.0);
  static const circularRadius8 = Radius.circular(8.0);
  static const circularRadius12 = Radius.circular(12.0);
  static const circularRadius16 = Radius.circular(16.0);

  static const roundedRectangleBorder12 = RoundedRectangleBorder(
    borderRadius: borderRadius12,
  );

  static const roundedRectangleVerticalBorder16 = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(spacing16),
    ),
  );

  // Spacing
  static const double spacing2 = 2.0;
  static const double spacing4 = 4.0;
  static const double spacing6 = 6.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 58.0;

  // Padding
  static const horizontalPadding4 = EdgeInsets.symmetric(horizontal: 4.0);
  static const horizontalPadding8 = EdgeInsets.symmetric(horizontal: 8.0);
  static const horizontalPadding12 = EdgeInsets.symmetric(horizontal: 12.0);
  static const horizontalPadding16 = EdgeInsets.symmetric(horizontal: 16.0);
  static const horizontalPadding24 = EdgeInsets.symmetric(horizontal: 24.0);
  static const horizontalPadding32 = EdgeInsets.symmetric(horizontal: 32.0);

  static const verticalPadding4 = EdgeInsets.symmetric(vertical: 4.0);
  static const verticalPadding8 = EdgeInsets.symmetric(vertical: 8.0);
  static const verticalPadding12 = EdgeInsets.symmetric(vertical: 12.0);
  static const verticalPadding16 = EdgeInsets.symmetric(vertical: 16.0);
  static const verticalPadding24 = EdgeInsets.symmetric(vertical: 24.0);
  static const verticalPadding32 = EdgeInsets.symmetric(vertical: 32.0);

  static const padding4 = EdgeInsets.all(4.0);
  static const padding8 = EdgeInsets.all(8.0);
  static const padding12 = EdgeInsets.all(12.0);
  static const padding16 = EdgeInsets.all(16.0);
  static const padding24 = EdgeInsets.all(24.0);
  static const padding32 = EdgeInsets.all(32.0);
}
