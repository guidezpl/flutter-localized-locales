// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path/path.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert' show utf8, jsonDecode;

import '../lib/main.dart';

class TAB2 extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    print ('Loading key $key ...');
    return await rootBundle.load(key);
  }

  @override
  Future<String> loadString(String key, { bool cache = true }) async {
    print ('Loading string $key ...');
    final ByteData data = await load(key);
    return utf8.decode(data.buffer.asUint8List());
  }

  @override
  Future<T> loadStructuredData<T>(String key, Future<T> parser(String value)) async {
    print ('Loading structured data $key ...');
    return await rootBundle.loadStructuredData(key, parser);
  }
}

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    print('Loading key $key ...');

    return await rootBundle.load(key);

    const prefix = "packages/flutter_localized_locales/";
    if (key.startsWith(prefix)) {
      var path = join(dirname(Directory.current.absolute.path),
          key.substring(prefix.length));
      var bytes = Uint8List.fromList(await File(path).readAsBytes());
      var buffer = bytes.buffer;
      return ByteData.view(buffer);
    }
    throw "Error: Locale $key could not be found";
  }

  @override
  Future<T> loadStructuredData<T>(String key, Future<T> parser(String value)) async {
    print ('Loading structured data $key ...');
    return await rootBundle.loadStructuredData(key, (data) => jsonDecode(data));
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    print('Loading string $key');

    final ByteData data = await load(key);
    return utf8.decode(data.buffer.asUint8List());
  }
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: [
          LocaleNamesLocalizationsDelegate(),
        ],
        home: DefaultAssetBundle(
          bundle: TAB2(),
          child: Home(),
        ),
        supportedLocales: [Locale('de', 'AT')],
      ),
    );
    await tester.pumpAndSettle();

    await tester.pump(Duration(seconds: 2));
  });
}
