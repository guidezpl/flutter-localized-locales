# flutter_localized_locales

[flutter_localized_locales](https://pub.dev/packages/flutter_localized_locales) is a Flutter plugin which enables obtaining localized locale names from locale codes (ISO 639‑2 and ISO 639-3) for 563 locales.

This package is based on the [flutter_localized_countries](https://github.com/nickolas-pohilets/flutter-localized-countries) package. Data is taken from [https://github.com/umpirsky/locale-list](https://github.com/umpirsky/locale-list).

## Usage

### Loading
This package bundles required assets and provides a [LocalizationsDelegate](https://docs.flutter.io/flutter/widgets/LocalizationsDelegate-class.html) for loading them.

```dart
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

void main() {
  runApp(MaterialApp(
    localizationsDelegates: [
      LocaleNamesLocalizationsDelegate(),
      // ... more localization delegates
    ],
    ...
  );
```

### Getting a locale's name
```LocaleNames.of(context).nameOf(String locale)```
#### Example: On a device whose locale is English (en)
```dart
print(LocaleNames.of(context).nameOf('en_GB'));   // English (United Kingdom)

// If the locale isn't supported
print(LocaleNames.of(context).nameOf('zzzz'));     // English

// If the locale is invalid, but a match can be found
print(LocaleNames.of(context).nameOf('es_ZZZ'));  // Spanish
```
#### Example: On a device whose locale is French (fr)
```dart
print(LocaleNames.of(context).nameOf('en_GB'));   // anglais (Royaume-Uni)

// If the device locale isn't supported
print(LocaleNames.of(context).nameOf('zzzz'));     // français

// If the locale is invalid, but a match can be found
print(LocaleNames.of(context).nameOf('es_ZZZ'));  // espagnol
```

*Note:* If a device's locale isn't supported, English (en) names are used.


### Getting locale names, sorted
```LocaleNames.sortedByCode()```

```LocaleNames.sortedByName()```

### Getting all native locale names 
```LocaleNames.allNativeNames()```

For convenience, this package provides a map of locale codes to native locale names. This always returns the same data, irrespective of the device locale.
```dart
print(LocaleNames.allNativeNames());      // { ... af_ZA: Afrikaans (Suid-Afrika), ... ar: ال العربية السعودية) ...  as: অসমীয়া ... fr: Français ... en: English ... }
```

## Known Bugs

* Sorting by name does not respect the locale, because Flutter does not provide any [API for string collation](https://github.com/flutter/flutter/issues/27549).
