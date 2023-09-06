# flutter_localized_locales 
[![pub package](https://img.shields.io/pub/v/flutter_localized_locales.svg)](https://pub.dev/packages/flutter_localized_locales)

[flutter_localized_locales](https://pub.dev/packages/flutter_localized_locales) is a Flutter package which enables obtaining localized locale names from locale codes (ISO 639‑1) for 563 locales.

This package is based on the [flutter_localized_countries](https://github.com/nickolas-pohilets/flutter-localized-countries) package. Data is taken from [https://github.com/umpirsky/locale-list](https://github.com/umpirsky/locale-list).

## Getting started

### Adding the localizations delegate
This package bundles required assets and provides a [LocalizationsDelegate](https://docs.flutter.io/flutter/widgets/LocalizationsDelegate-class.html) for loading them. Specify `localizationsDelegates` for your `MaterialApp`, `CupertinoApp`, or `WidgetsApp`.

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

## Usage

### Locale name
```LocaleNames.of(context)!.nameOf(String locale)```

```dart
// Invalid locale string
print(LocaleNames.of(context)!.nameOf('zzzzz'));    // null

// On a device whose locale is English (en)
print(LocaleNames.of(context)!.nameOf('fr_CA'));   // French (Canada)

// On a device whose locale is Spanish (es)
print(LocaleNames.of(context)!.nameOf('fr_CA'));   // francés (Canadá)

// On a device whose locale isn't supported, an attempt is made to find a supported one
// e.g. for a device whose locale is German (United Kingdom), returns German (de) names
print(LocaleNames.of(context)!.nameOf('fr_CA'));   // Französisch (Kanada)

// On a device whose selected locale isn't supported, and no supported locale can be found,
// fallback to English (en) names. 
// You can specify a different fallback locale
// e.g. to fallback to Afrikaans (af) names instead of English
LocaleNamesLocalizationsDelegate(fallbackLocale: 'af')
```

Supported locales are listed in [lib/locales.dart](lib/locales.dart).

### All locale names, sorted
```LocaleNames.sortedByCode()```

```LocaleNames.sortedByName()```

### Respective locale names 
```LocaleNamesLocalizationsDelegate.nativeLocaleNames```

For convenience, this package provides a map of locale codes to their respective locale names. This always returns the same data, irrespective of the device locale.
```dart
print(LocaleNamesLocalizationsDelegate.nativeLocaleNames);      // { ... af_ZA: Afrikaans (Suid-Afrika), ... ar: ال العربية السعودية) ...  as: অসমীয়া ... fr: Français ... en: English ... }
```

## Known Bugs

* Sorting by name does not respect the locale, because Flutter does not provide any [API for string collation](https://github.com/flutter/flutter/issues/27549).
