import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:dicoding_story_fl/interfaces/libs/l10n/modules.dart";
import "package:dicoding_story_fl/interfaces/ui.dart";
import "package:dicoding_story_fl/interfaces/ux.dart";

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userCreds = authProvider.value;

    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final appL10n = AppL10n.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(appL10n.yourProfile)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(appL10n.profile, style: textTheme.headlineSmall),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(userCreds?.name ?? "Anonymous"),
          ),
          ListTile(
            iconColor: colorScheme.error,
            textColor: colorScheme.error,
            onTap: authProvider.isLoading ? null : () => authProvider.logout(),
            leading: const Icon(Icons.logout),
            title: Text(appL10n.logout),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              userCreds?.id ?? "",
              style: textTheme.labelMedium?.applyOpacity(0.5),
            ),
          ),
          const Divider(),

          //
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(appL10n.other(2), style: textTheme.headlineSmall),
          ),
          ListTile(
            leading: const Icon(Icons.color_lens_outlined),
            title: Text(appL10n.appTheme),
            trailing: Builder(builder: (context) {
              final themeModeProv = context.watch<ThemeModeProvider>();

              final icons = ThemeMode.values.map((e) {
                return switch (e) {
                  ThemeMode.system => Icons.settings_outlined,
                  ThemeMode.light => Icons.light_mode_outlined,
                  ThemeMode.dark => Icons.dark_mode_outlined,
                };
              }).toList();

              return DropdownButton<ThemeMode>(
                value: themeModeProv.value,
                items: ThemeMode.values.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icons[e.index]),
                        const SizedBox(width: 8.0),
                        Text(appL10n.flThemeMode(e.name)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => themeModeProv.value = value!,
              );
            }),
          ),
          ListTile(
            leading: const Icon(Icons.translate),
            title: Text(appL10n.language),
            trailing: Builder(builder: (context) {
              final localeProv = context.watch<LocaleProvider>();

              String localeString(String localeString) {
                return switch (localeString) {
                  "en" => "English",
                  "id" => "Bahasa Indonesia",
                  _ => appL10n.flThemeMode(ThemeMode.system.name),
                };
              }

              return DropdownButton<Locale?>(
                value: localeProv.value,
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
                onChanged: (value) => localeProv.value = value,
              );
            }),
          ),
          const AppAboutListTile(),
        ],
      ),
    );
  }
}
