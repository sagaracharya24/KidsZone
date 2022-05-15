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

class MissingNumbersScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;

  const MissingNumbersScreen({Key? key, this.categoryId, this.categoryName})
      : super(key: key);

  @override
  _MissingNumbersScreenState createState() => _MissingNumbersScreenState();
}

class _MissingNumbersScreenState extends State<MissingNumbersScreen>
    implements TopBarClickListener {
  PageController? pageController =
      PageController(viewportFraction: 1.0, keepPage: true);
  bool? accept = false;
  int? totalQue = 30;
  int? currentQue = 1;
  bool? isDrag = false;
  FlutterTts flutterTts = FlutterTts();
  Set<int> que = {};
  List<int> options = [];
  Set<int> count = {};


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
            ),
            _missingNumberScreen()
          ],
        ),
      ),
    );
  }

  _missingNumberScreen() {
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
          itemCount: que.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (BuildContext context, int index) {
            return DragTarget(
              builder: (BuildContext context, List<Object?> candidateData,
                  List<dynamic> rejectedData) {
                return count.contains(que.toList()[index])
                    ? Image.asset(
                        "assets/numbers/${que.toList()[index]}${Constant.extensionWebp}",
                      )
                    : Image.asset(
                  "assets/numbers/blank.webp",
                );
              },
              onWillAccept: (data) {
                if(data == que.toList()[index]) {
                  return true;
                } else {
                  return false;
                }
              },
              onAccept: (data) =>_onAccept(data, pageIndex, context),
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
              crossAxisCount: 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.35),
          itemBuilder: (BuildContext context, int index) {
            return Draggable(
              data: options[index],
              onDragStarted: () {
                if (count.contains(options[index]) || isDrag!) {
                  Debug.printLog("====true====");
                }
                if(count.contains(options[index]) == false) {
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
              maxSimultaneousDrags: count.contains(options[index]) || isDrag! ? 0 : 1,
              feedback: count.contains(options[index])
                  ? const SizedBox()
                  : Image.asset(
                      "assets/numbers/${options[index]}${Constant.extensionWebp}",
                      height: MediaQuery.of(context).size.height * 0.065,
                      width: MediaQuery.of(context).size.height * 0.065,
                    ),
              child: count.contains(options[index])
                  ? Image.asset(
                "assets/numbers/blank.webp",
              )
                  : Image.asset(
                      "assets/numbers/${options[index]}${Constant.extensionWebp}",
                    ),
              childWhenDragging: Image.asset(
                "assets/numbers/blank.webp",
              ),
            );
          }),
    );
  }

  _getOptions() {
    List<int> list = List.generate(30, (index) => index + 1);
    int n1, n2;
    do {
      do {
        n1 = Random().nextInt(30);
        do {
          n2 = Random().nextInt(30);
        } while (n1>n2);
      } while (n2-n1 < 5);
    } while (n2-n1 > 18);
    Debug.printLog("n1: $n1 -- n2: $n2");
    que.addAll(list.getRange(n1, n2));
    Debug.printLog("que: " + que.toString());
    Set<int> opt = {};
    opt.addAll(que);
    do {
      opt.add(Random().nextInt(30));
    } while (opt.length != 20);
    Debug.printLog("opt: " + opt.toString());
    options = opt.toList();
    options.shuffle();

    if (que.length < 7) {
      count.add(que.toList()[Random().nextInt(que.length)]);
    } else if (que.length > 5 && que.length < 13) {
      count.add(que.toList()[Random().nextInt(que.length)]);
      count.add(que.toList()[Random().nextInt(que.length)]);
    } else {
      count.add(que.toList()[Random().nextInt(que.length)]);
      count.add(que.toList()[Random().nextInt(que.length)]);
      count.add(que.toList()[Random().nextInt(que.length)]);
    }
    Debug.printLog("count: " + count.toString());
  }

  Future<void> _onAccept(Object? data, int? pageIndex, BuildContext context) async {
    if (count.length < que.length) {
      setState(() {
        count.add(int.parse(data.toString()));
      });
    }

    if (count.length == que.length){
      flutterTts.stop();
      Utils.textToSpeech("Awesome", flutterTts);
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
          que.clear();
          _getOptions();
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
                  que.clear();
                  _getOptions();
                });
              });
        }
      });
    }
    }


  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.strBack) {
      Navigator.of(context).pop();
    }
  }
}
