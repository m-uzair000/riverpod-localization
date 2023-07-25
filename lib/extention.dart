import 'package:flutter/cupertino.dart';
import 'package:localization/localization/app_localization.dart';

extension LanguageTranslation on String{
  String trans(BuildContext context) {
    return AppLocalizations.of(context)!.translate(this);
  }
}