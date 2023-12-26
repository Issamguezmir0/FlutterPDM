import 'package:flutter/material.dart';

class Dimensions {
  // MARGIN --------------------------------------------------------------------
  static const double tinyMarginValue = 5;
  static const double smallMarginValue = 10;
  static const double mediumMarginValue = 15;
  static const double bigMarginValue = 20;

  static const EdgeInsets tinyMargin = EdgeInsets.all(smallMarginValue);
  static const EdgeInsets smallMargin = EdgeInsets.all(smallMarginValue);
  static const EdgeInsets mediumMargin = EdgeInsets.all(mediumMarginValue);
  static const EdgeInsets bigMargin = EdgeInsets.all(bigMarginValue);

  // ---------------------------------------------------------------------------

  // PADDING -------------------------------------------------------------------
  static const double smallPaddingValue = 5;
  static const double mediumPaddingValue = 10;
  static const double bigPaddingValue = 20;

  static const EdgeInsets smallPadding = EdgeInsets.all(smallPaddingValue);
  static const EdgeInsets mediumPadding = EdgeInsets.all(mediumPaddingValue);
  static const EdgeInsets bigPadding = EdgeInsets.all(bigPaddingValue);

  // ---------------------------------------------------------------------------

  // ROUNDED RADIUS ------------------------------------------------------------
  static const double radiusMedium = 8;
  static const BorderRadius roundedBorderMedium = BorderRadius.all(
    Radius.circular(radiusMedium),
  );
  static const BorderRadius roundedBorderTopMedium = BorderRadius.only(
    topLeft: Radius.circular(radiusMedium),
    topRight: Radius.circular(radiusMedium),
  );
  static const BorderRadius roundedBorderBottomMedium = BorderRadius.only(
    bottomLeft: Radius.circular(radiusMedium),
    bottomRight: Radius.circular(radiusMedium),
  );

  static const double radiusBig = 15;
  static const BorderRadius roundedBorderBig = BorderRadius.all(
    Radius.circular(radiusBig),
  );
  static const BorderRadius roundedBorderTopBig = BorderRadius.only(
    topLeft: Radius.circular(radiusBig),
    topRight: Radius.circular(radiusBig),
  );

// ---------------------------------------------------------------------------
}
