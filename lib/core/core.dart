import 'package:flutter/foundation.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/generated/l10n.dart';
import 'package:utilities_admin_flutter/views/pages/main/main_controller.dart';

part 'constants.dart';

part 'theme.dart';

part 'utils.dart';

abstract class Core {
  static String appVersion = "1.0.0";
  static List<CategoryReadDto> categories = <CategoryReadDto>[];
  static List<ContentReadDto> contents = <ContentReadDto>[];
  static late AppSettingsReadDto appSettingsReadDto;
  static late UserReadDto user;
  static final Rx<MainPageType> mainPageType = MainPageType.dashboard.obs;
}
