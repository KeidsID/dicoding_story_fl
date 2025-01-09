import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:dicoding_story_fl/interfaces/ui.dart";
import "package:dicoding_story_fl/interfaces/ux.dart";
import "package:dicoding_story_fl/libs/constants.dart";

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  final _controller = ScrollController();

  Future<void> _fetchStories() async {
    try {
      await context.read<StoriesProvider>().fetchStories();
    } catch (err, trace) {
      kLogger.e("Stories fetch fail", error: err, stackTrace: trace);
    }
  }

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      if (_controller.position.pixels >= _controller.position.maxScrollExtent) {
        Future.microtask(_fetchStories);
      }
    });

    Future.microtask(_fetchStories);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(kAppName)),
      body: Builder(builder: (context) {
        final storiesProv = context.watch<StoriesProvider>();

        final stories = storiesProv.value!;

        if (stories.isEmpty) {
          if (storiesProv.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (storiesProv.isError) {
            return SizedErrorWidget.expand(
              error: storiesProv.error,
              trace: storiesProv.trace,
              action: ElevatedButton.icon(
                onPressed: () => _fetchStories(),
                icon: const Icon(Icons.refresh_outlined),
                label: const Text("Refresh"),
              ),
            );
          }
        }

        final isLatestPage = storiesProv.isLatestPage;

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400.0,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          controller: _controller,
          padding: const EdgeInsets.all(16.0),
          itemCount: stories.length + 1,
          itemBuilder: (context, index) {
            if (index == stories.length) {
              return Center(
                child: !isLatestPage
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        onPressed: () => storiesProv.refresh(),
                        icon: const Icon(Icons.refresh),
                        label: const Text("Refresh"),
                      ),
              );
            }

            final story = stories[index];

            return StoryCard(
              story,
              onTap: () => StoryDetailRoute(story.id).go(context),
            );
          },
        );
      }),
    );
  }
}
