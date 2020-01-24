import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localized_countries/flutter_localized_countries.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:typed_data';

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    const prefix = "packages/flutter_localized_countries/";
    if (key.startsWith(prefix)) {
      var path = join(dirname(Platform.script.toFilePath()), key.substring(prefix.length));
      var bytes = Uint8List.fromList(await File(path).readAsBytes());
      var buffer = bytes.buffer;
      return ByteData.view(buffer);
    }
    return null;
  }
}

void main() {
  final bundle = TestAssetBundle();
  var delegate = CountryNamesLocalizationsDelegate(bundle: bundle);
  test('provides list of locales()', () {
    expect(delegate.locales(), completion(isNotEmpty));
  });

  void checkTranslation(Locale locale, String cc, String name) {
    var d = delegate;
    var f = (CountryNames cn) => cn.nameOf(cc) == name;
    var matcher = completion(predicate(f, 'name of the $cc is "$name"'));
    expect(d.load(locale), matcher);
  }
  
  test('localizes by language', () {
    checkTranslation(Locale('de'), 'CH', 'Schweiz');
    checkTranslation(Locale('en'), 'CH', 'Switzerland');
    checkTranslation(Locale('ja'), 'CH', 'スイス');
    checkTranslation(Locale('de'), 'CH', 'Schweiz');
  });

  test('localizes by language and country', () {
    checkTranslation(Locale('de', 'CH'), 'BY', 'Weissrussland');
    checkTranslation(Locale('de', 'AT'), 'BY', 'Belarus');
    checkTranslation(Locale('de', 'CH'), 'GB', 'Grossbritannien');
    checkTranslation(Locale('de'), 'GB', 'Vereinigtes Königreich');
  });
  test('language and country falls back to language only', () {
    checkTranslation(Locale('de', 'UK'), 'GB', 'Vereinigtes Königreich');
  });
  test('language falls back to English', () {
    checkTranslation(Locale('zz'), 'GB', 'United Kingdom');
  });
  test('languages can be sorted by code and name', () {
    // TODO: Sorting by name should be done in locale-aware manner
    final cn = CountryNames('foo', {
      "BL": "St. Barthélemy",
      "DE": "Germany",
      "US": "United States",
    });
    expect(cn.sortedByCode.map((e) => e.key), ['BL', 'DE', 'US']);
    expect(cn.sortedByName.map((e) => e.key), ['DE', 'BL', 'US']);
  });
}
