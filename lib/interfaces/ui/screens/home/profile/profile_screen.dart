import 'package:dicoding_story_fl/common/constants.dart';
import 'package:fl_utilities/fl_utilities.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'package:dicoding_story_fl/container.dart' as container;
import 'package:dicoding_story_fl/interfaces/ui.dart';
import 'package:dicoding_story_fl/interfaces/ux.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userCreds = authProvider.userCreds;

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
