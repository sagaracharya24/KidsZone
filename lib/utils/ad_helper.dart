import 'dart:io';

import 'package:flutter/foundation.dart';


class AdHelper {
  static String get bannerAdUnitId {
    if (!kReleaseMode) {
      debugPrint("Debug Mode on");
      if (Platform.isAndroid) {
        return "ca-app-pub-3940256099942544/6300978111";
      } else if (Platform.isIOS) {
        return "ca-app-pub-3940256099942544/2934735716";
      } else {
        throw UnsupportedError("Unsupported platform");
      }
    } else {
      debugPrint("Release Mode");
      if (Platform.isIOS) {
        return "ca-app-pub-8414829062139730/2607674784";
      } else {
        throw UnsupportedError("Unsupported platform");
      }
    }
  }

  static String get interstitialAdUnitId {
    if (!kReleaseMode) {
      debugPrint("Debug Mode");
      if (Platform.isAndroid) {
        return "ca-app-pub-3940256099942544/8691691433";
      } else if (Platform.isIOS) {
        return "ca-app-pub-3940256099942544/5135589807";
      } else {
        throw UnsupportedError("Unsupported platform");
      }
    } else {
      debugPrint("Release Mode");
      if (Platform.isIOS) {
        return "ca-app-pub-8414829062139730/5878751672";
      } else {
        throw UnsupportedError("Unsupported platform");
      }
    }
  }
}
