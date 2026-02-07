/// core/constants/theme_constants.dart
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_component/core/constants/theme_constants.dart';

class AppTheme {
  // ---------------- LIGHT THEME ----------------
  static ThemeData lightTheme = FlexThemeData.light(
    scheme: FlexScheme.blumineBlue,
    appBarStyle: FlexAppBarStyle.primary,
    primary: AppColors.primary,
    scaffoldBackground: Color(0xFFF4F4F4),
    useMaterial3: true,
  );

  // ---------------- DARK THEME ----------------
  static ThemeData darkTheme = FlexThemeData.dark(
    scheme: FlexScheme.blackWhite,
    primary: AppColors.primary,
    appBarStyle: FlexAppBarStyle.primary,
    useMaterial3: true,
  );
}

class AppScreen {
  // MediaQuery shortcuts
  static Size get gets => MediaQuery.of(Get.context!).size;
  static double get screenheight => gets.height;
  static double get screenwidth => gets.width;
}

/// ---------------- COLORS ----------------
///
class AppColors {
  static BuildContext get ctx => Get.context!;
  static ColorScheme get scheme => Theme.of(ctx).colorScheme;
  static TextTheme get text => Theme.of(ctx).textTheme;

  // =============== PRIMARY COLORS ===============
  static Color get primary => Color(0xFF9FC5F8);
  static Color get secondary => Color(0xFF89BCFF);
  static Color get accent => scheme.tertiary;

  static Color get surface => Theme.of(ctx).brightness == Brightness.dark
      ? scheme.surface
      : Color(0xFFF6F6F6); //cards,buttons ...
  static Color get onSurface => scheme.onSurface;
  static Color get brand => Colors.blue;

  // =============== OTHER ===============

  static Color get onBackground => scheme.onSurface;

  static Color get tertiary => scheme.tertiary;
  static Color get onPrimary => scheme.onPrimary;
  static Color get onSecondary => scheme.onSecondary;
  static Color get onTertiary => scheme.onTertiary;
  //===============ICON========================
  static Color get iconPrimary => scheme.onBackground;
  static Color get iconSecondary => scheme.onSurfaceVariant;

  static Color get surfaceVariant => scheme.surfaceVariant;
  static Color get onSurfaceVariant => scheme.onSurfaceVariant;

  // =============== ERROR ===============
  static Color get error => scheme.error;
  static Color get onError => scheme.onError;

  // =============== OUTLINE ===============
  static Color get outline => scheme.outline;
  static Color get outlineVariant => scheme.outlineVariant;

  // =============== INVERSE ===============
  static Color get inversePrimary => scheme.inversePrimary;
  static Color get inverseSurface => scheme.inverseSurface;
  static Color get onInverseSurface => scheme.onInverseSurface;

  // Dynamic brightness helpers
  static bool get isDark => scheme.brightness == Brightness.dark;
  static bool get isLight => scheme.brightness == Brightness.light;

  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  // -------------------------------------------------
  // DEFAULT COLORS
  // -------------------------------------------------
  static const blue = Color(0xFF0B84FE);
  static const red = Color(0xFFFF3B30);
  static const orange = Color(0xFFFF9500);
  static const yellow = Color(0xFFFFCC00);
  static const green = Color(0xFF34C759);
  static const indigo = Color(0xFF5856D6);
  static const purple = Color(0xFFAF52DE);
  static const teal = Color(0xFF30B0C7);
  // -------------------------------------------------
  // GRAYSCALE
  // -------------------------------------------------
  static const gray50 = Color(0xFFFAFAFA); // Light gray
  static const gray100 = Color(0xFFF5F5F5);
  static const gray200 = Color(0xFFE5E5E5);
  static const gray300 = Color(0xFFD4D4D4);
  static const gray400 = Color(0xFFA3A3A3);
  static const gray500 = Color(0xFF737373);
  static const gray600 = Color(0xFF525252);
  static const gray700 = Color(0xFF404040);
  static const gray800 = Color(0xFF262626);
  static const gray900 = Color(0xFF1A1A1A);

  // Text Color Shortcuts
  static Color get textPrimary => text.bodyLarge?.color ?? scheme.onBackground;
  static Color get textSecondary =>
      text.bodyMedium?.color ?? scheme.onSurfaceVariant;
  static Color get textTertiary => text.bodySmall?.color ?? scheme.outline;
}

/// ---------------- GRADIENTS ----------------
class AppGradients {
  static const dark = RadialGradient(
    colors: [
      Color(0xFF5078EE),
      Color(0xFF9FC5F8),
    ],
    center: Alignment.centerLeft,
    radius: 6,
  );

  static const proGradient = RadialGradient(
    colors: [
      Color(0xFF5078EE),
      Color(0xFF9FC5F8),
    ],
    center: Alignment.bottomLeft,
    radius: 7,
  );

  static const progress = LinearGradient(
    colors: [Color(0xFFA64FC6), Color(0xFF8265E9), Color(0xFF86C0BF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const none = null;
}

/// ---------------- DURATIONS ----------------
class AppDurations {
  static const defaultAnim = Duration(milliseconds: 250);
  static const slideUp = Duration(milliseconds: 300);
  static const long = Duration(milliseconds: 600);
}

/// ---------------- PADDINGS & SPACING ----------------
class AppPaddings {
  static const small = EdgeInsets.all(8);
  static const medium = EdgeInsets.all(16);
  static const large = EdgeInsets.all(24);

  static const horizontal = EdgeInsets.symmetric(horizontal: 3);
  static const vertical = EdgeInsets.symmetric(vertical: 3);
  static const top = EdgeInsets.only(top: 16);
  static const bottom = EdgeInsets.only(bottom: 16);

  static const proCard = EdgeInsets.symmetric(horizontal: 20, vertical: 18);
  static const proSection = EdgeInsets.symmetric(horizontal: 24, vertical: 20);
}

/// ---------------- BORDER RADIUS ----------------
class AppRadius {
  static const small = BorderRadius.all(Radius.circular(8));
  static const medium = BorderRadius.all(Radius.circular(16));
  static const large = BorderRadius.all(Radius.circular(24));
  static const pro = BorderRadius.all(Radius.circular(32));
}

/// ---------------- SHADOWS ----------------
class AppShadows {
  static const soft = [
    BoxShadow(
      color: Colors.black26,
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  static const pro = [
    BoxShadow(
      color: Colors.black38,
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];
}

class AppText {
  // Access the TextTheme from Theme
  static BuildContext get ctx => Get.context!;

  // Access the TextTheme from Theme
  static TextTheme get text => Theme.of(ctx).textTheme;

  // ---------------- Predefined styles ----------------

  static TextStyle get bodyMedium => text.bodyMedium!;

  static TextStyle get bodySmall => text.bodySmall!;

  static TextStyle get labelSmall => text.labelSmall!;

  static TextStyle get headlineSmall => text.headlineSmall!;

  static TextStyle get headlineMedium => text.headlineMedium!;

  static TextStyle get displayLarge => text.displayLarge!;

  // ---------------- Helper methods to build Text widgets ----------------

  /// Title Widget (title)
  static Widget titleWidget({
    required String text,
    double size = 13,
    Color? color,
    FontWeight? weight,
    TextAlign textAlign = TextAlign.start,
    EdgeInsets padding = const EdgeInsets.symmetric(vertical: 4),
  }) {
    // Adjust size for Urdu and Arabic
    double finalSize = size;
    if (Get.locale != null &&
        (Get.locale!.languageCode == 'ur' ||
            Get.locale!.languageCode == 'ar')) {
      finalSize = 12;
    }

    return Padding(
      padding: padding,
      child: Text(
        text.tr,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
        style: GoogleFonts.poppins(
          fontSize: finalSize,
          fontWeight: weight ?? FontWeight.normal,
          color: color ?? AppColors.onSurface,
        ),
      ),
    );
  }

  static Widget labelWidget({
    required String text,
    double size = 12,
    Color? color = AppColors.gray100,
    FontWeight? weight,
    TextAlign textAlign = TextAlign.start,
    EdgeInsets padding = const EdgeInsets.symmetric(vertical: 2),
  }) {
    // Adjust size for Urdu and Arabic
    double finalSize = size;
    if (Get.locale != null &&
        (Get.locale!.languageCode == 'ur' ||
            Get.locale!.languageCode == 'ar')) {
      finalSize = 12;
    }

    return Padding(
      padding: padding,
      child: Text(
        text.tr,
        textAlign: textAlign,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.poppins(
          fontSize: finalSize,
          fontWeight: weight ?? FontWeight.w500,
          color: color ?? AppColors.onSurface,
        ),
      ),
    );
  }

  static Widget headingWidget({
    required String text,
    double size = 16,
    Color? color,
    Alignment alignment = Alignment.centerLeft,
    EdgeInsets padding = const EdgeInsets.all(5),
    IconData? icon,
    double iconSize = 20,
    Color? iconColor,
  }) {
    // Adjust size for Urdu and Arabic
    double finalSize = size;
    if (Get.locale != null &&
        (Get.locale!.languageCode == 'ur' ||
            Get.locale!.languageCode == 'ar')) {
      finalSize = 12;
    }

    return Padding(
      padding: padding,
      child: Align(
        alignment: alignment,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon,
                  size: iconSize,
                  color: iconColor ?? color ?? AppColors.textPrimary),
              const SizedBox(width: 6),
            ],
            Text(
              text.tr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: finalSize,
                fontWeight: FontWeight.bold,
                color: color ?? AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
