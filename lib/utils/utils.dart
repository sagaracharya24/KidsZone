import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kids_preschool/utils/color.dart';
import 'package:kids_preschool/utils/constant.dart';
import 'package:kids_preschool/utils/preference.dart';

class Utils {
  static showToast(BuildContext context, String msg,
      {double duration = 2, ToastGravity? gravity}) {
    gravity ??= ToastGravity.BOTTOM;

    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        backgroundColor: Colur.grey,
        textColor: Colur.white,
        fontSize: 14.0);
  }

  static Future textToSpeech(String speakText, FlutterTts flutterTts) async {
    if (Platform.isAndroid) {
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.setLanguage("en-GB");
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
      await flutterTts.isLanguageAvailable("en-GB");
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(speakText);
    } else {
      await flutterTts.awaitSpeakCompletion(true);
      await flutterTts.setLanguage("en-AU");
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
      await flutterTts.isLanguageAvailable("en-AU");
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(speakText);
    }
  }

  static AudioPlayer audioPlayer = AudioPlayer();
  static AudioCache audioCache = AudioCache();
  static const audio = "sounds/background_music.mp3";

  static playAudio() async {
    audioPlayer.audioCache = AudioCache(prefix: audio);
  }

  static Map<String, Color> colorList = const {
    "orange": Color(0XFFED4A0D),
    "violet": Color(0XFF6E3DFA),
    "red": Color(0XFFE30A0A),
    "green": Color(0XFF24DA0F),
    "cyan": Color(0XFF00CFDB),
    "pink": Color(0XFFCC00C1),
    "blue": Color(0XFF4253FF),
    "yellow": Color(0XFFF6D913),
  };

  static nonPersonalizedAds() {
    if (Platform.isIOS) {
      if (Preference.shared.getString(Preference.trackStatus) !=
          Constant.trackingStatus) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
