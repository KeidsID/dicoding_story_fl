import 'package:dicoding_story_fl/interfaces/ui.dart';
import 'package:fl_utilities/fl_utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dicoding_story_fl/common/constants.dart';
import 'package:dicoding_story_fl/interfaces/ux.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      try {
        final userCreds = context.read<AuthProvider>().userCreds;

        if (userCreds == null) return;

        await context.read<StoriesProvider>().fetchStories(userCreds);
      } catch (err, trace) {
        kLogger.w('Stories Initial Fetch Fail', error: err, stackTrace: trace);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userCreds = context.watch<AuthProvider>().userCreds;

    return Scaffold(
      appBar: AppBar(title: const Text(appName)),
      body: Consumer<StoriesProvider>(builder: (_, storiesProv, __) {
        if (storiesProv.isLoading || storiesProv.value.isEmpty) {
          if (storiesProv.error != null) {
            return SizedErrorWidget.expand(
              error: storiesProv.error,
              trace: storiesProv.trace,
              action: ElevatedButton.icon(
                onPressed: userCreds == null
                    ? null
                    : () async {
                        try {
                          await storiesProv.fetchStories(userCreds);
                        } catch (err, trace) {
                          kLogger.w(
                            'Stories Refresh Fail',
                            error: err,
                            stackTrace: trace,
                          );
                        }
                      },
                icon: const Icon(Icons.refresh_outlined),
                label: const Text('Refresh'),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        }

        final stories = storiesProv.value;

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400.0,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          itemBuilder: (context, index) {
            final story = stories[index];

            return StoryCard(
              story,
              childBuilder: (_, child) => InkWell(
                onTap: () {},
                child: child,
              ),
            );
          },
          itemCount: stories.length,
          padding: const EdgeInsets.all(16.0),
        );
      }),
    );
  }
}
