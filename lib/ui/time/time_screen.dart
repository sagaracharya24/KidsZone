import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids_preschool/common/commonTopBar/common_topbar.dart';
import 'package:kids_preschool/dialog/complete_dialog/complete_dialog_screen.dart';
import 'package:kids_preschool/interfaces/topbar_clicklistener.dart';
import 'package:kids_preschool/utils/color.dart';
import 'package:kids_preschool/utils/constant.dart';
import 'package:collection/collection.dart';
import 'package:kids_preschool/utils/debug.dart';
import 'package:kids_preschool/utils/utils.dart';

class TimeScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;

  const TimeScreen({Key? key, this.categoryId, this.categoryName})
      : super(key: key);

  @override
  _TimeScreenState createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen>
    implements TopBarClickListener {
  PageController? pageController =
      PageController(viewportFraction: 1.0, keepPage: true);
  int? currentQue = 1;
  int? totalQue = 15;

  FlutterTts flutterTts = FlutterTts();
  bool? isDrag = false;

  Map<String, String> time = {
    "01:30": "assets/time/time_1_30.webp",
    "04:15": "assets/time/time_4_15.webp",
    "08:45": "assets/time/time_8_45g.webp",
    "09:30": "assets/time/time_9_30.webp",
    "02:30": "assets/time/time_2_30.webp",
    "05:45": "assets/time/time_5_45.webp",
    "10:00": "assets/time/time_10.webp",
    "11:15": "assets/time/time_11_15.webp",
    "03:00": "assets/time/time_3.webp",
    "07:15": "assets/time/time_7_15.webp",
    "12:00": "assets/time/time_12.webp",
    "10:15": "assets/time/time_10_15.webp",
    "02:45": "assets/time/time_2_45g.webp",
    "06:00": "assets/time/time_6.webp",
    "08:30": "assets/time/time_8_30.webp",
    "11:45": "assets/time/time_11_45.webp",
  };

  Map<String, String> timeText = {
    "01:30": "Half past one",
    "04:15": "Quarter past four",
    "08:45": "Quarter to nine",
    "09:30": "Half past nine",
    "02:30": "Half past eight",
    "05:45": "Quarter to six",
    "10:00": "Ten o' clock",
    "11:15": "Quarter past eleven",
    "03:00": "Three o' clock",
    "07:15": "Quarter past seven",
    "12:00": "Twelve o' clock",
    "10:15": "Quarter past ten",
    "02:45": "Quarter to three",
    "06:00": "Six o' clock",
    "08:30": "Half past eight",
    "11:45": "Quarter to twelve",
  };

  List<String> option = [];
  List<String> que = [];
  Set<String> count = {};

  bool? accept = false;

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  void initState() {
    flutterTts.stop();
    Utils.textToSpeech(widget.categoryName!, flutterTts);
    _generateTime();
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
            ),
            _timeWidget()
          ],
        ),
      ),
    );
  }

  _timeWidget() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
            return Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: MediaQuery.of(context).size.height * 0.065),
              child: Column(
                children: [_clocks(pageIndex), _timeOptions()],
              ),
            );
          },
        ),
      ),
    );
  }

  _clocks(int pageIndex) {
    return Expanded(
      child: GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 35,
              mainAxisSpacing: 30,
              childAspectRatio: 0.92),
          itemCount: que.length,
          itemBuilder: (BuildContext context, int index) {
            return _dragTargets(index, pageIndex, context);
          }),
    );
  }

  _timeOptions() {
    return GridView.builder(
      padding: const EdgeInsets.all(5),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 70,
            mainAxisSpacing: 25,
            childAspectRatio: 3),
        itemCount: option.length,
        itemBuilder: (BuildContext context, int index) {
          return _draggables(index, context);
        });
  }

  _dragTargets(int index, int pageIndex, BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        DragTarget(
          builder: (BuildContext context, List<Object?> candidateData,
              List<dynamic> rejectedData) {
            return count.contains(
                    time.keys.firstWhere((element) => time[element] == que[index]))
                ? Container()
                : Image.asset(que[index]);
          },
          onWillAccept: (data) {
            if (time[data] == que[index]) {
              Debug.printLog("accept");
              return true;
            } else {
              Debug.printLog("reject");
              return false;
            }
          },
          onAccept: (data) async {
            setState(() {
              accept = true;
            });
            Debug.printLog("que: " + que[index]);
            if (count.length < 4) {
              setState(() {
                count.add(data.toString());
              });
              flutterTts.stop();
              Utils.textToSpeech(timeText[data]!, flutterTts).then((value) {
                if(count.length == 4) {
                  flutterTts.stop();
                  Utils.textToSpeech("Awesome", flutterTts);
                }
              });
              await Future.delayed(const Duration(milliseconds: 2280), () {
                setState(() {
                  accept = false;
                });
              });
            }
            if (count.length == 4) {
              await Future.delayed(const Duration(milliseconds: 1180), () {
                if (pageIndex != totalQue! - 1) {
                  pageController!.jumpToPage(pageIndex + 1);
                  setState(() {
                    accept = false;
                    currentQue = currentQue! + 1;
                  });
                  count.clear();
                  option.clear();
                  que.clear();
                  _generateTime();
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
                          count.clear();
                          option.clear();
                          que.clear();
                          _generateTime();
                        });
                      });
                }
              });
            }
          },
        ),
        Visibility(
          visible: accept! && current == que[index],
          child: Image.asset(
              "assets/animation/animation_success.gif"),
        )
      ],
    );
  }

  String? current;
  _draggables(int index, BuildContext context) {
    return Draggable(
      maxSimultaneousDrags: accept! || isDrag! ? 0 : 1,
      onDragStarted: () {
        setState(() {
          isDrag = true;
          current = time[option[index]];
          Debug.printLog("current: " +current!);
        });
      },
      onDragEnd: (_) {
        setState(() {
          isDrag = false;
        });
      },
      data: option[index],
      feedback: count.contains(option[index])? Container(
        color: Colur.transparent,
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.33,
      ) :Material(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        elevation: 5,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.058,
          width: MediaQuery.of(context).size.width * 0.33,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colur.black.withOpacity(0.25), blurRadius: 5)
            ],
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            gradient: LinearGradient(colors: _optionColor(index)),
          ),
          child: Center(
            child: Text(
              option[index],
              style: const TextStyle(
                  color: Colur.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          ),
        ),
      ),
      child: count.contains(option[index])
          ? Container(
              color: Colur.transparent,
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.33,
            )
          : Material(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              elevation: 5,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colur.black.withOpacity(0.25), blurRadius: 5)
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(colors: _optionColor(index)),
                ),
                child: Center(
                  child: Text(
                    option[index],
                    style: const TextStyle(
                        color: Colur.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
      childWhenDragging: Container(
        color: Colur.transparent,
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.33,
      ),
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.strBack) {
      Navigator.of(context).pop();
    }
  }

  _optionColor(int index) {
    if (index == 0) {
      return Colur.yellowGradient;
    } else if (index == 1) {
      return Colur.greenGradient;
    } else if (index == 2) {
      return Colur.redGradient;
    } else {
      return Colur.violetGradient;
    }
  }

  _generateTime() {
    option = time.keys.toList().sample(4);
    Debug.printLog(option.toString());
    for (var element in option) {
      Debug.printLog(element);
      que.add(time[element]!);
    }
    que.shuffle();
  }
}
