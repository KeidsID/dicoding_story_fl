import "package:flutter/foundation.dart";

/// Return `true` if current platform is mobile.
///
/// Already web-aware.
bool get kIsMobile {
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
    case TargetPlatform.iOS:
      return true;
    default:
      return false;
  }
}
