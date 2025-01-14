import "dart:io";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

/// [Image] widget for [XFile] from `image_picker` package.
class ImageFromXFile extends Image {
  ImageFromXFile(
    this.imageFile, {
    super.key,
    double scale = 1.0,
    super.frameBuilder,
    super.loadingBuilder,
    super.errorBuilder,
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
  }) : super(image: _getImage(imageFile, scale));

  final XFile imageFile;

  static ImageProvider _getImage(XFile imageFile, double scale) {
    if (kIsWeb) return NetworkImage(imageFile.path, scale: scale);

    return FileImage(File(imageFile.path), scale: scale);
  }
}
