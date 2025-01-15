import "package:flutter/material.dart";
import "package:provider/provider.dart";

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
      trailing: Builder(builder: (context) {
        final themeModeProvider = context.watch<ThemeModeProvider>();

        final icons = ThemeMode.values.map((e) {
          return switch (e) {
            ThemeMode.system => Icons.settings_outlined,
            ThemeMode.light => Icons.light_mode_outlined,
            ThemeMode.dark => Icons.dark_mode_outlined,
          };
        }).toList();

        return DropdownButton<ThemeMode>(
          value: themeModeProvider.value,
          items: ThemeMode.values.map((e) {
            return DropdownMenuItem<ThemeMode>(
              value: e,
              child: Row(
                children: [
                  Icon(icons[e.index]),
                  const SizedBox(width: 8.0),
                  Text(appL10n.flThemeMode(e.name)),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) => themeModeProvider.value = value!,
        );
      }),
    );
  }
}
