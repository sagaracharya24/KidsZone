import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kids_preschool/common/commonTopBar/common_topbar.dart';
import 'package:kids_preschool/interfaces/topbar_clicklistener.dart';
import 'package:kids_preschool/localization/language/languages.dart';
import 'package:kids_preschool/utils/ad_helper.dart';
import 'package:kids_preschool/utils/color.dart';
import 'package:kids_preschool/utils/constant.dart';
import 'package:kids_preschool/utils/debug.dart';
import 'package:kids_preschool/utils/preference.dart';
import 'package:kids_preschool/utils/utils.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    implements TopBarClickListener {

  RateMyApp? rateMyApp;

  bool? isSound;

  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;

  @override
  void initState() {
    _createBottomBannerAd();
    rateMyApp = RateMyApp(
        preferencesPrefix: 'rateMyApp_',
        minDays: 7,
        minLaunches: 10,
        remindDays: 7,
        remindLaunches: 10,
        googlePlayIdentifier: Constant.googlePlayIdentifier,
        appStoreIdentifier: Constant.appStoreIdentifier
    );

    if (Platform.isIOS) {
      rateMyApp!.init().then((_) {
        if (rateMyApp!.shouldOpenDialog) {
          rateMyApp!.showRateDialog(
            context,
            title: 'Rate this app',
            message:
            'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.',
            rateButton: 'RATE',
            noButton: 'NO THANKS',
            laterButton: 'MAYBE LATER',
            listener: (button) {
              switch (button) {
                case RateMyAppDialogButton.rate:
                  break;
                case RateMyAppDialogButton.later:
                  break;
                case RateMyAppDialogButton.no:
                  break;
              }

              return true;
            },
            ignoreNativeDialog: Platform.isAndroid,
            dialogStyle: const DialogStyle(),
            onDismissed: () =>
                rateMyApp!.callEvent(RateMyAppEventType.laterButtonPressed),
          );

          rateMyApp!.showStarRateDialog(
            context,
            title: 'Rate this app',
            message:
            'You like this app ? Then take a little bit of your time to leave a rating :',
            actionsBuilder: (context, stars) {
              return [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () async {
                    await rateMyApp!
                        .callEvent(RateMyAppEventType.rateButtonPressed);
                    Navigator.pop<RateMyAppDialogButton>(
                        context, RateMyAppDialogButton.rate);
                  },
                ),
              ];
            },
            ignoreNativeDialog: Platform.isAndroid,
            dialogStyle: const DialogStyle(
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 20),
            ),
            starRatingOptions: const StarRatingOptions(),
            onDismissed: () =>
                rateMyApp!.callEvent(RateMyAppEventType.laterButtonPressed),
          );
        }
      });
    }

    _getPreference();

    super.initState();
  }

  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(
        nonPersonalizedAds: Utils.nonPersonalizedAds(),
      ),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
      _bottomBannerAd.load();

  }

  _getPreference() {
    isSound = Preference.shared.getBool(Preference.isMusic) ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colur.lightBG,
        body: SafeArea(
          top: false,
          bottom: Platform.isAndroid ? true : false,
          child: Column(
            children: [
              CommonTopBar(
                Languages.of(context)!.txtSettings,
                this,
                isShowBack: true,
                totalCount: " ",
                align: TextAlign.left,
              ),
              _settingsWidget()
            ],
          ),
        ),
      ),
    );
  }

  _settingsWidget() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/background/bg_background.webp"),
              fit: BoxFit.fill),
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _setting(name: Languages.of(context)!.txtMusic, image:  isSound! ? "assets/icons/ic_setting_sound_on.webp" : "assets/icons/ic_setting_sound_off.webp"),
                  _setting(name: Languages.of(context)!.txtRate, image:  "assets/icons/ic_setting_rate.webp"),
                  _setting(name: Languages.of(context)!.txtShare, image:  "assets/icons/ic_setting_share.webp"),
                  _setting(name: Languages.of(context)!.txtSendFeedback, image:  "assets/icons/ic_setting_feedback.webp"),
                  _setting(name: Languages.of(context)!.txtPrivacyPolicy, image:  "assets/icons/ic_setting_privacy_policy.webp"),

                ],
              ),
            ),

            (_isBottomBannerAdLoaded)
                ? SizedBox(
              height: _bottomBannerAd.size.height.toDouble(),
              width: _bottomBannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bottomBannerAd),
            )
                : SizedBox(
              height: _bottomBannerAd.size.height.toDouble(),
              width: _bottomBannerAd.size.width.toDouble(),
            )
          ],
        ),
      ),
    );
  }


  _setting({String? name, String? image}) {
    return InkWell(
      onTap: () {
        if(name == Languages.of(context)!.txtMusic) {
          _sound();
        } else if(name == Languages.of(context)!.txtRate) {
          _rate();
        } else if(name == Languages.of(context)!.txtShare) {
          _share();
        } else if(name == Languages.of(context)!.txtSendFeedback) {
          _sendFeedback();
        } else if(name == Languages.of(context)!.txtPrivacyPolicy) {
          launch(Constant.privacyPolicyURL);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: const BoxDecoration(
          color: Colur.theme,
          borderRadius: BorderRadius.only(topRight: Radius.circular(40), bottomLeft: Radius.circular(40))
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              image!,
              height: 35,
              width: 35,
            ),
            Container(
              margin: const EdgeInsets.only(left: 15),
              child: Text(
                name!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Colur.yellow
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }

  _sound() {
    if(isSound!){
      Preference.shared.setBool(Preference.isMusic, false);
      setState(() {
        _getPreference();
        Utils.audioPlayer.stop();
      });
    } else {
      Preference.shared.setBool(Preference.isMusic, true);
      setState(() {
        _getPreference();
        Utils.playAudio();
      });
    }
  }

  _rate() {
    if (Platform.isIOS) {
      rateMyApp!.showRateDialog(context);
    } else {
      rateMyApp!.launchStore();
    }
  }

  Future<void> _share() async {
    await Share.share(
      Languages.of(context)!.txtShareDesc + Constant.shareLink,
      subject: Languages.of(context)!.txtKidsZone,
    );
  }

  void _sendFeedback() {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: Constant.emailPath,
      query: encodeQueryParameters(<String, String>{
        'subject': Platform.isAndroid
            ? Languages.of(context)!.txtKidsZoneFeedbackAndroid
            : Languages.of(context)!.txtKidsZoneFeedbackIOS,
        'body': " "
      }),
    );
    launch(emailLaunchUri.toString());

    setState(() {});
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }


  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.strBack) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }
}
