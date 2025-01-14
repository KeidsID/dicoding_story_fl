# App Localizations

Please sort the localization identifiers in alphabetical order.

```arb
{
  "login": "Log In",
  "postStory": "Post Story",
  "register": "Register",
}
```

## Contributing

[l10n_temp]: /lib/interfaces/libs/l10n/modules/app_en.arb

Want add new localization? Use [`/modules/app_en.arb`][l10n_temp] as
reference then save it as `app_<lang_code>.arb` or
`app_<lang_code>_<country_code>.arb` on `/modules`.

Locale codes references:

[lang_codes_ref]: https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes
[country_codes_ref]: https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes

- [ISO_639 (Language Codes)][lang_codes_ref]
- [ISO_3166 (Country Codes)][country_codes_ref]

Then on project root, run:

```bash
flutter gen-l10n
```
