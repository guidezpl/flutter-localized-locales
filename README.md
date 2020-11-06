# flutter_localized_locales

[flutter_localized_locales](https://pub.dev/packages/flutter_localized_locales) is a Flutter plugin which enables obtaining localized locale names from locale codes (ISO 639‑2 and ISO 639-3) for 563 locales.

This package is based on the [flutter_localized_countries](https://github.com/nickolas-pohilets/flutter-localized-countries) package. Data is taken from [https://github.com/umpirsky/locale-list](https://github.com/umpirsky/locale-list).

## Getting started

### Adding the localizations delegate
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

## Usage

### Getting a locale's name
```LocaleNames.of(context).nameOf(String locale)```

```dart
// Invalid locale string
print(LocaleNames.of(context).nameOf('zzzzz'));    // null

// On a device whose selected locale is English (en)
print(LocaleNames.of(context).nameOf('en_CA'));   // English (Canada)

// On a device whose selected locale is French (fr)
print(LocaleNames.of(context).nameOf('en_CA'));   // anglais (Canada)

// On a device whose selected locale isn't supported, an attempt is made to find a matching locale
// e.g. for a device whose locale is German (United Kingdom), returns German (de) names
print(LocaleNames.of(context).nameOf('en_CA'));   // Englisch (Kanada)

// Otherwise, English (en) names are returned. 
// You can specify a different fallback locale with
LocaleNamesLocalizationsDelegate(fallbackLocale: 'fr')
```

Supported locales are listed in [lib/locales.dart](lib/locales.dart).

### Getting all locale names, sorted
```LocaleNames.sortedByCode()```

```LocaleNames.sortedByName()```

### Getting all native locale names 
```LocaleNames.nativeLocaleNames```

For convenience, this package provides a map of locale codes to native locale names. This always returns the same data, irrespective of the device locale.
```dart
print(LocaleNames.nativeLocaleNames);      // { ... af_ZA: Afrikaans (Suid-Afrika), ... ar: ال العربية السعودية) ...  as: অসমীয়া ... fr: Français ... en: English ... }
```

## Known Bugs

* Sorting by name does not respect the locale, because Flutter does not provide any [API for string collation](https://github.com/flutter/flutter/issues/27549).
