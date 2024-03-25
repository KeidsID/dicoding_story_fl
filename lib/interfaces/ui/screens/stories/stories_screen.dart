import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dicoding_story_fl/interfaces/ux.dart';

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProv, _) {
      final userCreds = authProv.userCreds;

      return Scaffold(
        body: Center(
          child: Column(
            children: [
              Text(userCreds?.name ?? 'Fulan'),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: authProv.isLoading ? null : () => authProv.logout(),
                child: const Text('Log Out'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
