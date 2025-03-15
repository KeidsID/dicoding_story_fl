import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "package:dicoding_story_fl/interfaces/libs/l10n.dart";
import "package:dicoding_story_fl/interfaces/libs/providers.dart";

class ThemeListTile extends StatelessWidget {
  const ThemeListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final appL10n = AppL10n.of(context)!;

    return ListTile(
      leading: const Icon(Icons.color_lens_outlined),
      title: Text(appL10n.appTheme),
      trailing: Consumer(builder: (context, ref, _) {
        final AppConfigsProviderState(:themeMode) =
            ref.watch(appConfigsProvider);

        final icons = ThemeMode.values.map((e) {
          return switch (e) {
            ThemeMode.system => Icons.settings_outlined,
            ThemeMode.light => Icons.light_mode_outlined,
            ThemeMode.dark => Icons.dark_mode_outlined,
          };
        }).toList();

        return DropdownButton<ThemeMode>(
          value: themeMode,
          onChanged: (value) {
            ref.read(appConfigsProvider.notifier).setThemeMode(value!);
          },
          items: ThemeMode.values.map((mode) {
            return DropdownMenuItem<ThemeMode>(
              value: mode,
              child: Row(
                children: [
                  Icon(icons[mode.index]),
                  const SizedBox(width: 8.0),
                  Text(appL10n.flThemeMode(mode.name)),
                ],
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}
