import 'package:dicoding_story_fl/core/entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
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

  // prevent "null" on url queries.
  String? get pageAsQuery => page == null ? null : '$page';
  String? get sizeAsQuery => size == null ? null : '$size';

  Future<void> _fetchStories({
    bool? hasCordinate,
  }) async {
    try {
      final userCreds = context.read<AuthProvider>().value;

      if (userCreds == null) return;

      await context.read<StoriesProvider>().fetchStories(
            userCreds,
            page: page ?? 1,
            size: size ?? 10,
            hasCordinate: hasCordinate,
          );
    } catch (err, trace) {
      kLogger.d('Stories Fetch Fail', error: err, stackTrace: trace);
    }
  }

  final _menuController = MenuController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() => _fetchStories());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future.microtask(() => _fetchStories());
  }

  @override
  Widget build(BuildContext context) {
    // Trigger [didChangeDependencies] on router queries changes.
    //
    // go_router did'nt rebuild widget on router query changes.
    GoRouterState.of(context);

    final pageNavigator = Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: page == 1 || page == null
                ? null
                : () => StoriesRoute(
                      page: '${(page ?? 1) - 1}',
                      size: sizeAsQuery,
                    ).go(context),
            icon: const Icon(Icons.chevron_left),
          ),
          Text('Page ${page ?? 1}'),
          IconButton(
            onPressed: () => StoriesRoute(
              page: '${(page ?? 1) + 1}',
              size: sizeAsQuery,
            ).go(context),
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
        actions: [
          MenuAnchor(
            controller: _menuController,
            menuChildren: [
              ListTile(title: pageNavigator),

              //
              ListTile(
                title: const Text('Story Count'),
                trailing: SizedBox(
                  width: 80.0,
                  child: TextField(
                    controller: TextEditingController(text: '${size ?? 10}'),
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.singleLineFormatter,
                    ],
                    onSubmitted: (String value) {
                      StoriesRoute(
                        page: pageAsQuery,
                        size: switch (value) {
                          '' => null,
                          '0' => null,

                          // Parsed to int to remove leading zero ("01" => "1").
                          _ => '${int.tryParse(value)}',
                        },
                      ).go(context);

                      _menuController.close();
                    },
                  ),
                ),
              ),
            ],
            builder: (context, menu, _) {
              return IconButton(
                onPressed: () => menu.isOpen ? menu.close() : menu.open(),
                icon: const Icon(Icons.filter_alt_outlined),
              );
            },
          ),
        ],
      ),
      body: Builder(builder: (context) {
        final userCreds = context.watch<AuthProvider>().value;
        final storiesProv = context.watch<StoriesProvider>();

        if (storiesProv.isLoading || !storiesProv.hasValue) {
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

        final stories = storiesProv.value!;

        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 16.0)),
            SliverToBoxAdapter(child: pageNavigator),

            //
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: stories.isEmpty
                  ? SliverToBoxAdapter(
                      child: SizedErrorWidget(
                        error: SimpleHttpException(
                          statusCode: 404,
                          message: 'No stories found',
                        ),
                      ),
                    )
                  : SliverGrid.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400.0,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                      ),
                      itemCount: stories.length,
                      itemBuilder: (context, index) {
                        final story = stories[index];

                        return StoryCard(
                          story,
                          childBuilder: (_, child) => InkWell(
                            onTap: () => StoryDetailRoute(story.id).go(context),
                            child: child,
                          ),
                        );
                      },
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
