[class-link]: https://www.dicoding.com/academies/480

# dicoding_story_fl

Projects from [dicoding.com flutter class][class-link] as a practice in advanced
navigation, use of media (audio, images, and video), and use of maps such as
Google Maps.

Story API: https://story-api.dicoding.dev/v1/

## TODO

### Mandatory

- [x] Auth Pages.
- [ ] Story Pages.
- [ ] Add Story Page.
- [ ] Advanced Navigation.

### Optional

- [ ] Localization.

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

  - `container.dart`, container for locating a dependencies. Act as adpater for
    core and infrastructures.
