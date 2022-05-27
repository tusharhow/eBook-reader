import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyAppLocalization {
  MyAppLocalization(this.locale);

  final Locale locale;
  static MyAppLocalization of(BuildContext context) {
    return Localizations.of<MyAppLocalization>(context, MyAppLocalization);
  }

  static Map<String, String> _localizedValues;

  Future<void> load() async {
    print('assets/Language/${locale.languageCode}.json');
    String jsonStringValues = await rootBundle
        .loadString('assets/Language/${locale.languageCode}.json');
    print(jsonStringValues);
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String translate(String key) {
    return _localizedValues[key];
  }

  // static member to have simple access to the delegate from Material App
  static const LocalizationsDelegate<MyAppLocalization> delegate =
      _MyAppLocalizationDelegate();
}

class _MyAppLocalizationDelegate
    extends LocalizationsDelegate<MyAppLocalization> {
  const _MyAppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh', 'es', 'hi', 'ar', 'ru', 'ja', 'de']
        .contains(locale.languageCode);
  }

  @override
  Future<MyAppLocalization> load(Locale locale) async {
    MyAppLocalization localization = new MyAppLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<MyAppLocalization> old) => false;
}
