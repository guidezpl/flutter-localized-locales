// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path/path.dart';
import 'dart:io';
import 'dart:typed_data';


import '../lib/main.dart';

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
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
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    await tester.pump(Duration(seconds: 2));
  });
}
