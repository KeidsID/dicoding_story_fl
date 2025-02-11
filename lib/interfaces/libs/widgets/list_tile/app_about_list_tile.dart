import "package:dicoding_story_fl/interfaces/libs/widgets.dart";
import "package:flutter/material.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:url_launcher/url_launcher.dart";

import "package:dicoding_story_fl/interfaces/libs/l10n.dart";
import "package:dicoding_story_fl/libs/constants.dart";
import "package:dicoding_story_fl/service_locator.dart";

class AppAboutListTile extends StatelessWidget {
  const AppAboutListTile({super.key});

  String get _appIconUrl =>
      "https://www.flaticon.com/free-icon/content_15911316";
  String get _sourceCodeUrl => "https://github.com/KeidsID/dicoding_story_fl";

  VoidCallback _handleUrlVisit(BuildContext context, {required String url}) {
    return () async {
      final isSuccess = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );

      if (isSuccess) return;

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Url Visit Error"),
              content: Text("Cannot visit $url"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.maybePop(context),
                  child: const Text("Ok"),
                )
              ],
            );
          },
        );
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    final packageInfo = ServiceLocator.find<PackageInfo>();
    final appVersion = packageInfo.version;
    final appBuildNumber = packageInfo.buildNumber;

    final appL10n = AppL10n.of(context)!;

    return AboutListTile(
      icon: const Icon(Icons.info_outline),
      applicationName: kAppName,
      applicationIcon: AppImage.asset(AssetImagePaths.appIconL, width: 80.0),
      applicationVersion: "v$appVersion"
          "${appBuildNumber.isNotEmpty ? "+$appBuildNumber" : ""}",
      applicationLegalese: "MIT License\n\n"
          "Copyright (c) 2024 Kemal Idris [KeidsID]",
      aboutBoxChildren: [
        const SizedBox(height: 16.0),
        TextButton(
          onPressed: _handleUrlVisit(context, url: _appIconUrl),
          child: Text(appL10n.appIconCredits),
        ),
        const SizedBox(height: 8.0),
        TextButton(
          onPressed: _handleUrlVisit(context, url: _sourceCodeUrl),
          child: const Text("Source Code"),
        ),
      ],
    );
  }
}
