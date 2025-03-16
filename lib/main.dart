import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "interfaces/libs/l10n.dart";
import "interfaces/libs/providers.dart";
import "interfaces/libs/themes.dart";
import "interfaces/modules.dart";
import "libs/constants.dart";
import "libs/extensions.dart";
import "service_locator.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(
      ["google_fonts"],
      await rootBundle.rubikFontLicense(),
    );
  });

  await ServiceLocator.init();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppConfigsProviderState(:locale, :themeMode) =
        ref.watch(appConfigsProvider);

    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
      title: kAppName,
      debugShowCheckedModeBanner: false,
      //
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: themeMode,
      //
      localizationsDelegates: AppL10n.localizationsDelegates,
      supportedLocales: AppL10n.supportedLocales,
      locale: locale,
    );
  }
}
