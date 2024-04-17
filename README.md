[class-link]: https://www.dicoding.com/academies/480
[web-release]: https://dicoding-story.vercel.app/
[web-preview]: https://dicoding-story-preview.vercel.app/

# dicoding_story_fl

![Dart version](https://img.shields.io/badge/SDK-^3.0.2-red?style=flat&logo=dart&logoColor=2cb8f7&labelColor=333333&color=01579b)
![Flutter](https://img.shields.io/badge/SDK-^3.10.2-red?style=flat&logo=flutter&logoColor=2cb8f7&labelColor=333333&color=01579b)

[![Test](https://github.com/KeidsID/dicoding_story_fl/actions/workflows/test.yml/badge.svg)](https://github.com/KeidsID/dicoding_story_fl/actions/workflows/test.yml)
[![Web Preview](https://github.com/KeidsID/dicoding_story_fl/actions/workflows/web-preview.yml/badge.svg)][web-preview]

[![Web Release](https://github.com/KeidsID/dicoding_story_fl/actions/workflows/web-release.yml/badge.svg)][web-release]

Projects from [dicoding.com flutter class][class-link] as a practice in advanced
navigation, use of media (audio, images, and video), and use of maps such as
Google Maps.

Story API: https://story-api.dicoding.dev/v1/

## TODO

### Mandatory

- [x] Auth Pages.
- [x] Stories Page.
- [x] Story Detail Page.
- [x] Add/Post Story Page.
- [x] Advanced Navigation.

### Optional

- [x] Localization.

## Project Structure

This project use
[Clean Architecture](https://www.freecodecamp.org/news/a-quick-introduction-to-clean-architecture-990c014448d2/)
pattern:

- `lib/` App source code.

  - `main.dart`, app entry point.

  - `common/`

    Contains common code used across the source code. Such as constants
    variables.

  - `core/`

    Contains the abstraction of a business logics.

  - `infrastructures/`

    Contains implementations of core abstractions.

  - `interfaces/`

    Contains interfaces of the app.

    - `ui/`, contains UI code (what end users see). Such as widgets and pages.
    - `ux/`, contains UX code (app behaviour). Such as router and states.

  - `container.dart`, container for locating a dependencies. Act as adpater
    between core and infrastructures.
