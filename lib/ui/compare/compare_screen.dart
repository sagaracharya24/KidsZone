import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids_preschool/common/commonTopBar/common_topbar.dart';
import 'package:kids_preschool/dialog/complete_dialog/complete_dialog_screen.dart';
import 'package:kids_preschool/interfaces/topbar_clicklistener.dart';
import 'package:kids_preschool/utils/color.dart';
import 'package:kids_preschool/utils/constant.dart';
import 'package:kids_preschool/utils/debug.dart';
import 'package:kids_preschool/utils/utils.dart';

class CompareScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;

  const CompareScreen({Key? key, this.categoryId, this.categoryName})
      : super(key: key);

  @override
  _CompareScreenState createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen>
    implements TopBarClickListener {
  PageController? pageController =
      PageController(viewportFraction: 1.0, keepPage: true);

  bool? show1 = false;
  bool? show2 = false;
  int? currentQue = 1;
  int? totalQue = 30;

  List<int> options = [];
  int? countAnswer;
  String? que;

  List<String> questions = ["Which group has less?", "Which group has more?"];

  FlutterTts flutterTts = FlutterTts();

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  void initState() {
    flutterTts.stop();
    Utils.textToSpeech(widget.categoryName!, flutterTts);
    _getOptions();
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

            _compareWidget()
          ],
        ),
      ),
    );
  }

  _compareWidget() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: MediaQuery.of(context).size.height * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _question(index: index),
                  _option1(context, index: index),
                  _option2(context, index: index),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _question({int? index}) {
    return Text(
      que!,
      style: const TextStyle(
        color: Colur.theme,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  _option1(BuildContext context, {int? index}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        InkWell(
          onTap: () async {
            if (!show2!) {
              setState(() {
                show1 = true;
              });
              await _nextPage(index: index);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width*0.85,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colur.black.withOpacity(0.25),
                  )
                ],
                color: Colur.white,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Image.asset(
              "assets/counting/${options[0]}${Constant.extensionWebp}",

            ),
          ),
        ),
        if(countAnswer == options[0] && show1!)...{
          _rightAnsAnim()
        },

        if(countAnswer != options[0] && show1!)...{
          _wrongAnsAnim()
        }
      ],
    );
  }

  _option2(BuildContext context, {int? index}) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        InkWell(
          onTap: () async {
            if (!show1!) {
              setState(() {
                show2 = true;
              });
              await _nextPage(index: index);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width*0.85,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colur.black.withOpacity(0.25),
                  )
                ],
                color: Colur.white,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Image.asset(
                "assets/counting/${options[1]}${Constant.extensionWebp}",

            ),
          ),
        ),
        if(countAnswer == options[1] && show2!)...{
          _rightAnsAnim()
        },

        if(countAnswer != options[1] && show2!)...{
          _wrongAnsAnim()
        }
      ],
    );
  }

  _rightAnsAnim() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Image.asset(
        "assets/animation/animation_right.gif",
        fit: BoxFit.fill,
      ),
    );
  }

  _wrongAnsAnim() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Image.asset(
        "assets/animation/animation_wrong.gif",
        fit: BoxFit.fill,
      ),
    );
  }

  _nextPage({int? index}) {
    Debug.printLog("index : $index --- que: ${totalQue!-1}");
    return Future.delayed(const Duration(milliseconds: 5000), () {
      if (index != totalQue! - 1) {
        pageController!.jumpToPage(index! + 1);
        _getOptions();
        setState(() {
          show1 = false;
          show2 = false;
          currentQue = currentQue! + 1;
        });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return CompleteDialog(restartFunction: () {
                Navigator.of(context).pop();
                pageController!.jumpToPage(0);
                _getOptions();
                setState(() {
                  show1 = false;
                  show2 = false;
                  currentQue = 1;
                });
              });
            });
      }
    });
  }

  _getOptions() {
    do {
      countAnswer = Random().nextInt(totalQue!);
    } while (countAnswer! < 1);
    Debug.printLog("countAnswer : $countAnswer");

    Set<int> opt = {};

    opt.add(countAnswer!);
    do {
      int num;
      do{
        num = Random().nextInt(totalQue!);
      } while(num == 0);
      opt.add(num);
    } while (opt.length != 2);
    int n2 = opt.last;

    if (countAnswer! < n2) {
      que = questions[0];
    } else {
      que = questions[1];
    }

    Debug.printLog("options: $opt");

    options = opt.toList();
    options.shuffle();
    flutterTts.stop();
    Utils.textToSpeech(que!, flutterTts);
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.strBack) {
      Navigator.of(context).pop();
    }

    if(name == Constant.strSound) {
      flutterTts.stop();
      Utils.textToSpeech(que!, flutterTts);
    }
  }
}
