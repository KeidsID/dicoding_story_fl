# App Localizations

Please sort the localization identifiers in alphabetical order.

```arb
{
  "login": "Log In",
  "postStory": "Post Story",
  "register": "Register",
}
```

### Contributing

Want add new localization? Copy `app_id.arb` and modify it then save it as
`app_<lang_code>.arb` or `app_<lang_code>_<country_code>.arb`.

Locale codes references:
- https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes
- https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes

Then on project root, run:

```
flutter gen-l10n
```
