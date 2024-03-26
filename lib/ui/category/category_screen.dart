import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kids_preschool/common/commonTopBar/common_topbar.dart';
import 'package:kids_preschool/database/database_helper.dart';
import 'package:kids_preschool/database/tables/category_table.dart';
import 'package:kids_preschool/dialog/parent_dialog/parent_dialog_screen.dart';
import 'package:kids_preschool/interfaces/topbar_clicklistener.dart';
import 'package:kids_preschool/localization/language/languages.dart';
import 'package:kids_preschool/ui/addition_subtraction/add_subtract_screen.dart';
import 'package:kids_preschool/ui/alphabets/alphabets_screen.dart';
import 'package:kids_preschool/ui/compare/compare_screen.dart';
import 'package:kids_preschool/ui/counting/counting_screen.dart';
import 'package:kids_preschool/ui/missing_numbers/missing_numbers_screen.dart';
import 'package:kids_preschool/ui/months_days/months_days_screen.dart';
import 'package:kids_preschool/ui/numbers/numbers_screen.dart';
import 'package:kids_preschool/ui/quantity/quantity_screen.dart';
import 'package:kids_preschool/ui/quiz/quiz_screen.dart';
import 'package:kids_preschool/ui/spelling/spelling_screen.dart';
import 'package:kids_preschool/ui/time/time_screen.dart';
import 'package:kids_preschool/ui/upper_lower/upper_lower_screen.dart';
import 'package:kids_preschool/utils/ad_helper.dart';
import 'package:kids_preschool/utils/color.dart';
import 'package:kids_preschool/utils/constant.dart';
import 'package:kids_preschool/utils/debug.dart';
import 'package:kids_preschool/utils/preference.dart';
import 'package:kids_preschool/utils/utils.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    implements TopBarClickListener {
  List<CategoryTable>? categoryList = [];
  FlutterTts flutterTts = FlutterTts();

  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;

  int? _interstitialCount;
  InterstitialAd? _interstitialAd;

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  void initState() {
    //_createBottomBannerAd();
   // _createInterstitialAd();
    _getDataFromDatabase();
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

  void _createInterstitialAd() {

      InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: AdRequest(
            nonPersonalizedAds: Utils.nonPersonalizedAds()
        ),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            Preference.shared.setInt(
                Preference.interstitialCount, _interstitialCount! + 1);
          },
          onAdFailedToLoad: (LoadAdError error) {
            _interstitialAd = null;
            _createInterstitialAd();
          },
        ),
      );

  }

  void _showInterstitialAd(int index) {
    if (_interstitialAd != null && _interstitialCount! % 5 == 0) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
            _moveToNextScreen(index, context)
                .then((value) {
              setState(() {
                _createInterstitialAd();
                _getPreference();
              });
            });

        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
            _moveToNextScreen(index, context)
                .then((value) {
              setState(() {
                _createInterstitialAd();
                _getPreference();
              });
            });

        },
      );
      _interstitialAd!.show();
    } else {
        _moveToNextScreen(index, context)
            .then((value) {
          setState(() {
            _createInterstitialAd();
            _getPreference();
          });
        });
    }
  }

  _getPreference() {
    _interstitialCount = Preference.shared.getInt(Preference.interstitialCount) ?? 1;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _onWillPop(context);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colur.lightBG,
        body: SafeArea(
          top: false,
          bottom: Platform.isAndroid ? true : false,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/background/bg_home.webp"),
                  fit: BoxFit.fill),
            ),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      CommonTopBar(
                          Languages.of(context)!.txtKidsZone,
                          this,
                          isSetting: true, align: TextAlign.left),
                      _categoryWidget()
                    ],
                  ),
                ),

                //   (_isBottomBannerAdLoaded)
                //     ? SizedBox(
                //   height: _bottomBannerAd.size.height.toDouble(),
                //   width: _bottomBannerAd.size.width.toDouble(),
                //   child: AdWidget(ad: _bottomBannerAd),
                // )
                //     : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onWillPop(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Wrap(
              children: [
                AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    actionsPadding: EdgeInsets.zero,
                    title: Text(
                      Languages.of(context)!.txtAreYouSureYouWantToExit,
                    ),
                    actions: [
                      TextButton(
                        child: Text(Languages.of(context)!.txtNo.toUpperCase(),
                            style: const TextStyle(color: Colur.theme)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text(
                          Languages.of(context)!.txtYes.toUpperCase(),
                          style: const TextStyle(color: Colur.theme),
                        ),
                        onPressed: () async {
                          SystemNavigator.pop();
                        },
                      )
                    ]),
              ],
            ),
          );
        });
  }

  _categoryWidget() {
    return Expanded(
      child: GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemCount: categoryList!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.88,
          ),
          itemBuilder: (BuildContext context, int index) {
            return _categoryItem(context, index);
          }),
    );
  }

  _categoryItem(BuildContext context, int index) {
    return InkWell(
      onTap: () {

      //  _showInterstitialAd(index);
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colur.black.withOpacity(0.5),
              blurRadius: 6,
            )
          ],
          color: Constant.colorList[index],
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(35),
              bottomRight: Radius.circular(35),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(5)),
          border: Border.all(color: Colur.white, width: 3),
        ),
        child: Column(
          children: [
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                        "assets/${categoryList![index].categoryImage}${Constant.extensionWebp}"))),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.012),
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0.1,
                      0.5
                    ],
                    colors: [
                      Color(0xffe3e2e2),
                      Colur.white,
                    ]),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    bottomRight: Radius.circular(32),
                    bottomLeft: Radius.circular(2)),
              ),
              child: Center(
                child: Text(
                  categoryList![index].categoryName!,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Constant.colorList[index],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _moveToNextScreen(int index, BuildContext context) async {
    if (categoryList![index].categoryName == "Numbers") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => NumbersScreen(categoryId: categoryList![index].categoryId,
          categoryName: categoryList![index].categoryName)));
    } else if (categoryList![index].categoryName == "Counting") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CountingScreen(categoryId: categoryList![index].categoryId,
          categoryName: categoryList![index].categoryName)));
    } else if (categoryList![index].categoryName == "Addition" || categoryList![index].categoryName == "Subtraction") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => AddSubtractScreen(categoryId: categoryList![index].categoryId,
          categoryName: categoryList![index].categoryName)));
    } else if (categoryList![index].categoryName == "Compare") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CompareScreen(categoryId: categoryList![index].categoryId,
          categoryName: categoryList![index].categoryName)));
    } else if (categoryList![index].categoryName == "Missing Numbers") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MissingNumbersScreen(categoryId: categoryList![index].categoryId,
          categoryName: categoryList![index].categoryName)));
    } else if (categoryList![index].categoryName == "Time") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => TimeScreen(categoryId: categoryList![index].categoryId,
          categoryName: categoryList![index].categoryName)));
    } else if (categoryList![index].categoryName == "Months" || categoryList![index].categoryName == "Days") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MonthsDaysScreen(categoryId: categoryList![index].categoryId,
          categoryName: categoryList![index].categoryName)));
    } else if (categoryList![index].categoryName == "Quantity") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => QuantityScreen(categoryId: categoryList![index].categoryId,
          categoryName: categoryList![index].categoryName)));
    } else if (categoryList![index].categoryName == "Alphabets") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => AlphabetsScreen(categoryId: categoryList![index].categoryId,
          categoryName: categoryList![index].categoryName)));
    } else if (categoryList![index].categoryName == "Upper & Lower") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => UpperLowerScreen(categoryId: categoryList![index].categoryId,
          categoryName: categoryList![index].categoryName)));
    } else if (categoryList![index].categoryName == "Spelling") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => SpellingScreen(categoryId: categoryList![index].categoryId,
          categoryName: categoryList![index].categoryName)));
    }else {
      flutterTts.stop();
      Utils.textToSpeech(categoryList![index].categoryName!, flutterTts);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => QuizScreen(
              categoryId: categoryList![index].categoryId,
              categoryName: categoryList![index].categoryName)));
    }
  }

  _getDataFromDatabase() async {
    categoryList = await DataBaseHelper().getCategoryData();
    setState(() {});
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.strSetting) {
      showDialog(
          context: context,
          builder: (context) {
            return Scaffold(
              backgroundColor: Colur.transparent,
              body: Center(
                child: Wrap(
                  children: const [
                    ParentDialog(),
                  ],
                ),
              ),
            );
          }).then((value) {
        setState(() {
          _getPreference();
        });
      });
      //Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsScreen()));
    }
  }
}
