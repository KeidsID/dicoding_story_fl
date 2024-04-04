import 'package:dicoding_story_fl/common/constants.dart';
import 'package:fl_utilities/fl_utilities.dart';
import 'package:flutter/material.dart';

import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/interfaces/ui.dart';

class StoryCard extends StatelessWidget {
  const StoryCard(this.story, {super.key, this.childBuilder});

  final Story story;

  /// In case you want wrap the card child with other widget. Such as [InkWell]
  /// to create a tap action on card.
  final Widget Function(BuildContext context, Widget child)? childBuilder;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    final child = SingleChildScrollView(
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
                    Text('${story.owner} ', style: textTheme.titleLarge),
                    Text(kDateFormat.format(story.createdAt))
                        .applyOpacity(opacity: 0.5),
                  ],
                ),
                const SizedBox(height: 8.0),

                //
                Text(
                  story.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );

    return Card(
      clipBehavior: Clip.hardEdge,
      child: childBuilder?.call(context, child) ?? child,
    );
  }
}
