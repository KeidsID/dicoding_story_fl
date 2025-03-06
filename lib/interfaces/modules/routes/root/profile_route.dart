import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

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

class _ProfileRouteScreen extends ConsumerWidget {
  const _ProfileRouteScreen();

  final EdgeInsetsGeometry _padding = const EdgeInsets.all(16.0);

  void _handleSignOut(WidgetRef ref) {
    ref.read(authProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authProvider);
    final user = authAsync.valueOrNull;

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
            onTap: authAsync.isLoading ? null : () => _handleSignOut(ref),
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
          const ThemeListTile(),
          const LocaleListTile(),
          const AppAboutListTile(),
        ],
      ),
    );
  }
}
