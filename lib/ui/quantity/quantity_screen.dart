import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:collection/collection.dart';
import 'package:kids_preschool/common/commonTopBar/common_topbar.dart';
import 'package:kids_preschool/custom/convert/number_to_word.dart';
import 'package:kids_preschool/dialog/complete_dialog/complete_dialog_screen.dart';
import 'package:kids_preschool/interfaces/topbar_clicklistener.dart';
import 'package:kids_preschool/utils/color.dart';
import 'package:kids_preschool/utils/constant.dart';
import 'package:kids_preschool/utils/debug.dart';
import 'package:kids_preschool/utils/utils.dart';

class QuantityScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;

  const QuantityScreen({Key? key, this.categoryId, this.categoryName})
      : super(key: key);

  @override
  _QuantityScreenState createState() => _QuantityScreenState();
}

class _QuantityScreenState extends State<QuantityScreen>
    implements TopBarClickListener {
  PageController? pageController =
      PageController(viewportFraction: 1.0, keepPage: true);
  bool? accept = false;
  int? totalQue = 20;
  int? currentQue = 1;
  FlutterTts flutterTts = FlutterTts();

  List<int> options = [];
  int? countAnswer;

  List<int> numQue = [];


  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  void initState() {
    flutterTts.stop();
    Utils.textToSpeech(widget.categoryName!, flutterTts).then((value) => Utils.textToSpeech(Constant.txtHowManyObjects, flutterTts));
    _getNumbers();
    _getOptions(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colur.lightBG,
      body: SafeArea(
        top: false,
        bottom: Platform.isAndroid ? true : false,
        child: Column(
          children: [
            CommonTopBar(
              "$currentQue/",
              this,
              totalCount: "$totalQue",
              isShowBack: true,
              isSound: true,
            ),
            _quantityScreen()
          ],
        ),
      ),
    );
  }

  _quantityScreen() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: MediaQuery.of(context).size.height * 0.01),
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/background/bg_background.webp"),
              fit: BoxFit.fill),
        ),
        child: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          scrollDirection: Axis.horizontal,
          itemCount: totalQue,
          itemBuilder: (BuildContext context, int pageIndex) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    _countItems(pageIndex: pageIndex),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height* 0.05),
                      child: Center(
                        child: AnimatedOpacity(
                          opacity: accept! ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          child: AutoSizeText(
                            NumberToWord().convert(countAnswer!).toUpperCase(),
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colur.theme),
                          ),
                        ),
                      ),
                    ),
                    _countOptions(pageIndex: pageIndex)
                  ],
                ),
                Visibility(
                  visible: accept!,
                  child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.2),
                      child: Image.asset(
                          "assets/animation/animation_success.gif")),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  _countItems({int? pageIndex}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Image.asset("assets/counting/$countAnswer${Constant.extensionWebp}"),
      ),
    );
  }

  _countOptions({int? pageIndex}) {
    return Expanded(
      child: GridView.builder(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: options.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.35),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () async{
                if (!accept!) {
                  flutterTts.stop();
                  Utils.textToSpeech(options[index].toString(), flutterTts).then((value) async{
                    if(options[index] == countAnswer) {
                      setState(() {
                        accept = true;
                      });
                      flutterTts.stop();
                      Utils.textToSpeech("Awesome", flutterTts);
                      await Future.delayed(const Duration(milliseconds: 2280), () {
                        if (pageIndex != totalQue! - 1) {
                          pageController!.jumpToPage(pageIndex! + 1);
                          setState(() {
                            accept = false;
                            currentQue = currentQue! + 1;
                          });
                          options.clear();
                          _getOptions(pageIndex + 1);
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return CompleteDialog(restartFunction: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    accept = false;
                                    currentQue = 1;

                                  });
                                  pageController!.jumpToPage(0);
                                  options.clear();
                                  _getNumbers();
                                  _getOptions(0);
                                });
                            });
                      }
                    });
                  }
                                });
                }

            },
            child: Image.asset(
              "assets/numbers/${options[index]}${Constant.extensionWebp}",
            ),
          );
        }));
  }

  _getNumbers() {
    List<int> numbers = List.generate(30, (index) => index+1);
    numbers.shuffle();
    numQue = numbers.sample(20);
    Debug.printLog(numQue.toString());
  }

  _getOptions(int index) {
    countAnswer = numQue[index];
    Debug.printLog("answer : $countAnswer");

    Set<int> opt = {};

    opt.add(countAnswer!);
    do{
      int num;
      do{
        num = Random().nextInt(totalQue!);
      } while (num == 0);
      opt.add(num);
    } while(opt.length != 15);

    Debug.printLog("options: $opt");

    options = opt.toList();
    options.shuffle();
    flutterTts.stop();
    Utils.textToSpeech(Constant.txtHowManyObjects, flutterTts);
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.strBack) {
      Navigator.of(context).pop();
    }

    if(name == Constant.strSound) {
      flutterTts.stop();
      Utils.textToSpeech(Constant.txtHowManyObjects, flutterTts);
    }
  }
}
