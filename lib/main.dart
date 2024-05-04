import 'package:fl_utilities/fl_utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'common/assets.dart';
import 'common/constants.dart';
import 'common/env.dart';
import 'container.dart' as container;
import 'interfaces/app_l10n.dart';
import 'interfaces/ui.dart';
import 'interfaces/ux.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(
      ['google_fonts'],
      await rootBundle.rubikFontLicense(),
    );
  });

  await container.init();

  if (Env.isNoHashUrl) usePathUrlStrategy();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProvider.value(value: StoriesProvider()),
        Provider.value(value: container.get<PackageInfo>()),
      ],
      builder: (context, _) {
        /// To make sure redirect did'nt triggered on theme changes.
        final appRouter = router(context);

        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: ThemeModeProvider()),
            ChangeNotifierProvider.value(value: LocaleProvider()),
          ],
          builder: (context, _) {
            return MaterialApp.router(
              routerConfig: appRouter,
              title: kAppName,
              debugShowCheckedModeBanner: false,
              //
              theme: AppThemes.light,
              darkTheme: AppThemes.dark,
              themeMode: context.watch<ThemeModeProvider>().value,
              //
              localizationsDelegates: AppL10n.localizationsDelegates,
              supportedLocales: AppL10n.supportedLocales,
              locale: context.watch<LocaleProvider>().value,
            );
          },
        );
      },
    );
  }
}
