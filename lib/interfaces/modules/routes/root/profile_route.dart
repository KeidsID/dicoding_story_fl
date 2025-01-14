import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";

import "package:dicoding_story_fl/interfaces/libs/constants.dart";
import "package:dicoding_story_fl/interfaces/libs/l10n/modules.dart";
import "package:dicoding_story_fl/interfaces/libs/providers.dart";
import "package:dicoding_story_fl/interfaces/libs/widgets.dart";

const profileRouteBuild = TypedGoRoute<ProfileRoute>(
  path: AppRoutePaths.profile,
);

final class ProfileRoute extends GoRouteData {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _ProfileRouteScreen();
  }
}

class _ProfileRouteScreen extends StatelessWidget {
  const _ProfileRouteScreen();

  final EdgeInsetsGeometry _padding = const EdgeInsets.all(16.0);

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.value;

    final appL10n = AppL10n.of(context)!;
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    final sectionHeaderTextStyle = textTheme.headlineSmall;

    return Scaffold(
      appBar: AppBar(title: Text(appL10n.yourProfile)),
      body: ListView(
        padding: _padding,
        children: [
          // profile section
          Text(appL10n.profile, style: sectionHeaderTextStyle),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(user?.name ?? "Anonymous"),
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
              user?.id ?? "",
              style: textTheme.labelMedium,
            ).applyOpacity(opacity: 0.5),
          ),
          const Divider(),
          const SizedBox(height: 8.0),

          // others section
          Text(appL10n.other(2), style: sectionHeaderTextStyle),
          ListTile(
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
          ),
          ListTile(
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
                onChanged: (value) => localeProvider.value = value,
              );
            }),
          ),
          const AppAboutListTile(),
        ],
      ),
    );
  }
}
