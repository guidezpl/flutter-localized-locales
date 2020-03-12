import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:typed_data';

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    const prefix = "packages/flutter_localized_locales/";
    if (key.startsWith(prefix)) {
      var path = join(
          dirname(Platform.script.toFilePath()), key.substring(prefix.length));
      var bytes = Uint8List.fromList(await File(path).readAsBytes());
      var buffer = bytes.buffer;
      return ByteData.view(buffer);
    }
    return null;
  }
}

void main() {
  final bundle = TestAssetBundle();
  var delegate = LocaleNamesLocalizationsDelegate(bundle: bundle);
  test('provides list of locales()', () {
    expect(delegate.locales(), completion(isNotEmpty));
  });

  var localeDelegate = LocaleNamesLocalizationsDelegate(bundle: bundle);
  test('Locale delegate provides list of locale codes', () {
    expect(localeDelegate.locales(), completion(isNotEmpty));
  });

  test('Locale delegate provides map of native locale names', () {
    expect(localeDelegate.allNativeNames(), completion(isNotEmpty));
  });

  void checkLocaleTranslation(Locale locale, String cc, String name) {
    var d = localeDelegate;
    var f = (LocaleNames cn) => cn.nameOf(cc) == name;
    var matcher = completion(predicate(f, 'name of the $cc is "$name"'));
    expect(d.load(locale), matcher);
  }

  test('localizes locale by language', () {
    checkLocaleTranslation(Locale('de'), 'de_CH', 'Deutsch (Schweiz)');
    checkLocaleTranslation(Locale('en'), 'de_CH', 'German (Switzerland)');
    checkLocaleTranslation(Locale('ja'), 'de_CH', 'ドイツ語 (スイス)');
    checkLocaleTranslation(Locale('de'), 'de_CH', 'Deutsch (Schweiz)');
  });
  test('localizes locale by language and country', () {
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
  test('invalid locale gives null', () {
    checkLocaleTranslation(Locale('de'), 'zz', null);
  });
  test(
      'localized locale falls back to language when given invalid country for locale',
      () {
    checkLocaleTranslation(
        Locale('de', 'UK'), 'es_AR', 'Spanisch (Argentinien)');
  });
  test('localized locale falls back to English when given invalid locale', () {
    checkLocaleTranslation(Locale('zz'), 'es_AR', 'Spanish (Argentina)');
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
