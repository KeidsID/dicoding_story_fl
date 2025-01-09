import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/interfaces/app_l10n.dart";
import "package:dicoding_story_fl/interfaces/libs/constants.dart";
import "package:dicoding_story_fl/interfaces/ui.dart";
import "package:dicoding_story_fl/interfaces/ux.dart";

class StoryDetailScreen extends StatelessWidget {
  const StoryDetailScreen(this.storyId, {super.key});

  final String storyId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: StoryDetailProvider(storyId),
      builder: (context, _) {
        final storyDetailProv = context.watch<StoryDetailProvider>();

        const loadingWidget = Center(child: CircularProgressIndicator());

        if (storyDetailProv.isLoading) return loadingWidget;

        if (storyDetailProv.isError) {
          return SizedErrorWidget.expand(
            error: storyDetailProv.error,
            trace: storyDetailProv.trace,
            action: ElevatedButton.icon(
              onPressed: () => storyDetailProv.refresh(),
              icon: const Icon(Icons.refresh_outlined),
              label: const Text("Refresh"),
            ),
          );
        }

        final story = storyDetailProv.value;

        if (story == null) return loadingWidget;

        return LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < 720) {
            return _StoryDetailScreenS(story);
          }

          return _StoryDetailScreenL(story);
        });
      },
    );
  }
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
              Image(image: image, fit: BoxFit.contain),
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

class _StoryDetailScreenS extends StatelessWidget {
  const _StoryDetailScreenS(this.story);

  final Story story;

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
              child: CommonNetworkImage(
                imageUrl: story.photoUrl,
                imageBuilder: (context, image) {
                  return InkWell(
                    onTap: () => _showImageDialog(context, image),
                    child: Ink.image(image: image, fit: BoxFit.cover),
                  );
                },
              ),
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

class _StoryDetailScreenL extends StatelessWidget {
  const _StoryDetailScreenL(this.story);

  final Story story;

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
              flex: 8,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CommonNetworkImage(
                    imageUrl: story.photoUrl,
                    imageBuilder: (context, image) {
                      return InkWell(
                        onTap: () => _showImageDialog(context, image),
                        child: Ink.image(image: image, fit: BoxFit.cover),
                      );
                    },
                  ),

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
              flex: 10,
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
