import "package:flutter/services.dart";

/// Extensions on [AssetBundle] from [rootBundle].
extension AssetBundleX on AssetBundle {
  /// [Rubik](https://fonts.google.com/specimen/Rubik) font license as [String].
  Future<String> rubikFontLicense() => loadString("assets/fonts/Rubik/OFL.txt");
}
