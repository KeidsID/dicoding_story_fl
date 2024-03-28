import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CommonNetworkImage extends CachedNetworkImage {
  CommonNetworkImage({
    super.key,
    required super.imageUrl,
    super.httpHeaders,
    ImageWidgetBuilder? imageBuilder,
    PlaceholderWidgetBuilder? loadingBuilder,
    super.progressIndicatorBuilder,
    LoadingErrorWidgetBuilder? errorBuilder,
    super.fadeOutDuration,
    super.fadeOutCurve,
    super.fadeInDuration,
    super.fadeInCurve,
    super.width,
    super.height,
    super.fit,
    super.alignment,
    super.repeat,
    super.matchTextDirection,
    super.cacheManager,
    super.useOldImageOnUrlChange,
    super.color,
    super.filterQuality,
    super.colorBlendMode,
    super.placeholderFadeInDuration,
    super.memCacheWidth,
    super.memCacheHeight,
    super.cacheKey,
    super.maxWidthDiskCache,
    super.maxHeightDiskCache,
    super.errorListener,
    super.imageRenderMethodForWeb,
  }) : super(
          imageBuilder: imageBuilder ??
              (_, image) => Ink.image(
                    image: image,
                    width: width,
                    height: height,
                    fit: fit,
                    alignment: alignment,
                  ),
          placeholder: loadingBuilder ??
              (_, __) =>
                  const Center(child: CircularProgressIndicator.adaptive()),
          errorWidget: errorBuilder ??
              (_, __, ___) =>
                  const Center(child: Icon(Icons.image_not_supported_outlined)),
        );
}
