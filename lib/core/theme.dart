part of 'core.dart';

enum ThemeType { light, dark }

abstract class AppThemes {
  static const Color lightErrorColor = Colors.red;
  static const Color lightPrimaryColor = Color.fromRGBO(51, 204, 255, 1);
  static const Color lightSecondaryColor = Color.fromRGBO(0, 0, 51, 1);

  static String? font = Fonts.IranSansFaNum.fontFamily;

  static ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: lightPrimaryColor, secondary: lightSecondaryColor, error: lightErrorColor, primary: lightPrimaryColor),
    cardTheme: CardTheme(surfaceTintColor: Colors.white, elevation: 10, shadowColor: lightPrimaryColor.withOpacity(0.2)),
    highlightColor: Colors.green,
    fontFamily: font,
    iconTheme: const IconThemeData(color: lightPrimaryColor),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStatePropertyAll<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
        padding: const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16, vertical: 20)),
        backgroundColor: MaterialStateProperty.resolveWith((final Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled))
            return Colors.grey.shade700;
          else
            return lightSecondaryColor;
        }),
        foregroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
      ),
    ),
    listTileTheme: ListTileThemeData(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 8,
      subtitleTextStyle: TextStyle(fontSize: 12, fontFamily: font),
      titleTextStyle: TextStyle(fontFamily: font, fontSize: 16, color: lightSecondaryColor),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.black45),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
    ),
    dataTableTheme: DataTableThemeData(
      dataTextStyle: TextStyle(fontFamily: font, fontSize: 16, color: Colors.black87),
      headingTextStyle: TextStyle(fontFamily: font, fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
      headingRowColor: MaterialStateColor.resolveWith((final Set<MaterialState> states) => lightPrimaryColor.withOpacity(0.2)),
      headingRowHeight: 60,
    ),
    iconButtonTheme: const IconButtonThemeData(
      style: ButtonStyle(iconSize: MaterialStatePropertyAll<double>(32)),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 1000,
      backgroundColor: lightSecondaryColor.withOpacity(0.1),
      selectedIconTheme: const IconThemeData(size: 32),
      unselectedIconTheme: const IconThemeData(size: 32),
      selectedLabelStyle: const TextStyle(color: Colors.black),
      unselectedLabelStyle: const TextStyle(color: Colors.black),
      type: BottomNavigationBarType.fixed,
    ),
  );
}

abstract class AppImages {
  static const String _base = "lib/assets/images";
  static const String logo = "$_base/logo.png";
  static const String loginImage = "$_base/login_image.png";
  static const String profilePlaceholder = "$_base/profile_placeholder.png";
}
