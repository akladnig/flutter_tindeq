import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/constants/app_sizes.dart';

const dark = true;
const light = false;
//TODO make themestyle a provider based on a button or base theme of device
bool themeStyle = dark;
bool showDivider = false;

Color checkColor = Colors.white;
Color hoverColor = Colors.black26;

const Color primaryColour = Color(0xFF6243b3);
const Color primaryColourW300 = Color(0xFFf46c67);
const Color primaryColourW200 = Color(0xFFfb9792);
const Color primaryColourW100 = Color(0xFFffcbce);

/* primary */
const Color primary0 = Color(0xFF000000);
const Color primary10 = Color(0xFF21005d);
const Color primary20 = Color(0xFF390f89);
const Color primary25 = Color(0xFF442094);
const Color primary30 = Color(0xFF502fa0);
const Color primary35 = Color(0xFF5c3cac);
const Color primary40 = Color(0xFF6849b9);
const Color primary50 = Color(0xFF8163d4);
const Color primary60 = Color(0xFF9c7df1);
const Color primary70 = Color(0xFFb59cff);
const Color primary80 = Color(0xFFcfbdff);
const Color primary90 = Color(0xFFe8ddff);
const Color primary95 = Color(0xFFf5eeff);
const Color primary98 = Color(0xFFfdf7ff);
const Color primary99 = Color(0xFFfffbff);
const Color primary100 = Color(0xFFffffff);

const Color menuColour = Colors.blue;
const Color headerColour = Colors.blue;

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
  // Header Styles
  static TextStyle h1 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: Sizes.xLarge,
    color: foregroundColour,
  );
  static TextStyle h1Colour = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: Sizes.xLarge,
    color: headerColour,
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
  // Body Styles
  static TextStyle body = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: Sizes.medium,
    height: 1.4,
    color: foregroundColour,
  );
  // Height of 1 to allow precise positioning of text
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
  static const TextStyle grade = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: Sizes.small,
    height: 1.4,
    color: Colors.black45,
  );
  // Navigation Menu Styles
  static const TextStyle unselectedText = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: Sizes.small,
    height: 1.4,
    color: Colors.white60,
  );
  static const TextStyle selectedText = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: Sizes.small,
    height: 1.4,
    color: menuColour,
  );
  // Button Styles
  static TextStyle buttonTextBold = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: Sizes.medium,
  );
  static TextStyle buttonText = const TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: Sizes.medium,
  );
  static TextStyle body1 = raleway.copyWith(color: const Color(0xFF42A5F5));
  // etc
}

// Countdown Timer styling
class CountdownTimerStyle extends TextStyle {
  const CountdownTimerStyle(this.timerColour);
  final Color timerColour;

  TextStyle get count {
    return TextStyle(
      fontFamily: 'B612Mono',
      fontWeight: FontWeight.bold,
      fontSize: Sizes.small * 10,
      backgroundColor: timerColour,
      // height: 1.0,
      color: foregroundColour,
    );
  }
}

// Grade Gauge and Weight Gauge styling
class GaugeStyle {
  static const TextStyle number = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: Sizes.medium,
    height: 1.0,
    color: Colors.white,
  );

  static const TextStyle legend = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: Sizes.medium,
    height: 1.0,
    color: Colors.white54,
  );

  static Paint circlePaint = Paint()
    ..color = const Color.fromARGB(240, 30, 130, 240)
    ..style = PaintingStyle.fill
    ..strokeWidth = 2;

  static Paint weightBarpaint = Paint()
    ..color = Colors.white10
    ..style = PaintingStyle.fill
    ..strokeWidth = 2;

  static Paint rangeBarPaint = Paint()
    ..color = const Color.fromARGB(140, 30, 130, 240)
    ..style = PaintingStyle.fill
    ..strokeWidth = 2;

  static Paint tickPaint = Paint()
    ..color = Colors.white12
    ..style = PaintingStyle.fill
    ..strokeWidth = 2;
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
        borderRadius: BorderRadius.all(Radius.circular(Sizes.x2Large)),
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
