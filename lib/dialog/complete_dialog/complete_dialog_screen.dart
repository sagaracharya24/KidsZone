import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kids_preschool/ui/category/category_screen.dart';
import 'package:kids_preschool/utils/color.dart';
import 'package:kids_preschool/utils/utils.dart';

import '../../utils/ad_helper.dart';
import '../../utils/debug.dart';

class CompleteDialog extends StatefulWidget {
  final Function restartFunction;
  final String image;

  const CompleteDialog(
      {Key? key,
      required this.restartFunction,
      this.image = "assets/icons/ic_restart.webp"})
      : super(key: key);

  @override
  _CompleteDialogState createState() => _CompleteDialogState();
}

class _CompleteDialogState extends State<CompleteDialog> {
  Function? restartFunction;

  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    restartFunction = widget.restartFunction;
    _createInterstitialAd();
    super.initState();
  }

  void _createInterstitialAd() {
      InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: AdRequest(
          nonPersonalizedAds: Utils.nonPersonalizedAds()
        ),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            _interstitialAd = null;
            _createInterstitialAd();
          },
        ),
      );

  }

  void _showInterstitialAd() {
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const CategoryScreen()),
            (route) => false);
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const CategoryScreen()),
            (route) => false);
      },
    );
    _interstitialAd!.show();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colur.transparent,
        body: Center(
          child: Wrap(
            children: [
              Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height * 0.05),
                  child: Image.asset("assets/images/ic_welldone.webp")),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.15,
                    vertical: MediaQuery.of(context).size.height * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        _showInterstitialAd();
                      },
                      child: Image.asset(
                        "assets/icons/ic_home.webp",
                        height: 55,
                        width: 55,
                      ),
                    ),
                    InkWell(
                      onTap: () => restartFunction!(),
                      child: Image.asset(
                        widget.image,
                        height: 55,
                        width: 55,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
