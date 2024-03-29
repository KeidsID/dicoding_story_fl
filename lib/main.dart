import 'package:dicoding_story_fl/common/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'common/asset_paths.dart';
import 'container.dart' as container;
import 'interfaces/ui.dart';
import 'interfaces/ux.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LicenseRegistry.addLicense(() async* {
    final rubikLicense =
        await rootBundle.loadString(AssetPaths.rubikFontLicense);

    yield LicenseEntryWithLineBreaks(['google_fonts'], rubikLicense);
  });

  await container.init();

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
      ],
      builder: (context, _) {
        /// To make sure redirect did'nt triggered on theme changes.
        final appRouter = router(context);

        return ChangeNotifierProvider.value(
          value: ThemeModeProvider(),
          builder: (context, _) {
            return MaterialApp.router(
              routerConfig: appRouter,
              debugShowCheckedModeBanner: false,
              title: appName,
              theme: AppThemes.light,
              darkTheme: AppThemes.dark,
              themeMode: context.watch<ThemeModeProvider>().value,
            );
          },
        );
      },
    );
  }
}
