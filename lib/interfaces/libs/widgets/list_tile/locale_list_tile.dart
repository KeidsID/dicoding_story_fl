import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "package:dicoding_story_fl/interfaces/libs/l10n.dart";
import "package:dicoding_story_fl/interfaces/libs/providers.dart";

class LocaleListTile extends StatelessWidget {
  const LocaleListTile({super.key});

  String _getLocaleName(BuildContext context, [Locale? locale]) {
    return switch ("$locale") {
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
      trailing: Consumer(builder: (context, ref, _) {
        final AppConfigsProviderState(:locale) = ref.watch(appConfigsProvider);

        return DropdownButton<Locale?>(
          value: locale,
          onChanged: (value) {
            ref.read(appConfigsProvider.notifier).setLocale(value);
          },
          items: [
            DropdownMenuItem(
              value: null,
              child: Text(_getLocaleName(context)),
            ),
            ...AppL10n.supportedLocales.map((supportedLocale) {
              return DropdownMenuItem(
                value: supportedLocale,
                child: Text(_getLocaleName(context, supportedLocale)),
              );
            })
          ],
        );
      }),
    );
  }
}
