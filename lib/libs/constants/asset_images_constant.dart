import "package:flutter/material.dart";

abstract final class AssetImages {
  static const _assetPath = "assets/images/res";

  /// App icon.
  ///
  /// ![image](https://raw.githubusercontent.com/KeidsID/dicoding_story_fl/main/assets/images/res/4.0x/app_icon.png)
  static const appIcon = AssetImage("$_assetPath/app_icon.png");

  /// 512px App icon (Google Play).
  ///
  /// ![image](https://raw.githubusercontent.com/KeidsID/dicoding_story_fl/main/assets/images/res/app_icon_L.png)
  static const appIconL = AssetImage("$_assetPath/app_icon_L.png");
}
