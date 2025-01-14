// ignore_for_file: unnecessary_import

import "package:dicoding_story_fl/interfaces/modules/routes.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/interfaces/libs/constants.dart";
import "package:dicoding_story_fl/interfaces/libs/providers.dart";
import "package:dicoding_story_fl/interfaces/libs/widgets.dart";
import "package:dicoding_story_fl/libs/constants.dart";

import "routes/post_story_route.dart";
import "routes/story_detail_route.dart";

export "routes/post_story_route.dart";
export "routes/story_detail_route.dart";

/// [StoriesRoute] build decorator.
const storiesRouteBuild = TypedGoRoute<StoriesRoute>(
  path: "${AppRoutePaths.stories}${AppRouteStoriesPaths.root}",
  routes: [postStoryRouteBuild, storyDetailRouteBuild],
);

final class StoriesRoute extends GoRouteData {
  const StoriesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _StoriesRouteScreen();
  }
}

class _StoriesRouteScreen extends StatefulWidget {
  const _StoriesRouteScreen();

  @override
  State<_StoriesRouteScreen> createState() => _StoriesRouteScreenState();
}

class _StoriesRouteScreenState extends State<_StoriesRouteScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final scrollPosition = _scrollController.position.pixels;
      final maxScrollPosition = _scrollController.position.maxScrollExtent;

      if (scrollPosition >= maxScrollPosition) {
        Future.microtask(_handleFetchStories);
      }
    });

    Future.microtask(_handleFetchStories);
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  Future<void> _handleFetchStories() async {
    try {
      await context.read<StoriesProvider>().fetchStories();
    } catch (err, trace) {
      kLogger.e("Stories fetch fail", error: err, stackTrace: trace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(kAppName)),
      body: Builder(builder: (context) {
        final storiesProvider = context.watch<StoriesProvider>();
        final stories = storiesProvider.value ?? <Story>[];

        if (stories.isEmpty) {
          if (storiesProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (storiesProvider.isError) {
            return SizedErrorWidget.expand(
              error: storiesProvider.error,
              trace: storiesProvider.trace,
              action: ElevatedButton.icon(
                onPressed: () => _handleFetchStories(),
                icon: const Icon(Icons.refresh_outlined),
                label: const Text("Refresh"),
              ),
            );
          }
        }

        final isLatestPage = storiesProvider.isLatestPage;

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400.0,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          controller: _scrollController,
          padding: const EdgeInsets.all(16.0),
          itemCount: stories.length + 1,
          itemBuilder: (context, index) {
            if (index == stories.length) {
              return Center(
                child: !isLatestPage
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        onPressed: () => storiesProvider.refresh(),
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
