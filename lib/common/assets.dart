import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Extensions on [AssetBundle] from [rootBundle].
extension AssetBundleX on AssetBundle {
  /// [Rubik](https://fonts.google.com/specimen/Rubik) font license as [String].
  Future<String> rubikFontLicense() => loadString('assets/fonts/Rubik/OFL.txt');
}

/// Contains [AssetImage] from `assets/images/res/` as static properties.
extension AssetImages on AssetImage {
  static const _basePath = 'assets/images/res';

  /// App icon.
  /// 
  /// ![image](https://raw.githubusercontent.com/KeidsID/dicoding_story_fl/main/assets/images/res/4.0x/app_icon.png)
  static const appIcon = AssetImage('$_basePath/app_icon.png');

  /// 512px App icon (Google Play).
  /// 
  /// ![image](https://raw.githubusercontent.com/KeidsID/dicoding_story_fl/main/assets/images/res/app_icon_L.png)
  static const appIconL = AssetImage('$_basePath/app_icon_L.png');
}
