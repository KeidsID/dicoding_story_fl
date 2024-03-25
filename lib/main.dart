import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'container.dart' as container;
import 'interfaces/ui.dart';
import 'interfaces/ux.dart';

void main() async {
  await container.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: container.get()),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: AppThemes.light,
        darkTheme: AppThemes.dark,
      ),
    );
  }
}
