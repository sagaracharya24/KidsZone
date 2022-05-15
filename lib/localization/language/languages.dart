import 'package:flutter/material.dart';

abstract class Languages {
  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get txtSettings;

  String get txtMusic;

  String get txtRate;

  String get txtShare;

  String get txtSendFeedback;

  String get txtPrivacyPolicy;

  String get txtKidsZoneFeedbackAndroid;

  String get txtKidsZoneFeedbackIOS;

  String get txtKidsZone;

  String get txtShareDesc;

  String get txtOK;

  String get txtCancel;

  String get txtYes;

  String get txtNo;

  String get txtAreYouSureYouWantToExit;

  String get txtForGrownUps;

  String get txtToAccessEnterNumbers;

  String get txtAwesome;

  String get txtHowManyObjects;

  String get txtCountTheObjects;

  String get txtWellDone;

  String get txtDollar;

  String get txtOne;
}
