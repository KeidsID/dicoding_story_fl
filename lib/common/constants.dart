import 'package:logger/logger.dart';
import 'package:intl/intl.dart' as intl;

const appName = 'Dicoding Story';
const appLegalese = 'MIT License\n\n'
    'Copyright (c) 2024 Kemal Idris [KeidsID]';

/// Use this instead [print] or [debugPrint] for debugging.
final kLogger = Logger();

/// Commonly used date format for interface.
final kDateFormat = intl.DateFormat.yMMMMd();
