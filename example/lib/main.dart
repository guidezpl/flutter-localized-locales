import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: [
        LocaleNamesLocalizationsDelegate(),
        // ... more localization delegates
      ],
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(LocaleNames.of(context)!.nameOf('zzzz').toString()),
          Text(LocaleNames.of(context)!.nameOf('fr_CA').toString()),
        ],
      ),
    );
  }
}
