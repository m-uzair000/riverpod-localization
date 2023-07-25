import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final languageProvider = ChangeNotifierProvider((ref) => Languages());

class Languages extends ChangeNotifier {

  /// selected langua ge json
  final translations = Map<String, Map<String, String>>();

  /// fallbackLocale saves the day when the locale gets in trouble
  final fallbackLocale = const Locale('en', 'US');

  /// must add language codes here
  static final languages = [
    {
      'key':'en',
      'flag':'assets/flags/us.svg'
    },
    {
      'key':'da',
      'flag':'assets/flags/dk.svg'
    },
    {
      'key':'ar',
      'flag':'assets/flags/sa.svg'
    },
  ];

  /// initialize the translation service by loading the assets/locales folder
  /// the assets/locales folder must contains file for each language that named
  /// with the code of language concatenate with the country code
  /// for example (en.json)
  Future<Languages> init() async {
    languages.forEach((lang) async {
      var _file = await getJsonFile('assets/lang/${lang['key']}.json');
      translations.putIfAbsent(lang['key'].toString(), () => Map<String, String>.from(_file));
    });
    return this;
  }

  /// get list of supported local in the application
  List<Locale> supportedLocales() {
    return Languages.languages.map((_locale) {
      return fromStringToLocale(_locale['key'].toString());
    }).toList();
  }

  /// Convert string code to local object
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

  /// get initial Language
  Locale getLocale() {
    String locale = 'en';

    return fromStringToLocale(locale);
  }

  /// update  languages
  void updateLocale(value) async {
    if (value.contains('_')) {
      // en_US
      updateLocale(Locale(value.split('_').elementAt(0), value.split('_').elementAt(1)));
    }
    else {
      // en
      updateLocale(Locale(value));
    }
  }

  /// get json file
  static Future<dynamic> getJsonFile(String path) async {
    return rootBundle.loadString(path).then(convert.jsonDecode);
  }

}
