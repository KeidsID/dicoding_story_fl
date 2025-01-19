# dicoding_story_fl

[dart-badge]: https://img.shields.io/badge/SDK-v3.3.4-red?style=flat&logo=dart&logoColor=2cb8f7&labelColor=333333&color=01579b
[fl-badge]: https://img.shields.io/badge/SDK-v3.19.6-red?style=flat&logo=flutter&logoColor=2cb8f7&labelColor=333333&color=01579b
[dicoding-fl]: https://www.dicoding.com/academies/480

![Dart version][dart-badge] ![Flutter][fl-badge]

Projects from [dicoding.com flutter class][dicoding-fl] as a practice in
advanced navigation, use of media (audio, images, and video), and use of maps
such as Google Maps.

## Table Of Contents

- [Developer Section](#developer-section)
  - [Requirements](#requirements)
  - [Dependencies](#dependencies)
  - [Setup](#setup)
  - [API Documentation](#api-documentation)
  - [Project Structures](#project-structures)
  - [Git Conventions](#git-conventions)
  - [Others](#others)

## Developer Section

### Requirements

[fl-archive]: https://docs.flutter.dev/release/archive
[fvm]: https://fvm.app/documentation

- Install [Flutter SDK][fl-archive] with the same version as defined on
  [`pubspec.yaml`](pubspec.yaml) or [`.fvmrc`](.fvmrc) file.

  You may use [FVM][fvm] (Flutter Version Manager) for easy installation.

  ```sh
  fvm use
  ```

### Dependencies

[build-runner]: https://pub.dev/packages/build_runner
[injectable]: https://pub.dev/packages/injectable
[freezed]: https://pub.dev/packages/freezed
[chopper]: https://pub.dev/packages/chopper
[shared_preferences]: https://pub.dev/packages/shared_preferences
[go_router]: https://pub.dev/packages/go_router
[provider]: https://pub.dev/packages/provider

Main packages that are used as foundation for this project.

- [injectable][injectable] -- Dependency injection framework.
- [freezed][freezed] -- Data model with short and simple syntax.
- [chopper][chopper] -- HTTP client service.
- [shared_preferences][shared_preferences] -- Local storage.
- [go_router][go_router] -- Web friendly routing.
- [provider][provider] -- State management.

Most of them need to generate its utilities with [build_runner][build-runner].

### Setup

1. Install dependencies

   ```sh
   flutter pub get
   ```

2. Intialize git hooks to validate commit messages

   ```sh
   dart run husky install
   ```

3. Create `.env` file. Use [`.env.example`](./.env.example) as a template.

4. You may also need to change Google Maps API key on android, ios, and web
   configs if you need to debug the app custom maps.

   Docs: <https://pub.dev/packages/google_maps_flutter>

5. Build project environment.

   ```sh
   dart run build_runner build -d # generate code utils
   flutter gen-l10n # generate localizations
   ```

6. Now you're good to go!

   ```sh
   # Check connected devices
   flutter devices

   # Check available emulators
   flutter emulators

   # Run app
   flutter run -d <device-id>
   ```

### API Documentation

[dicoding-story-api]: https://story-api.dicoding.dev/v1
[google-maps-docs]: https://developers.google.com/maps/get-started

- [Dicoding Story API Docs][dicoding-story-api].
- [Google Maps API Docs][google-maps-docs].

### Project Structures

[clean-architecture]: https://medium.com/@DrunknCode/clean-architecture-simplified-and-in-depth-guide-026333c54454

This project is follow the [Clean Architecture][clean-architecture] principles.

[main.dart]: ./lib/main.dart
[locator]: ./lib/service_locator.dart
[interfaces-doc]: ./lib/interfaces/modules/README.md
[l10n-doc]: ./lib/interfaces/libs/l10n/README.md

- `/lib` -- Source code

  - [`main.dart`][main.dart] -- Application entry point.

  - [`service_locator.dart`][locator] -- Service locator to get
    [injectable][injectable] services.

  - `/domain` -- Domain layer (Entities and services abstractions).

  - `/infrastructures` -- Infrastructure layer (Services implementations).

  - `/interfaces` -- Interfaces layer (Application routes, states, etc).
  
    - `/libs` -- Common constants, widgets, providers, and other utilities.

      - `/l10n` -- Application localizations. Please read the
        [README.md][l10n-doc].

    - `/modules` -- Application routes. Please read the
      [README.md][interfaces-doc].

  - `/use_cases` -- Application logic layer.

  - `**/libs` -- Common constants, or other utilities used by folder it belongs,
    e.g `/lib/libs` is global libs, `/lib/domain/libs` is domain libs, and so on.

### Git Conventions

[conventional-commits]: https://www.conventionalcommits.org

We use [Conventional Commits][conventional-commits] to handle Git commit
messages, and Github PR titles.

Look at [`dangerfile.dart`](dangerfile.dart) to see supported commit
types/scopes (the `GitlintConfig` class).

#### Issue Title

```sh
<type>(<scopes(optional)>): <content>
```

Examples:

- `feat: add simple auth`
- `bug(interfaces): unresponsive post story page`

##### Commit Message / PR Title

```sh
<type>(<scopes(optional)>): <content> ds-<issue-number>
```

Examples:

- `feat: add auth repo abstraction ds-25`
- `fix(interfaces): fix auth repo impl ds-250`
- `fix(domain/infrastructures): fix invalid stories request ds-502`

##### Branch Name

```sh
<type>-<content>-ds-<issue-number>
```

Examples:

- `chore-commitlint-ds-1`
- `fix-unresponsive-home-page-ds-250`

### Others

Other documentations that might be useful:

- [Dart Docs](https://dart.dev/guides)
- [Flutter Docs](https://docs.flutter.dev/)
- [Material Design](https://material.io)
