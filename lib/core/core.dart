import 'package:flutter/foundation.dart';
import 'package:utilities/data/dto/app_settings.dart';
import 'package:utilities/utilities.dart';
import 'package:utilities_admin_flutter/generated/l10n.dart';

part 'constants.dart';

part 'theme.dart';

part 'utils.dart';

abstract class Core {
  static String appVersion = "1.0.0";
  static List<CategoryReadDto> categories = <CategoryReadDto>[];
  static List<ContentReadDto> contents = <ContentReadDto>[];
  static late AppSettingsReadDto appSettingsReadDto;
  static late UserReadDto profile;
}
