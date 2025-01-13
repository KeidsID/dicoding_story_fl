import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/interfaces/libs/constants.dart";
import "package:dicoding_story_fl/interfaces/libs/widgets.dart";

class StoryCard extends StatelessWidget {
  const StoryCard(this.story, {super.key, this.onTap});

  final Story story;

  /// Called when the user taps this card.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    final child = ScrollConfiguration(
      behavior: context.scrollBehavior.copyWith(
        dragDevices: {}, // Disable drag. Only accept mouse scroll
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 3 / 2,
              child: CommonNetworkImage(
                imageUrl: story.photoUrl,
                imageBuilder: (_, image) => Ink.image(
                  image: image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Flexible(child: Divider(height: 2.0, thickness: 2.0)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: [
                      Text("${story.owner} ", style: textTheme.titleLarge),
                      Text(kDateFormat.format(story.createdAt))
                          .applyOpacity(opacity: 0.5),
                    ],
                  ),
                  const SizedBox(height: 8.0),

                  //
                  Text(
                    story.description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(onTap: onTap, child: child),
    );
  }
}
