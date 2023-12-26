import 'package:flutter/material.dart';

import '../dimensions.dart';


const Color accentColor = Color(0xFF66BB0C);
const Color secondaryAccentColor = Color(0xFFBB840C);
const Color primaryColorSurfaceTint = Color(0xFFFFFCFC);
const Color primaryColorSurfaceTintDark = Color(0xFF604C06);

const Color successColorShade1 = Color(0xffcef6e2);
const Color successColor = Color(0xff5ede99);
const Color successColorAlt = Color(0xff45af76);

const Color dangerColorShade1 = Color(0xfffdd1d2);
const Color dangerColor = Color(0xFFF26666);
const Color dangerColorAlt = Color(0xFFAF4949);

const Color warningColor = Color(0xFFEFBE24);
const Color warningColorAlt = Color(0xFFAF8D1D);

const Color noticeColor = Color(0xFF33CBD5);
const Color noticeColorAlt = Color(0xFF207B81);

const Color lightColor = Color(0xFFF7F7F7);
const Color darkColor = Color(0xFF181818);

class Styles {
  static late Brightness brightness;
  static late Color primaryColor;
  static late ColorScheme colorScheme;
  static late Color textColor;
  static late Color primaryBackgroundColor;
  static late Color backgroundColor;
  static late Color surfaceTint;

  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    brightness = isDarkTheme ? Brightness.dark : Brightness.light;
    primaryColor = isDarkTheme ? secondaryAccentColor : accentColor;
    textColor = isDarkTheme ? lightColor : darkColor;
    backgroundColor = isDarkTheme ? darkColor : lightColor;
    primaryBackgroundColor = isDarkTheme ? Colors.black : Colors.white;
    surfaceTint =
        isDarkTheme ? primaryColorSurfaceTintDark : primaryColorSurfaceTint;

    colorScheme = ColorScheme(
      primary: primaryColor,
      onPrimary: Colors.white,
      onPrimaryContainer: Colors.white,
      secondary: primaryColor,
      onSecondary: backgroundColor,
      onSecondaryContainer: Colors.white,
      surface: primaryBackgroundColor,
      onSurface: textColor,
      background: backgroundColor,
      onBackground: textColor,
      onTertiaryContainer: textColor,
      error: dangerColor,
      onError: dangerColor,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      /// WIDGETS -----------------------------------------------------------

      // APP BAR THEME
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        shape: Border(
          bottom: BorderSide(color: textColor.withOpacity(0.3), width: 1),
        ),
      ),

      // TEXT FIELD THEME
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(8.0),
        filled: true,
        fillColor: isDarkTheme ? Colors.grey[900] : Colors.white,
        border: const OutlineInputBorder(
          borderRadius: Dimensions.roundedBorderMedium,
        ),
        hintStyle: TextStyle(color: Colors.grey.shade400),
      ),

      filledButtonTheme: const FilledButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: Dimensions.roundedBorderMedium,
            ),
          ),
        ),
      ),

      // CARD THEME
      cardTheme: const CardTheme(surfaceTintColor: Colors.transparent),

      // SCROLLBAR THEME
      scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: const MaterialStatePropertyAll(true),
          thumbColor: MaterialStatePropertyAll(primaryColor.withOpacity(0.8)),
          trackVisibility: const MaterialStatePropertyAll(true),
          thickness: const MaterialStatePropertyAll(5),
          mainAxisMargin: 5,
          crossAxisMargin: 5),
    );
  }
}
