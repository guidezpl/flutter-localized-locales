## [2.0.5]
* Add `repository` to pubspec
 
## [2.0.4]
* Widen intl constraint

## [2.0.3]
* Update documentation for null safety and `nativeLocaleNames`

## [2.0.2]
* Fix test
* Use stable null-safe dependencies
* Improve documentation

## [2.0.1]
* Fix mistake by doing dependency upgrade from beta channel instead of master channel

## [2.0.0]
* Stable release for null safety

## [2.0.0-nullsafety.1]
* Bump intl dependency to 0.17.0-nullsafety.2

## [2.0.0-nullsafety]
* Migrate to null safety
* Add ability to override default fallback locale of 'en' with `LocaleNamesLocalizationsDelegate.fallbackLocale`
* Improve documentation and rename test variables for clarity

## [1.1.2]
* Run dartfmt on locales
* Fix example not showing up properly on pub.dev
* Bump up dependencies and fix tests

## [1.1.1]
* Revert a change that caused a bug for unsupported locales

## [1.1.0]

* Simplify obtaining all locales and native locale names by encoding them in Dart instead of JSON
  * No more need for a class instance or to wait for promises

## [1.0.4]

* Fix bug where native locale names could not be obtained on web if using [peanut](https://pub.dev/packages/peanut)
* Rename test file

## [1.0.3]

* Reverse order of CHANGELOG

## [1.0.2]

* More README & pubspec updates

## [1.0.1]

* README & pubspec updates, added an example

## [1.0.0]

* Initial release
