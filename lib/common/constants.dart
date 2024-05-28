import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart' as intl;

const kAppName = 'Dicoding Story';

/// Use this instead [print] or [debugPrint] for debugging.
final kLogger = Logger();

/// Commonly used date format for interface.
final kDateFormat = intl.DateFormat.yMMMMd();

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

/// Return `true` if current platform is native mobile.
/// 
/// If you allow web-mobile, use [kIsMobile] instead.
bool get kIsNativeMobile => kIsMobile && !kIsWeb;