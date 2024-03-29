import 'package:fl_utilities/fl_utilities.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'package:dicoding_story_fl/common/constants.dart';
import 'package:dicoding_story_fl/container.dart' as container;
import 'package:dicoding_story_fl/interfaces/ux.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userCreds = authProvider.value;

    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('Profile', style: textTheme.headlineSmall),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(userCreds?.name ?? 'Anonymous'),
          ),
          ListTile(
            iconColor: colorScheme.error,
            textColor: colorScheme.error,
            onTap: authProvider.isLoading ? null : () => authProvider.logout(),
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              userCreds?.id ?? '',
              style: textTheme.labelMedium?.applyOpacity(0.5),
            ),
          ),
          const Divider(),

          //
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Apps', style: textTheme.headlineSmall),
          ),
          ListTile(
            leading: const Icon(Icons.color_lens_outlined),
            title: const Text('App Theme'),
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
                        Text(e.name.capitalize),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => themeModeProv.value = value!,
              );
            }),
          ),
          ListTile(
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: appName,
                applicationVersion: 'v${container.get<PackageInfo>().version}',
              );
            },
            leading: const Icon(Icons.info_outline),
            title: const Text('About App'),
          ),
        ],
      ),
    );
  }
}
