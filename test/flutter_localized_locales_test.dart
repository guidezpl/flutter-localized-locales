import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'dart:io';

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    const prefix = "packages/flutter_localized_locales/";
    // For testing, there is no packages/flutter_localized_locales, so we
    // load directly from the data directory
    if (key.startsWith(prefix)) {
      var path = join(
        dirname(Directory.current.absolute.path),
        'flutter-localized-locales',
        key.substring(prefix.length),
      );
      var bytes = Uint8List.fromList(await File(path).readAsBytes());
      var buffer = bytes.buffer;
      return ByteData.view(buffer);
    }
    throw "Error: Locale $key could not be found";
  }
}

void main() {
  final bundle = TestAssetBundle();
  var localeDelegate;

  setUp(() {
    localeDelegate = LocaleNamesLocalizationsDelegate(bundle: bundle);
  });

  test('Locale delegate provides list of locale codes', () {
    expect(LocaleNamesLocalizationsDelegate.locales, isNotEmpty);
  });

  test('Locale delegate provides map of native locale names', () {
    expect(LocaleNamesLocalizationsDelegate.nativeLocaleNames, isNotEmpty);
  });

  void checkLocaleTranslation(
    Locale localeToLoad,
    String locale,
    String? expectedName,
  ) {
    var matcher = (LocaleNames names) {
      final name = names.nameOf(locale);
      if (name == expectedName) {
        return true;
      }
      throw "nameOf('$locale') was '$name' instead of '$expectedName'";
    };
    expect(localeDelegate.load(localeToLoad), completion(matcher));
  }

  test('localizes locale string by language', () {
    checkLocaleTranslation(Locale('de'), 'de_CH', 'Deutsch (Schweiz)');
    checkLocaleTranslation(Locale('en'), 'de_CH', 'German (Switzerland)');
    checkLocaleTranslation(Locale('ja'), 'de_CH', 'ドイツ語 (スイス)');
    checkLocaleTranslation(Locale('de'), 'de_CH', 'Deutsch (Schweiz)');
  });
  test('localizes locale string by language and country', () {
    checkLocaleTranslation(Locale('de', 'CH'), 'be', 'Weissrussisch');
    checkLocaleTranslation(Locale('de', 'AT'), 'be', 'Weißrussisch');
    checkLocaleTranslation(
        Locale('de', 'CH'), 'en_GB', 'Englisch (Grossbritannien)');
    checkLocaleTranslation(
        Locale('de'), 'en_GB', 'Englisch (Vereinigtes Königreich)');
    checkLocaleTranslation(
        Locale('de', 'CH'), 'en_GB', 'Englisch (Grossbritannien)');
    checkLocaleTranslation(
        Locale('de'), 'en_GB', 'Englisch (Vereinigtes Königreich)');
  });
  test('returns null for an invalid locale string', () {
    checkLocaleTranslation(Locale('de'), 'zz', null);
  });
  test(
    'locale loading falls back to language when given partially valid (invalid country) locale',
    () {
      // de_UK is not a valid locale, but de is
      checkLocaleTranslation(
          Locale('de', 'UK'), 'es_AR', 'Spanisch (Argentinien)');
    },
  );
  test(
      'locale loading falls back to en when given invalid locale and fallback not specified',
      () {
    // zz is not a valid locale
    checkLocaleTranslation(Locale('zz'), 'es_AR', 'Spanish (Argentina)');
  });
  test('locale loading falls back to fallback locale when given invalid locale',
      () {
    localeDelegate = LocaleNamesLocalizationsDelegate(
      bundle: bundle,
      fallbackLocale: 'fr',
    );
    // zz is not a valid locale
    checkLocaleTranslation(Locale('zz'), 'es_AR', 'espagnol (Argentine)');
  });
  test('locale names can be sorted by code and name', () {
    // TODO: Sorting by name should be done in locale-aware manner
    final cn = LocaleNames('foo', {
      "de": "German",
      "ur_IN": "Urdu (India)",
      "bo": "Tibetan",
    });
    expect(cn.sortedByCode.map((e) => e.key), ['bo', 'de', 'ur_IN']);
    expect(cn.sortedByName.map((e) => e.key), ['de', 'bo', 'ur_IN']);
  });
}
