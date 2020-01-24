# flutter_localized_countries

Country code to name mappings for 122 languages.

This is a port of an npm package [localized-countries](https://github.com/marcbachmann/localized-countries) for [Flutter](https://flutter.io).

Data is taken from [https://github.com/umpirsky/country-list](https://github.com/umpirsky/country-list).

This package bundles required assets and provides custom [LocalizationsDelegate](https://docs.flutter.io/flutter/widgets/LocalizationsDelegate-class.html) for loading them.

## Usage
```$dart
import 'package:flutter_localized_countries/flutter_localized_countries.dart';

void main() {
  runApp(MaterialApp(
    localizationsDelegates: [
      CountryNamesLocalizationsDelegate(),
      // ... more localization delegates
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    ...
  );
  
  ...
  
  print(CountryNames.of(context).nameOf('NL'));
}
```

## Known Bugs

* Sorting countries by name does not respect the locale, because Flutter does not provide any [API for string collation](https://github.com/flutter/flutter/issues/27549).
