import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/main.dart';

class AppLocalizations {
  Locale? locale;

  AppLocalizations(this.locale);

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Map<String, String>? _localizedStrings;

  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder
    String jsonString =
    await rootBundle.loadString('assets/lang/${locale!.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  static final languages = [
    'en',
    'da',
    'ar',
    'ur'
  ];

  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    return _localizedStrings![key]!;
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// update  languages
  void updateLocale(value) async {
    if (value.contains('_')) {
      // en_US
      locale = Locale(value.split('_').elementAt(0), value.split('_').elementAt(1));
    }
    else {
      // en
      locale = Locale(value);
    }
    await load();
  }
}
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.languages.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}



final langProviderRef = ChangeNotifierProvider((ref) => LangHelper());
class LangHelper extends ChangeNotifier{
  Locale? locale;

  changeLange(BuildContext context,String langCode){
    AppLocalizations.of(context)!.updateLocale(langCode);
    locale = Locale(langCode);
    notifyListeners();
  }

  List<Locale> supportedLocales() {
    return AppLocalizations.languages.map((_locale) {
      return fromStringToLocale(_locale.toString());
    }).toList();
  }

  Locale fromStringToLocale(String _locale) {
    if (_locale.contains('_')) {
      // en_US
      return Locale(_locale.split('_').elementAt(0), _locale.split('_').elementAt(1));
    }
    else {
      // en
      return Locale(_locale);
    }
  }

}