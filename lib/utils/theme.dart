import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Primary Brand Colors - Professional Medical Blue
  static const Color primaryBlue = Color(0xFF2563EB); // Medical Blue
  static const Color primaryBlueDark = Color(0xFF1D4ED8);
  static const Color primaryBlueLight = Color(0xFF3B82F6);
  static const Color primaryBlueExtraLight = Color(0xFFEBF4FF);

  // Glucose Level Colors - Medically Accurate
  static const Color glucoseNormal = Color(0xFF059669); // Professional Green
  static const Color glucoseLow = Color(0xFFDC2626); // Medical Red
  static const Color glucoseHigh = Color(0xFFEA580C); // Medical Orange
  static const Color glucoseVeryHigh = Color(0xFFB91C1C); // Dark Red
  static const Color glucoseCritical = Color(0xFF7C2D12); // Critical Brown-Red

  // Semantic Colors
  static const Color successGreen = Color(0xFF059669);
  static const Color warningOrange = Color(0xFFEA580C);
  static const Color errorRed = Color(0xFFDC2626);
  static const Color infoBlue = Color(0xFF0284C7);

  // Neutral Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF64748B);
  static const Color neutralGray = Color(0xFF94A3B8);
  static const Color neutralLightGray = Color(0xFFCBD5E1);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF1F5F9);
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  // Border Colors
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderMedium = Color(0xFFCBD5E1);
  static const Color borderDark = Color(0xFF94A3B8);

  // Feature-specific Colors
  static const Color scanColor = Color(0xFF8B5CF6); // Purple for scan
  static const Color insightsColor = Color(0xFF06B6D4); // Cyan for insights
  static const Color profileColor = Color(0xFF10B981); // Emerald for profile
  static const Color mealColor = Color(0xFFF59E0B); // Amber for meals
  static const Color medicationColor = Color(0xFF3B82F6); // Blue for medication
  static const Color exerciseColor = Color(0xFFEF4444); // Red for exercise
  static const Color sleepColor = Color(0xFF6366F1); // Indigo for sleep

  // Mood Colors
  static const Color moodGreat = Color(0xFF22C55E); // Green
  static const Color moodGood = Color(0xFF84CC16); // Lime
  static const Color moodOkay = Color(0xFFF59E0B); // Amber
  static const Color moodTired = Color(0xFFEF4444); // Red
  static const Color moodStressed = Color(0xFF8B5CF6); // Purple

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryBlueDark],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [successGreen, Color(0xFF047857)],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [warningOrange, Color(0xFFDC2626)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundWhite, Color(0xFFFAFBFF)],
  );

  static const LinearGradient glucoseGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFECFDF5), Color(0xFFF0FDF4)],
  );

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundLight,
      
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        primaryContainer: primaryBlueExtraLight,
        secondary: successGreen,
        secondaryContainer: Color(0xFFECFDF5),
        surface: backgroundWhite,
        background: backgroundLight,
        error: errorRed,
        onPrimary: backgroundWhite,
        onSecondary: backgroundWhite,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: backgroundWhite,
        outline: borderLight,
        outlineVariant: borderMedium,
      ),

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: primaryBlue,
        foregroundColor: backgroundWhite,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: backgroundWhite,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(
          color: backgroundWhite,
          size: 24,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: backgroundWhite,
          elevation: 2,
          shadowColor: primaryBlue.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          backgroundColor: primaryBlueExtraLight,
          side: BorderSide(color: primaryBlue.withOpacity(0.2)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: const TextStyle(
          color: textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: const TextStyle(
          color: neutralGray,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: const TextStyle(
          color: errorRed,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryBlue,
        foregroundColor: backgroundWhite,
        elevation: 6,
        focusElevation: 8,
        hoverElevation: 8,
        highlightElevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: surfaceLight,
        selectedColor: primaryBlueExtraLight,
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: borderLight,
        thickness: 1,
        space: 1,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: backgroundWhite,
        selectedItemColor: primaryBlue,
        unselectedItemColor: neutralGray,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryBlue;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(backgroundWhite),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryBlue;
          }
          return neutralGray;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryBlue.withOpacity(0.3);
          }
          return neutralLightGray;
        }),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryBlue,
        linearTrackColor: borderLight,
        circularTrackColor: borderLight,
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryBlueLight,
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      
      colorScheme: const ColorScheme.dark(
        primary: primaryBlueLight,
        primaryContainer: Color(0xFF1E293B),
        secondary: successGreen,
        secondaryContainer: Color(0xFF064E3B),
        surface: Color(0xFF1E293B),
        background: Color(0xFF0F172A),
        error: errorRed,
        onPrimary: Color(0xFF0F172A),
        onSecondary: Color(0xFF0F172A),
        onSurface: Color(0xFFF8FAFC),
        onBackground: Color(0xFFF8FAFC),
        onError: Color(0xFFF8FAFC),
        outline: Color(0xFF334155),
        outlineVariant: Color(0xFF475569),
      ),

      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Color(0xFF1E293B),
        foregroundColor: Color(0xFFF8FAFC),
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Color(0xFFF8FAFC),
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(
          color: Color(0xFFF8FAFC),
          size: 24,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlueLight,
          foregroundColor: const Color(0xFF0F172A),
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF334155),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF475569)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF475569)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryBlueLight, width: 2),
        ),
        labelStyle: const TextStyle(
          color: Color(0xFF94A3B8),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF64748B),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),

    );
  }

  // Helper Methods for Glucose Colors
  static Color getGlucoseColor(double glucoseLevel) {
    if (glucoseLevel < 54) {
      return glucoseCritical; // Severe hypoglycemia (<54 mg/dL)
    } else if (glucoseLevel < 70) {
      return glucoseLow; // Hypoglycemia (54-69 mg/dL)
    } else if (glucoseLevel <= 180) {
      return glucoseNormal; // Normal range (70-180 mg/dL)
    } else if (glucoseLevel <= 250) {
      return glucoseHigh; // Hyperglycemia (181-250 mg/dL)
    } else {
      return glucoseVeryHigh; // Severe hyperglycemia (>250 mg/dL)
    }
  }

  static String getGlucoseStatus(double glucoseLevel) {
    if (glucoseLevel < 54) {
      return 'Critical Low';
    } else if (glucoseLevel < 70) {
      return 'Low';
    } else if (glucoseLevel <= 180) {
      return 'In Range';
    } else if (glucoseLevel <= 250) {
      return 'High';
    } else {
      return 'Very High';
    }
  }

  static String getGlucoseAdvice(double glucoseLevel) {
    if (glucoseLevel < 54) {
      return 'Seek immediate medical attention';
    } else if (glucoseLevel < 70) {
      return 'Treat low blood sugar immediately';
    } else if (glucoseLevel <= 180) {
      return 'Keep up the good work!';
    } else if (glucoseLevel <= 250) {
      return 'Consider adjusting medication or diet';
    } else {
      return 'Contact your healthcare provider';
    }
  }

  static Color getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'great':
        return moodGreat;
      case 'good':
        return moodGood;
      case 'okay':
        return moodOkay;
      case 'tired':
        return moodTired;
      case 'stressed':
        return moodStressed;
      default:
        return moodOkay;
    }
  }

  static Color getGlucoseColorFromReading(bool isLow, bool isHigh) {
    if (isLow) return glucoseLow;
    if (isHigh) return glucoseHigh;
    return glucoseNormal;
  }

  // Text Styles
  static const TextStyle appBarTitleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: backgroundWhite,
    letterSpacing: -0.5,
  );

  static const TextStyle headingLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.2,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textTertiary,
    height: 1.3,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: neutralGray,
    letterSpacing: 0.1,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
  );

  // Glucose Display Styles
  static const TextStyle glucoseValueStyle = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w800,
    letterSpacing: -2,
    height: 1.0,
  );

  static const TextStyle glucoseValueLarge = TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.w900,
    letterSpacing: -3,
    height: 0.9,
  );

  static const TextStyle glucoseUnitStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textSecondary,
  );

  static const TextStyle glucoseStatusStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: backgroundWhite,
  );

  static const TextStyle glucoseTimestampStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textTertiary,
  );

  // Card Title Styles
  static const TextStyle cardTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.1,
  );

  static const TextStyle cardSubtitleStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textSecondary,
  );

  // Shadow Styles
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.02),
      blurRadius: 40,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get lightShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get mediumShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 15,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get bottomNavShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, -5),
    ),
  ];

  static List<BoxShadow> get glucoseCardShadow => [
    BoxShadow(
      color: primaryBlue.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  // Border Radius
  static const BorderRadius cardBorderRadius = BorderRadius.all(Radius.circular(16));
  static const BorderRadius buttonBorderRadius = BorderRadius.all(Radius.circular(14));
  static const BorderRadius inputBorderRadius = BorderRadius.all(Radius.circular(16));
  static const BorderRadius chipBorderRadius = BorderRadius.all(Radius.circular(12));
  static const BorderRadius smallBorderRadius = BorderRadius.all(Radius.circular(8));
  static const BorderRadius largeBorderRadius = BorderRadius.all(Radius.circular(20));

  // Spacing
  static const double spacingXS = 4;
  static const double spacingS = 8;
  static const double spacingM = 16;
  static const double spacingL = 24;
  static const double spacingXL = 32;
  static const double spacingXXL = 48;

  // Icon Sizes
  static const double iconSizeSmall = 16;
  static const double iconSizeMedium = 24;
  static const double iconSizeLarge = 32;
  static const double iconSizeXLarge = 48;

  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  static const Duration extraSlowAnimation = Duration(milliseconds: 800);

  // Breakpoints for responsive design
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }
}
