import "package:flutter/material.dart";

extension ImageX on Image {
  /// Convert into [Ink] to make it paintable by [InkWell].
  ///
  /// So please note that [frameBuilder] child will be an [Ink.image] widget
  /// and may cause different behavior from original [Image.frameBuilder].
  Widget toInk({
    EdgeInsetsGeometry? padding,
    ImageErrorListener? onImageError,
    ColorFilter? colorFilter,
  }) {
    final inkImage = Ink.image(
      padding: padding,
      image: image,
      onImageError: onImageError,
      colorFilter: colorFilter,
      fit: fit,
      alignment: alignment,
      centerSlice: centerSlice,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
    );

    return Image(
      key: key,
      image: image,
      frameBuilder: (context, _, frame, wasSyncLoaded) {
        if (frameBuilder == null) return inkImage;

        return frameBuilder!(context, inkImage, frame, wasSyncLoaded);
      },
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      filterQuality: filterQuality,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      isAntiAlias: isAntiAlias,
    );
  }
}
