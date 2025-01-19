import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:dicoding_story_fl/interfaces/libs/l10n.dart";
import "package:dicoding_story_fl/interfaces/libs/providers.dart";

class LocaleListTile extends StatelessWidget {
  const LocaleListTile({super.key});

  String _handleLanguageName(BuildContext context, String languageCode) {
    return switch (languageCode) {
      "en" => "English",
      "id" => "Bahasa Indonesia",
      _ => AppL10n.of(context)!.flThemeMode(ThemeMode.system.name),
    };
  }

  @override
  Widget build(BuildContext context) {
    final appL10n = AppL10n.of(context)!;

    return ListTile(
      leading: const Icon(Icons.language_outlined),
      title: Text(appL10n.language),
      trailing: Builder(builder: (context) {
        final localeProvider = context.watch<LocaleProvider>();

        return DropdownButton<Locale?>(
          value: localeProvider.value,
          onChanged: (value) => localeProvider.value = value,
          items: [
            DropdownMenuItem(
              value: null,
              child: Text(_handleLanguageName(context, "system")),
            ),
            ...AppL10n.supportedLocales.map((locale) {
              return DropdownMenuItem(
                value: locale,
                child: Text(_handleLanguageName(context, "$locale")),
              );
            })
          ],
        );
      }),
    );
  }
}
