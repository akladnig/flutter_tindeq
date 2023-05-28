import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/constants/app_sizes.dart';

const dark = true;
const light = false;
//TODO make themestyle a provider based on a button or base theme of device
bool themeStyle = dark;
bool showDivider = false;

Color checkColor = Colors.white;
Color hoverColor = Colors.black26;

const Color primaryColour = Color(0xFFE31317);
const Color primaryColourW300 = Color(0xFFf46c67);
const Color primaryColourW200 = Color(0xFFfb9792);
const Color primaryColourW100 = Color(0xFFffcbce);

class ChartColours {
  static const Color primary = ChartColours.contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color chartBorderColor = Colors.white10;
  static const Color gridLinesColor = Color(0x11FFFFFF);
  static const Color lineLegendBorderColor = Colors.white70;

  static const Color lineColorL = ChartColours.contentColorBlue;
  static const Color lineColorR = ChartColours.contentColorPurple;
  static const Color lineColor = ChartColours.contentColorRed;
  static const Color dotColor = ChartColours.contentColorRed;

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);

  static const List<Color> gradientColorsL = [
    ChartColours.contentColorCyan,
    ChartColours.lineColorL,
  ];

  static const List<Color> gradientColorsR = [
    ChartColours.contentColorPink,
    ChartColours.contentColorPurple,
  ];
}

bool isDarkTheme = true;
Color foregroundColour = isDarkTheme ? Colors.white : Colors.black;

class Fonts {
  static const String raleway = 'Raleway';
  // etc
}

//TODO allow colour to be set?
class TextStyles {
  static const TextStyle raleway = TextStyle(
    fontFamily: Fonts.raleway,
  );
  static TextStyle buttonText1 = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: Sizes.medium,
  );
  static TextStyle buttonText2 = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: Sizes.medium,
  );
  static TextStyle h1 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: Sizes.extraLarge,
    color: foregroundColour,
  );
  static const TextStyle h1Colour = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: Sizes.extraLarge,
    color: Colors.blue,
  );
  static TextStyle h2 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: Sizes.large,
    color: foregroundColour,
  );
  static TextStyle h3 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: Sizes.medium,
    color: foregroundColour,
  );
  static TextStyle body = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: Sizes.medium,
    height: 1.4,
    color: foregroundColour,
  );
  static TextStyle bodyHeightSmall = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: Sizes.medium,
    height: 1.0,
    color: foregroundColour,
  );
  static TextStyle bodySmallPrimary = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: Sizes.small,
    height: 1.4,
    color: primaryColourW300,
  );
  static TextStyle bodySmall = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: Sizes.small,
    height: 1.4,
    color: foregroundColour,
  );
  static TextStyle bodyBold = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: Sizes.medium,
    height: 1.4,
    color: foregroundColour,
  );
  static const TextStyle error = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: Sizes.medium,
    height: 1.4,
    color: Colors.red,
  );
  static TextStyle trExample = TextStyle(
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.italic,
    fontSize: Sizes.medium,
    height: 1.4,
    color: foregroundColour,
  );
  static TextStyle trExampleHighlight = const TextStyle(
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.italic,
    fontSize: Sizes.medium,
    height: 1.4,
    backgroundColor: primaryColourW200,
  );
  static TextStyle body1 = raleway.copyWith(color: const Color(0xFF42A5F5));
  // etc
}

//
// Theme for the App
//

ThemeData theme(bool isDarkTheme) {
  Color foregroundColour = isDarkTheme ? Colors.white : Colors.black;
  const Color primaryColour = Color(0xFFE31317);
  const Color secondaryColour = Color(0xFFE3E013);

  return ThemeData(
    //canvasColor: Colors.transparent,
    colorScheme: ColorScheme.fromSeed(
      // default brightness and colours
      seedColor: primaryColour,
      primary: primaryColour,
      secondary: secondaryColour,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
    ),

    // font Family
    fontFamily: 'Arial',
    appBarTheme: AppBarTheme(
        backgroundColor: primaryColour, titleTextStyle: TextStyles.h1),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDarkTheme ? const Color(0xFF303030) : Colors.white,
      hintStyle: TextStyles.body,
      prefixIconColor: foregroundColour,
      suffixIconColor: foregroundColour,
      border: const OutlineInputBorder(
        // Border radius set to height x0.8
        borderRadius: BorderRadius.all(Radius.circular(Sizes.xxLarge)),
        borderSide: BorderSide(width: 0, style: BorderStyle.none),
      ),
    ),
    dividerTheme: DividerThemeData(color: foregroundColour, thickness: 0.0),
    iconTheme: const IconThemeData(color: primaryColour),
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.resolveWith<Color>(
          (states) => Colors.transparent),
      fillColor:
          MaterialStateProperty.resolveWith<Color>((states) => Colors.white),
    ),
  );
}
