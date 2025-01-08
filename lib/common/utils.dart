import "package:dicoding_story_fl/core/entities.dart";
import "package:flutter/material.dart";

/// Extension on nullable [Object].
extension NullableObjectX on Object? {
  /// Utility to convert [Object] to [SimpleException].
  SimpleException toSimpleException({
    String? message,
    StackTrace? trace,
  }) {
    if (this is SimpleException) return this as SimpleException;

    return SimpleException(
      error: this,
      message: message ?? "Sorry for the inconvenience",
      trace: trace,
    );
  }

  /// Return `null` instead `"null"` string on `null` value.
  ///
  /// Otherwise, return the original [toString] result.
  String? toNullableString() => this == null ? null : "$this";
}

/// Extension on [Image].
extension ImageX on Image {
  /// Convert [Image] into [Ink] to make it paintable by [InkWell].
  Ink toInk() {
    return Ink.image(
      image: image,
      fit: fit,
      alignment: alignment,
      centerSlice: centerSlice,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
    );
  }
}
