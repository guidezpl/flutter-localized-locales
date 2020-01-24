library flutter_localized_locales;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class LocaleNames {
  static LocaleNames of(BuildContext context) {
    return Localizations.of<LocaleNames>(context, LocaleNames);
  }

  final String locale;
  final Map<String, String> data;
  LocaleNames(this.locale, this.data);

  String nameOf(String code) => data[code];

  List<MapEntry<String, String>> get sortedByCode {
    return data.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  }

  List<MapEntry<String, String>> get sortedByName {
    return data.entries.toList()..sort((a, b) => a.value.compareTo(b.value));
  }
}

class LocaleNamesLocalizationsDelegate
    extends LocalizationsDelegate<LocaleNames> {
  final AssetBundle bundle;
  const LocaleNamesLocalizationsDelegate({this.bundle});

  Future<List<String>> locales() async {
    return List<String>.from(
        await _loadJSON('languages.json') as List<dynamic>);
  }

  /// Returns a [Map] of locale codes to their native locale name.
  Future<Map<String, String>> allNativeNames() async {
    return Map<String, String>.from(
      await _loadJSON('data/_locales_native_names.json'),
    );
  }

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<LocaleNames> load(Locale locale) async {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    var locales = Set<String>.from(await this.locales());

    var availableLocale = Intl.verifiedLocale(
        localeName, (locale) => locales.contains(locale),
        onFailure: (_) => 'en');
    if (availableLocale == null) {
      return null;
    }

    final data = Map<String, String>.from(
        await _loadJSON('data/$availableLocale.json') as Map<dynamic, dynamic>);
    return LocaleNames(availableLocale, data);
  }

  @override
  bool shouldReload(LocalizationsDelegate<LocaleNames> old) {
    return false;
  }

  Future<dynamic> _loadJSON(key) {
    Future<dynamic> parser(String data) async => jsonDecode(data);
    final bundle = this.bundle ?? rootBundle;
    return bundle.loadStructuredData(
        'packages/flutter_localized_locales/' + key, parser);
  }
}
