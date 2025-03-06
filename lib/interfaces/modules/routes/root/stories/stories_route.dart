// ignore_for_file: unnecessary_import

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/interfaces/libs/constants.dart";
import "package:dicoding_story_fl/interfaces/libs/providers.dart";
import "package:dicoding_story_fl/interfaces/libs/widgets.dart";
import "package:dicoding_story_fl/interfaces/modules/routes.dart";
import "package:dicoding_story_fl/libs/constants.dart";

import "routes/post_story_route.dart";
import "routes/story_detail_route.dart";

export "routes/post_story_route.dart";
export "routes/story_detail_route.dart";

/// [StoriesRoute] build decorator.
const storiesRouteBuild = TypedGoRoute<StoriesRoute>(
  path: "${AppRoutePaths.stories}${StoriesRoutePaths.root}",
  routes: [postStoryRouteBuild, storyDetailRouteBuild],
);

final class StoriesRoute extends GoRouteData {
  const StoriesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _StoriesRouteScreen();
  }
}

class _StoriesRouteScreen extends ConsumerStatefulWidget {
  const _StoriesRouteScreen();

  @override
  ConsumerState<_StoriesRouteScreen> createState() =>
      _StoriesRouteScreenState();
}

class _StoriesRouteScreenState extends ConsumerState<_StoriesRouteScreen> {
  late final ScrollController _scrollController;

  Stories get storiesProviderNotifier => ref.read(storiesProvider.notifier);

  Future<void> _handleFetchStories() async {
    try {
      await storiesProviderNotifier.fetchStories();
    } catch (err, trace) {
      kLogger.e("Stories fetch fail", error: err, stackTrace: trace);
    }
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final scrollPosition = _scrollController.position.pixels;
      final maxScrollPosition = _scrollController.position.maxScrollExtent;

      if (scrollPosition >= maxScrollPosition - 600.0) {
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

  @override
  Widget build(BuildContext context) {
    final storiesAsync = ref.watch(storiesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(kAppName)),
      body: _buildBody(storiesAsync),
    );
  }

  Widget _buildBody(AsyncValue<StoriesProviderValue> storiesAsync) {
    if (storiesAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<Story> stories = storiesAsync.valueOrNull?.stories ?? [];
    final hasError = storiesAsync.hasError;

    final refreshButton = ElevatedButton.icon(
      onPressed: () => ref.invalidate(storiesProvider),
      icon: const Icon(Icons.refresh_outlined),
      label: const Text("Refresh"),
    );

    if (stories.isEmpty && hasError) {
      return SizedErrorWidget.expand(
        error: storiesAsync.error,
        trace: storiesAsync.stackTrace,
        action: refreshButton,
      );
    }

    final isLatestPage = storiesAsync.value!.isLatestPage;

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
            child: isLatestPage
                ? refreshButton
                : const CircularProgressIndicator(),
          );
        }

        final story = stories[index];

        return StoryCard(
          story,
          onTap: () => StoryDetailRoute(story.id).go(context),
        );
      },
    );
  }
}
