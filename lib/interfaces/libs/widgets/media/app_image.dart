import "package:flutter/material.dart";

/// [Image] with built-in placeholders on [frameBuilder] and [errorBuilder]
/// that render [Icons.image_not_supported_outlined] icons.
class AppImage extends Image {
  AppImage({
    super.key,
    required super.image,
    ImageFrameBuilder? frameBuilder,
    super.loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    super.semanticLabel,
    super.excludeFromSemantics,
    super.width,
    super.height,
    super.color,
    super.opacity,
    super.colorBlendMode,
    super.fit,
    super.alignment,
    super.repeat,
    super.centerSlice,
    super.matchTextDirection,
    super.gaplessPlayback,
    super.isAntiAlias,
    super.filterQuality,
  }) : super(
          frameBuilder: frameBuilder ?? _appImageDefaultFrameBuilder,
          errorBuilder: errorBuilder ?? _appImageDefaultErrorBuilder,
        );

  AppImage.network(
    super.src, {
    super.key,
    super.scale,
    ImageFrameBuilder? frameBuilder,
    super.loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    super.semanticLabel,
    super.excludeFromSemantics,
    super.width,
    super.height,
    super.color,
    super.opacity,
    super.colorBlendMode,
    super.fit,
    super.alignment,
    super.repeat,
    super.centerSlice,
    super.matchTextDirection,
    super.gaplessPlayback,
    super.filterQuality,
    super.isAntiAlias,
    super.headers,
    super.cacheWidth,
    super.cacheHeight,
  }) : super.network(
          frameBuilder: frameBuilder ?? _appImageDefaultFrameBuilder,
          errorBuilder: errorBuilder ?? _appImageDefaultErrorBuilder,
        );

  AppImage.file(
    super.file, {
    super.key,
    super.scale,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    super.semanticLabel,
    super.excludeFromSemantics,
    super.width,
    super.height,
    super.color,
    super.opacity,
    super.colorBlendMode,
    super.fit,
    super.alignment,
    super.repeat,
    super.centerSlice,
    super.matchTextDirection,
    super.gaplessPlayback,
    super.isAntiAlias,
    super.filterQuality,
    super.cacheWidth,
    super.cacheHeight,
  }) : super.file(
          frameBuilder: frameBuilder ?? _appImageDefaultFrameBuilder,
          errorBuilder: errorBuilder ?? _appImageDefaultErrorBuilder,
        );

  AppImage.asset(
    super.name, {
    super.key,
    super.bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    super.semanticLabel,
    super.excludeFromSemantics,
    super.scale,
    super.width,
    super.height,
    super.color,
    super.opacity,
    super.colorBlendMode,
    super.fit,
    super.alignment,
    super.repeat,
    super.centerSlice,
    super.matchTextDirection,
    super.gaplessPlayback,
    super.isAntiAlias,
  }) : super.asset(
          frameBuilder: frameBuilder ?? _appImageDefaultFrameBuilder,
          errorBuilder: errorBuilder ?? _appImageDefaultErrorBuilder,
        );

  AppImage.memory(
    super.bytes, {
    super.key,
    super.scale,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    super.semanticLabel,
    super.excludeFromSemantics,
    super.width,
    super.height,
    super.color,
    super.opacity,
    super.colorBlendMode,
    super.fit,
    super.alignment,
    super.repeat,
    super.centerSlice,
    super.matchTextDirection,
    super.gaplessPlayback,
    super.isAntiAlias,
    super.filterQuality,
    super.cacheWidth,
    super.cacheHeight,
  }) : super.memory(
          frameBuilder: frameBuilder ?? _appImageDefaultFrameBuilder,
          errorBuilder: errorBuilder ?? _appImageDefaultErrorBuilder,
        );
}

/// [AppImage.frameBuilder] default implementation.
ImageFrameBuilder get _appImageDefaultFrameBuilder {
  const fadeDuration = Durations.medium1;
  const fadeCurve = Curves.easeInOutSine;

  return (context, child, frame, wasSyncLoaded) {
    if (wasSyncLoaded) return child;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        AnimatedOpacity(
          opacity: frame == null ? 1 : 0,
          duration: fadeDuration,
          curve: fadeCurve,
          child: const Center(child: CircularProgressIndicator.adaptive()),
        ),
        AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: fadeDuration,
          curve: fadeCurve,
          child: child,
        )
      ],
    );
  };
}

/// [AppImage.errorBuilder] default implementation.
ImageErrorWidgetBuilder get _appImageDefaultErrorBuilder {
  return (context, _, __) {
    return const Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 40.0,
      ),
    );
  };
}
