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
import 'package:collection/collection.dart';

class MonthsDaysScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;

  const MonthsDaysScreen({Key? key, this.categoryId, this.categoryName})
      : super(key: key);

  @override
  _MonthsDaysScreenState createState() => _MonthsDaysScreenState();
}

class _MonthsDaysScreenState extends State<MonthsDaysScreen>
    implements TopBarClickListener {
  PageController? pageController =
      PageController(viewportFraction: 1.0, keepPage: true);
  bool? accept = false;
  int? totalQue = 15;
  int? currentQue = 1;
  bool? isDrag = false;
  FlutterTts flutterTts = FlutterTts();

  List<String> options = [];
  List<int> dragQue = [];
  Set<int> count = {};

  Map<int, String> mapMonth = {
    1: "assets/months/months_january.webp",
    2: "assets/months/months_february.webp",
    3: "assets/months/months_march.webp",
    4: "assets/months/months_april.webp",
    5: "assets/months/months_may.webp",
    6: "assets/months/months_june.webp",
    7: "assets/months/months_july.webp",
    8: "assets/months/months_august.webp",
    9: "assets/months/months_september.webp",
    10: "assets/months/months_october.webp",
    11: "assets/months/months_november.webp",
    12: "assets/months/months_december.webp",
  };
  Map<int, String> monthName = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December",
  };

  Map<int, String> map = {};
  Map<int, String> name = {};

  Map<int, String> mapDays = {
    1: "assets/days/days_sunday.webp",
    2: "assets/days/days_monday.webp",
    3: "assets/days/days_tuesday.webp",
    4: "assets/days/days_wednesday.webp",
    5: "assets/days/days_thursday.webp",
    6: "assets/days/days_friday.webp",
    7: "assets/days/days_saturday.webp",
  };
  Map<int, String> dayName = {
    1: "Sunday",
    2: "Monday",
    3: "Tuesday",
    4: "Wednesday",
    5: "Thursday",
    6: "Friday",
    7: "Saturday",
  };


  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  void initState() {
    flutterTts.stop();
    Utils.textToSpeech(widget.categoryName!, flutterTts);
    _monthOption();
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
            _countWidget()
          ],
        ),
      ),
    );
  }

  _countWidget() {
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
              alignment: Alignment.topCenter,
              children: [
                Column(
                  children: [
                    _dragTargets(pageIndex: pageIndex),
                    _dragabbles(pageIndex: pageIndex)
                  ],
                ),
                Visibility(
                  visible: accept!,
                  child: Container(
                      //color: Colur.txtGrey,
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.48),
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

  _dragTargets({int? pageIndex}) {
    return Expanded(
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: dragQue.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 25,
            childAspectRatio: 1.55,
          ),
          itemBuilder: (BuildContext context, int index) {
            return DragTarget(
              builder: (BuildContext context, List<Object?> candidateData,
                  List<dynamic> rejectedData) {
                return count.contains(dragQue[index])
                    ? Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const BoxDecoration(
                          color: Colur.theme,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Image.asset(
                          map[dragQue[index]]!,
                          fit: BoxFit.fill,
                        ))
                    : Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colur.theme,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          border: Border.all(color: Colur.yellow, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            dragQue[index].toString(),
                            style: const TextStyle(
                                color: Colur.yellow, fontSize: 24),
                          ),
                        ),
                      );
              },
              onWillAccept: (data) {
                Debug.printLog(data.toString());
                if (data == dragQue[index]) {
                  Debug.printLog("accept");
                  return true;
                } else {
                  Debug.printLog("reject");
                  return false;
                }
              },
              onAccept: (data) async {
                if (count.length < dragQue.length) {
                  setState(() {
                    count.add(int.parse(data.toString()));
                  });
                }
                flutterTts.stop();
                Utils.textToSpeech(name[data]!, flutterTts).then((value) {
                  if (count.length == dragQue.length) {
                    Utils.textToSpeech("Awesome", flutterTts);
                  }
                });
                if (count.length == dragQue.length) {
                  setState(() {
                    accept = true;
                  });
                  await Future.delayed(const Duration(milliseconds: 2280), () {
                    if (pageIndex != totalQue! - 1) {
                      pageController!.jumpToPage(pageIndex! + 1);
                      setState(() {
                        accept = false;
                        currentQue = currentQue! + 1;
                      });
                      count.clear();
                      options.clear();
                      dragQue.clear();
                      map.clear();
                      name.clear();
                      _monthOption();
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
                              options.clear();
                              dragQue.clear();
                              map.clear();
                              name.clear();
                              _monthOption();
                            });
                          });
                    }
                  });
                }
              },
            );
          }),
    );
  }

  _dragabbles({int? pageIndex}) {
    return Expanded(
      child: GridView.builder(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: options.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 25, childAspectRatio: 1.55),
          itemBuilder: (BuildContext context, int index) {
            return Draggable(
              data: map.keys
                  .firstWhere((element) => map[element] == options[index]),
              feedback: _dragChild(index),
              child: _dragChild(index),
              childWhenDragging: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
              ),
              onDragStarted: () {
                if(count.contains(map.keys.firstWhere(
                        (element) => map[element] == options[index]))) {
                  flutterTts.stop();
                  Utils.textToSpeech(options[index].toString(), flutterTts);
                }
                setState(() {
                  isDrag = true;
                });
              },
              onDragEnd: (_) {
                setState(() {
                  isDrag = false;
                });
              },
              maxSimultaneousDrags: count.contains(map.keys.firstWhere(
                      (element) => map[element] == options[index])) || isDrag! ? 0 : 1,
            );
          }),
    );
  }

  _monthOption() {
    int? num1;
    int? num2;
    if(widget.categoryName == "Months"){
      setState(() {
        map.addAll(mapMonth);
        name.addAll(monthName);
      });
    } else {
      setState(() {
        map.addAll(mapDays);
        name.addAll(dayName);
      });
    }
    var que = map.keys.toList();

    do {
      var numQue = Random().nextInt(que.length);
      dragQue = que.sample(numQue);
      Debug.printLog(dragQue.toString());
    } while (dragQue.length < 3);
    dragQue.sort((a, b) => a.compareTo(b));

    if (dragQue.length < 7) {
      num1 = Random().nextInt(dragQue.length);
      Debug.printLog("len: <7 $num1");
    } else {
      do {
        num1 = Random().nextInt(dragQue.length);
        num2 = Random().nextInt(dragQue.length);
        Debug.printLog("len: >7 $num1==$num2");
      } while (num1 == num2);
    }

    count.add(dragQue[num1]);
    if (num2 != null) {
      count.add(dragQue[num2]);
    }

    Debug.printLog("count: $count");

    options = map.values.toList();
    options.shuffle();
    setState(() {  });
  }

  _dragChild(int index) {
    if (count.contains(map.keys.firstWhere(
            (element) => map[element] == options[index]))) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          color: Colur.transparent,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
      );
    } else {
      return Container(
          height: MediaQuery.of(context).size.height * 0.0525,
          width: MediaQuery.of(context).size.width * 0.268,
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: const BoxDecoration(
            color: Colur.transparent,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          child: Image.asset(
            options[index],
            fit: BoxFit.fill,
          )
      );
    }
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.strBack) {
      Navigator.of(context).pop();
    }
  }
}
