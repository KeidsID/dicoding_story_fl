import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dicoding_story_fl/common/constants.dart';
import 'package:dicoding_story_fl/interfaces/ui.dart';
import 'package:dicoding_story_fl/interfaces/ux.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key, this.page = 1, this.size = 10});

  final int? page;
  final int? size;

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  int? get page => widget.page;
  int? get size => widget.size;

  Future<void> _fetchStories({
    bool? hasCordinate,
  }) async {
    try {
      final userCreds = context.read<AuthProvider>().userCreds;

      if (userCreds == null) return;

      await context.read<StoriesProvider>().fetchStories(
            userCreds,
            page: page ?? 1,
            size: size ?? 10,
            hasCordinate: hasCordinate,
          );
    } catch (err, trace) {
      kLogger.w('Stories Fetch Fail', error: err, stackTrace: trace);
    }
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() => _fetchStories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(appName)),
      body: Builder(builder: (context) {
        final userCreds = context.watch<AuthProvider>().userCreds;
        final storiesProv = context.watch<StoriesProvider>();

        final stories = storiesProv.value;

        if (storiesProv.isLoading || stories.isEmpty) {
          if (storiesProv.error != null) {
            return SizedErrorWidget.expand(
              error: storiesProv.error,
              trace: storiesProv.trace,
              action: ElevatedButton.icon(
                onPressed: userCreds == null ? null : () => _fetchStories(),
                icon: const Icon(Icons.refresh_outlined),
                label: const Text('Refresh'),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        }

        final pageNavigator = Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: page == 1 || page == null
                    ? null
                    : () {
                        StoriesRoute(
                          page: '${(page ?? 1) - 1}',
                          size: size == null ? null : '$size',
                        ).go(context);
                        _fetchStories();
                      },
                icon: const Icon(Icons.chevron_left),
              ),
              Text('Page ${page ?? 1}'),
              IconButton(
                onPressed: () {
                  StoriesRoute(
                    page: '${(page ?? 1) + 1}',
                    size: size == null ? null : '$size',
                  ).go(context);
                  _fetchStories();
                },
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        );

        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 16.0)),
            SliverToBoxAdapter(child: pageNavigator),

            //
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 400.0,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
                itemBuilder: (_, index) => StoryCard(
                  stories[index],
                  childBuilder: (_, child) => InkWell(
                    onTap: () {},
                    child: child,
                  ),
                ),
                itemCount: stories.length,
              ),
            ),

            //
            SliverToBoxAdapter(child: pageNavigator),
            const SliverToBoxAdapter(child: SizedBox(height: 16.0)),
          ],
        );
      }),
    );
  }
}
