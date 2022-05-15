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

class UpperLowerScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;

  const UpperLowerScreen({Key? key, this.categoryId, this.categoryName})
      : super(key: key);

  @override
  _UpperLowerScreenState createState() => _UpperLowerScreenState();
}

class _UpperLowerScreenState extends State<UpperLowerScreen>
    implements TopBarClickListener {
  PageController? pageController =
  PageController(viewportFraction: 1.0, keepPage: true);
  bool? accept = false;
  int? totalQue = 30;
  int? currentQue = 1;
  bool? isDrag = false;
  FlutterTts flutterTts = FlutterTts();
  List<int> que = [];
  List<int> options = [];
  Set<int> count = {};


  Map<int, String> upper = {
    1: "assets/upper/A.webp",
    2: "assets/upper/B.webp",
    3: "assets/upper/C.webp",
    4: "assets/upper/D.webp",
    5: "assets/upper/E.webp",
    6: "assets/upper/F.webp",
    7: "assets/upper/G.webp",
    8: "assets/upper/H.webp",
    9: "assets/upper/I.webp",
    10: "assets/upper/J.webp",
    11: "assets/upper/K.webp",
    12: "assets/upper/L.webp",
    13: "assets/upper/M.webp",
    14: "assets/upper/N.webp",
    15: "assets/upper/O.webp",
    16: "assets/upper/P.webp",
    17: "assets/upper/Q.webp",
    18: "assets/upper/R.webp",
    19: "assets/upper/S.webp",
    20: "assets/upper/T.webp",
    21: "assets/upper/U.webp",
    22: "assets/upper/V.webp",
    23: "assets/upper/W.webp",
    24: "assets/upper/X.webp",
    25: "assets/upper/Y.webp",
    26: "assets/upper/Z.webp",
  };

  Map<int, String> lower = {
    1: "assets/lower/a.webp",
    2: "assets/lower/b.webp",
    3: "assets/lower/c.webp",
    4: "assets/lower/d.webp",
    5: "assets/lower/e.webp",
    6: "assets/lower/f.webp",
    7: "assets/lower/g.webp",
    8: "assets/lower/h.webp",
    9: "assets/lower/i.webp",
    10: "assets/lower/j.webp",
    11: "assets/lower/k.webp",
    12: "assets/lower/l.webp",
    13: "assets/lower/m.webp",
    14: "assets/lower/n.webp",
    15: "assets/lower/o.webp",
    16: "assets/lower/p.webp",
    17: "assets/lower/q.webp",
    18: "assets/lower/r.webp",
    19: "assets/lower/s.webp",
    20: "assets/lower/t.webp",
    21: "assets/lower/u.webp",
    22: "assets/lower/v.webp",
    23: "assets/lower/w.webp",
    24: "assets/lower/x.webp",
    25: "assets/lower/y.webp",
    26: "assets/lower/z.webp",
  };

  Map<int, String> alphabets = {
    1: "a",
    2: "b",
    3: "c",
    4: "d",
    5: "e",
    6: "f",
    7: "g",
    8: "h",
    9: "i",
    10: "j",
    11: "k",
    12: "l",
    13: "m",
    14: "n",
    15: "o",
    16: "p",
    17: "q",
    18: "r",
    19: "s",
    20: "t",
    21: "u",
    22: "v",
    23: "w",
    24: "x",
    25: "y",
    26: "z",
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
            _upperLowerScreen()
          ],
        ),
      ),
    );
  }

  _upperLowerScreen() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: MediaQuery.of(context).size.height * 0.01
        ),
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
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: MediaQuery.of(context).size.height*0.05),
          shrinkWrap: true,
          itemCount: que.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 30,
            crossAxisSpacing: 40,
            childAspectRatio: 9/20
          ),
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Image.asset(
                  upper[que[index]]!,
                ),
                const SizedBox(height: 5,),
                DragTarget(
                  builder: (BuildContext context, List<Object?> candidateData,
                      List<dynamic> rejectedData) {
                    return count.contains(que[index])
                        ? Image.asset(
                        lower[que[index]]!,
                    )
                        : Image.asset(
                      "assets/numbers/blank.webp",
                    );
                  },
                  onWillAccept: (data) {
                    if(lower.keys.firstWhere((element) => lower[element] == data) == upper.keys.firstWhere((element) => upper[element] == upper[que[index]])) {
                      Debug.printLog("accept");
                      return true;
                    } else {
                      Debug.printLog("reject");
                      return false;
                    }
                  },
                  onAccept: (data) =>_onAccept(data, pageIndex, context),
                ),
              ],
            );
          }),
    );
  }

  _dragabbles({int? pageIndex}) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.02),
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 15,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.35),
          itemBuilder: (BuildContext context, int index) {
            Debug.printLog(lower[options[index]]!.toString());
            return Draggable(
              data: lower[options[index]]!,
              onDragStarted: () {
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
                lower[options[index]]!,
                height: MediaQuery.of(context).size.height * 0.068,
                width: MediaQuery.of(context).size.height * 0.068,
              ),
              child: count.contains(options[index])
                  ? const SizedBox()
                  : Image.asset(
                lower[options[index]]!,
              ),
              childWhenDragging: const SizedBox()
            );
          }),
    );
  }

  _getOptions() {
    que = upper.keys.toList().sample(8);

    Set<int> opt = {};
    opt.addAll(que);
    do {
      var rnd = Random().nextInt(25);
      if (rnd != 0) {
        opt.add(rnd);
      }
    } while (opt.length != 15);

    options = opt.toList();
    options.shuffle();

    Debug.printLog("que: $que");
    Debug.printLog("opt: $options");


  }

  Future<void> _onAccept(Object? data, int? pageIndex, BuildContext context) async {
    flutterTts.stop();
    Utils.textToSpeech(alphabets[lower.keys.firstWhere((element) => lower[element] == data)]!, flutterTts);
    if (count.length < que.length) {
      setState(() {
        count.add(lower.keys.firstWhere((element) => lower[element] == data));
      });
    }

    if (count.length == que.length) {
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
