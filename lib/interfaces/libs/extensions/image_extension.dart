import "package:flutter/material.dart";

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
