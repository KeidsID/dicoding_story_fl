import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/foundation.dart";
import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:url_launcher/url_launcher.dart";

import "package:dicoding_story_fl/libs/constants.dart";
import "package:dicoding_story_fl/service_locator.dart";

class AppAboutListTile extends StatelessWidget {
  const AppAboutListTile({super.key});

  VoidCallback _handleUrlVisit(BuildContext context, {required Uri url}) {
    return () async {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (kIsWeb) return; // skip invalid error on web

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
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    final packageInfo = ServiceLocator.find<PackageInfo>();

    return AboutListTile(
      icon: const Icon(Icons.info_outline),
      applicationName: kAppName,
      applicationIcon: const Image(
        image: AssetImages.appIconL,
        width: 80.0,
      ),
      applicationVersion: "v${packageInfo.version}"
          "${packageInfo.buildNumber.isNotEmpty ? "+${packageInfo.buildNumber}" : ""}",
      applicationLegalese: "MIT License\n\n"
          "Copyright (c) 2024 Kemal Idris [KeidsID]",
      aboutBoxChildren: [
        const SizedBox(height: 16.0),
        Builder(builder: (context) {
          final defaultTextStyle = DefaultTextStyle.of(context).style;
          final linkTextStyle = defaultTextStyle.apply(
            color: context.colorScheme.primary,
          );

          return Text.rich(TextSpan(
            children: [
              TextSpan(
                text: "App Icon",
                style: linkTextStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = _handleUrlVisit(
                    context,
                    url: Uri.parse(
                      "https://www.flaticon.com/free-icon/content_15911316",
                    ),
                  ),
              ),
              const TextSpan(text: " by "),
              TextSpan(
                text: "Adrly",
                style: linkTextStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = _handleUrlVisit(
                    context,
                    url: Uri.parse(
                      "https://www.flaticon.com/authors/adrly",
                    ),
                  ),
              ),
              const TextSpan(text: " on "),
              TextSpan(
                text: "flaticon.com",
                style: linkTextStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = _handleUrlVisit(
                    context,
                    url: Uri.parse("https://www.flaticon.com/"),
                  ),
              ),
              const TextSpan(text: "."),
            ],
          ));
        }),
        //
        const SizedBox(height: 8.0),
        Wrap(
          children: [
            TextButton(
              onPressed: _handleUrlVisit(
                context,
                url: Uri.parse("https://github.com/KeidsID/dicoding_story_fl"),
              ),
              child: const Text("Source Code"),
            )
          ],
        )
      ],
    );
  }
}
