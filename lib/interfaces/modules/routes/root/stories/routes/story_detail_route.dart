import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/interfaces/libs/constants.dart";
import "package:dicoding_story_fl/interfaces/libs/extensions.dart";
import "package:dicoding_story_fl/interfaces/libs/l10n.dart";
import "package:dicoding_story_fl/interfaces/libs/providers.dart";
import "package:dicoding_story_fl/interfaces/libs/widgets.dart";

const storyDetailRouteBuild = TypedGoRoute<StoryDetailRoute>(
  path: StoriesRoutePaths.view$storyId,
);

final class StoryDetailRoute extends GoRouteData {
  const StoryDetailRoute(this.storyId);

  final String storyId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return _StoryDetailRouteScreen(storyId);
  }
}

class _StoryDetailRouteScreen extends ConsumerWidget {
  const _StoryDetailRouteScreen(this.storyId);

  final String storyId;

  double get _wideLayoutMinWidth => 800;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyDetailAsync = ref.watch(storyDetailProvider(storyId));

    return switch (storyDetailAsync) {
      AsyncData(:final value) => LayoutBuilder(builder: (context, constraints) {
          if (constraints.minWidth >= _wideLayoutMinWidth) {
            return _StoryDetailRouteScreenWide(value);
          }

          return _StoryDetailRouteScreenSmall(value);
        }),
      AsyncError(:final error, :final stackTrace) => SizedErrorWidget.expand(
          error: error,
          trace: stackTrace,
          action: ElevatedButton.icon(
            onPressed: () => ref.invalidate(storyDetailProvider(storyId)),
            icon: const Icon(Icons.refresh_outlined),
            label: const Text("Refresh"),
          ),
        ),
      _ => const Center(child: CircularProgressIndicator.adaptive()),
    };
  }
}

mixin _StoryDetailRouteScreenHelperMixin {
  String _getAddressFromStory(Story story) {
    final location = story.location;

    if (location == null) return "";

    return location.displayName ?? location.address ?? location.latLon;
  }

  /// Expands image on dialog to show image with [BoxFit.contain].
  void _showImageDialog(BuildContext context, ImageProvider<Object> image) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            clipBehavior: Clip.hardEdge,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AppImage(image: image, fit: BoxFit.contain),
                //
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton.filledTonal(
                      icon: const Icon(Icons.close),
                      tooltip:
                          MaterialLocalizations.of(context).closeButtonTooltip,
                      onPressed: () => Navigator.maybePop(context),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _showCustomMapsDialog(
    BuildContext context, [
    LocationData? initialLocation,
  ]) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog.fullscreen(
          child: CustomMapsView(
            initialLocation: initialLocation,
            readonly: true,
          ),
        );
      },
    );
  }
}

class _StoryDetailRouteScreenSmall extends StatelessWidget
    with _StoryDetailRouteScreenHelperMixin {
  const _StoryDetailRouteScreenSmall(this.story);

  final Story story;

  String get _address => _getAddressFromStory(story);

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppL10n.of(context)!.personStory(story.owner)),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 3 / 2,
              child: Builder(builder: (context) {
                final image = NetworkImage(story.photoUrl);

                return InkWell(
                  onTap: () => _showImageDialog(context, image),
                  child: AppImage(image: image, fit: BoxFit.cover).toInk(),
                );
              }),
            ),
            const Flexible(child: Divider(height: 2.0, thickness: 2.0)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: [
                      Text(
                        "${story.owner} ",
                        style: textTheme.headlineMedium,
                      ),
                      Text(kDateFormat.format(story.createdAt))
                          .applyOpacity(opacity: 0.5),
                    ],
                  ),
                  if (_address.isNotEmpty)
                    AddressSection(
                      _address,
                      onTap: () => _showCustomMapsDialog(
                        context,
                        story.location,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8.0),

                  //
                  Text(story.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryDetailRouteScreenWide extends StatelessWidget
    with _StoryDetailRouteScreenHelperMixin {
  const _StoryDetailRouteScreenWide(this.story);

  final Story story;

  String get _address => _getAddressFromStory(story);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 10,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Builder(builder: (context) {
                    final image = NetworkImage(story.photoUrl);

                    return InkWell(
                      onTap: () => _showImageDialog(context, image),
                      child: AppImage(image: image, fit: BoxFit.cover).toInk(),
                    );
                  }),

                  //
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton.filledTonal(
                        icon: const Icon(Icons.arrow_back),
                        tooltip:
                            MaterialLocalizations.of(context).backButtonTooltip,
                        onPressed: () => context.pop(),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const VerticalDivider(width: 2.0, thickness: 2.0),
            Flexible(
              flex: 8,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        Text(
                          "${story.owner} ",
                          style: textTheme.headlineMedium,
                        ),
                        Text(kDateFormat.format(story.createdAt))
                            .applyOpacity(opacity: 0.5),
                      ],
                    ),
                    if (_address.isNotEmpty)
                      AddressSection(
                        _address,
                        onTap: () => _showCustomMapsDialog(
                          context,
                          story.location,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8.0),

                    //
                    Text(story.description),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
