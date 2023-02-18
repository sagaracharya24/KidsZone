// Dart imports:
import 'dart:async';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

/* global class for handle all the preference activity into application */

class Preference {
  static const String language = "LANGUAGE";
  static const String isMusic = "SOUND";
  static const String hintAnimal = "HINT_ANIMAL";
  static const String hintFruits = "HINT_FRUITS";
  static const String hintBirds = "HINT_BIRDS";
  static const String hintShapes = "HINT_SHAPES";
  static const String hintEducation = "HINT_EDUCATION";
  static const String hintVehicles = "HINT_VEHICLES";
  static const String trackStatus = "TRACK_STATUS";
  static const String interstitialCount = "INTERSTITIAL_COUNT";

  // ------------------ SINGLETON -----------------------
  static final Preference _preference = Preference._internal();

  factory Preference() {
    return _preference;
  }

  Preference._internal();

  static Preference get shared => _preference;

  static SharedPreferences? _pref;

  /* make connection with preference only once in application */
  Future<SharedPreferences?> instance() async {
    if (_pref != null) return _pref;
    await SharedPreferences.getInstance().then((onValue) {
      _pref = onValue;
    }).catchError((onError) {
      _pref = null;
    });

    return _pref;
  }

  // String get & set
  String? getString(String key) {
    return _pref?.getString(key);
  }

  Future<bool>? setString(String key, String value) {
    return _pref?.setString(key, value);
  }

  // Int get & set
  int? getInt(String key) {
    return _pref?.getInt(key);
  }

  Future<bool>? setInt(String key, int value) {
    return _pref?.setInt(key, value);
  }

  // Bool get & set
  bool? getBool(String key) {
    return _pref?.getBool(key);
  }

  Future<bool>? setBool(String key, bool value) {
    return _pref?.setBool(key, value);
  }

  // Double get & set
  double? getDouble(String key) {
    return _pref!.getDouble(key);
  }

  Future<bool>? setDouble(String key, double value) {
    return _pref?.setDouble(key, value);
  }
}
