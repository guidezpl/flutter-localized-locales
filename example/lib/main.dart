import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        LocaleNamesLocalizationsDelegate(),
        // ... more localization delegates
      ],
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(LocaleNames.of(context).nameOf('en_GB')),
        // If the locale isn't supported
        Text(LocaleNames.of(context).nameOf('zzzz')),
        // If the locale is invalid, but a match can be found
        Text(LocaleNames.of(context).nameOf('es_ZZZ')),
      ],
    );
  }
}
