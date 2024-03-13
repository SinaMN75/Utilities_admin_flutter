part of 'core.dart';

abstract class AppConstants {
  static String baseUrl = kDebugMode ? "https://api.sinamn75.com/api" : "https://api.sinamn75.com/api";

  // static String baseUrl = kDebugMode ? "https://api.directshod.com/api" : "https://api.directshod.com/api";

  static const String userId = "userId";
}

enum SortType { newest, oldest, cheapest, moreExpensive }
