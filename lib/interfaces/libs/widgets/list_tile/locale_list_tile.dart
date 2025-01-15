import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:dicoding_story_fl/interfaces/libs/l10n.dart";
import "package:dicoding_story_fl/interfaces/libs/providers.dart";

class LocaleListTile extends StatelessWidget {
  const LocaleListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final appL10n = AppL10n.of(context)!;

    return ListTile(
      leading: const Icon(Icons.language_outlined),
      title: Text(appL10n.language),
      trailing: Builder(builder: (context) {
        final localeProvider = context.watch<LocaleProvider>();

        String localeString(String localeString) {
          return switch (localeString) {
            "en" => "English",
            "id" => "Bahasa Indonesia",
            _ => appL10n.flThemeMode(ThemeMode.system.name),
          };
        }

        return DropdownButton<Locale?>(
          value: localeProvider.value,
          onChanged: (value) => localeProvider.value = value,
          items: [
            DropdownMenuItem(
              value: null,
              child: Text(localeString("system")),
            ),
            ...AppL10n.supportedLocales.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(localeString("$e")),
              );
            })
          ],
        );
      }),
    );
  }
}
