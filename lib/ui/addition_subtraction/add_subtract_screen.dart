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

class AddSubtractScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;

  const AddSubtractScreen({Key? key, this.categoryName, this.categoryId})
      : super(key: key);

  @override
  _AddSubtractScreenState createState() => _AddSubtractScreenState();
}

class _AddSubtractScreenState extends State<AddSubtractScreen> implements TopBarClickListener {
  PageController? pageController =
      PageController(viewportFraction: 1.0, keepPage: true);
  FlutterTts flutterTts = FlutterTts();

  bool? accept = false;
  int? answer;
  int? num1 = 1;
  int? num2 = 1;
  List<int>? options = [];
  int? totalQuestions = 20;
  int? currentQuestion = 1;
  bool? isDrag = false;

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  void initState() {
    flutterTts.stop();
    Utils.textToSpeech(widget.categoryName!, flutterTts);
    _generateNumbers();
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
              "$currentQuestion/",
              this,
              totalCount: "$totalQuestions",
              isShowBack: true,
              isSound: true,
            ),
            _addWidget()
          ],
        ),
      ),
    );
  }

  _addWidget() {
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
          itemCount: totalQuestions,
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.height * 0.08,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colur.white, width: 3),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Colur.pinkSquare),
                            child: Center(
                              child: Text(
                                num1!.toString(),
                                style: const TextStyle(
                                    fontSize: 24, color: Colur.white),
                              ),
                            ),
                          ),
                          Image.asset(
                            widget.categoryId == 14 ? "assets/icons/ic_minus.webp" : "assets/icons/ic_add.webp",
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.height * 0.08,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.height * 0.08,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colur.white, width: 3),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Colur.greenSquare),
                            child: Center(
                              child: Text(
                                num2!.toString(),
                                style: const TextStyle(
                                    fontSize: 24, color: Colur.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            "assets/icons/ic_equal.webp",
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.height * 0.08,
                          ),
                          _dragTarget(index: index)
                        ],
                      ),
                    ),
                    _draggableOptions(context, index: index)
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

  _dragTarget({int? index}) {
    return DragTarget(
      builder: (
        BuildContext context,
        List<dynamic> accepted,
        List<dynamic> rejected,
      ) {
        return !accept!
            ? Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.height * 0.08,
                decoration: BoxDecoration(
                    border: Border.all(color: Colur.white, width: 3),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colur.greySquare),
              )
            : Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.height * 0.08,
                decoration: BoxDecoration(
                    border: Border.all(color: Colur.white, width: 3),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: _answerColor()),
                child: Center(
                  child: Text(
                    answer!.toString(),
                    style: const TextStyle(fontSize: 24, color: Colur.white),
                  ),
                ),
              );
      },
      onAccept: (data) async {
        flutterTts.stop();
        Utils.textToSpeech("Awesome", flutterTts);
        setState(() {
          accept = true;
        });
        await Future.delayed(const Duration(milliseconds: 2280), () {
          if (index != totalQuestions! - 1) {
            pageController!.jumpToPage(index! + 1);
            _generateNumbers();
            setState(() {
              currentQuestion = currentQuestion! + 1;
            });
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return CompleteDialog(restartFunction: () {
                    Navigator.of(context).pop();
                    _generateNumbers();
                    setState(() {
                      currentQuestion = 1;
                    });
                    pageController!.jumpToPage(0);
                  });
                });
          }
          setState(() {
            accept = false;
          });
        });
      },
      onWillAccept: (data) {
        if (data == answer) {
          Debug.printLog("accept");
          return true;
        } else {
          Debug.printLog("reject");
          return false;
        }
      },
    );
  }

  _draggableOptions(BuildContext context, {int? index}) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.08),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _option1(context),
          _option2(context),
          _option3(context),
        ],
      ),
    );
  }

  _option1(BuildContext context) {
    return Draggable(
      maxSimultaneousDrags: accept! || isDrag! ? 0 : 1,
      onDragStarted: () {
        setState(() {
          flutterTts.stop();
        });
        flutterTts.stop();
        Utils.textToSpeech(options![0].toString(), flutterTts);
        isDrag = true;
      },
      onDragEnd: (_) {
        setState(() {
          isDrag = false;
        });
      },
      data: options![0],
      child: accept! && answer == options![0]
          ? SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.height * 0.08,
            )
          : Container(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.height * 0.08,
              decoration: BoxDecoration(
                  border: Border.all(color: Colur.white, width: 3),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colur.violetSquare),
              child: Center(
                child: Text(
                  options![0].toString(),
                  style: const TextStyle(fontSize: 24, color: Colur.white),
                ),
              ),
            ),
      feedback: Material(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.height * 0.08,
          decoration: BoxDecoration(
              border: Border.all(color: Colur.white, width: 3),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colur.violetSquare),
          child: Center(
            child: Text(
              options![0].toString(),
              style: const TextStyle(
                fontSize: 24,
                color: Colur.white,
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.height * 0.08,
      ),

    );
  }

  _option2(BuildContext context) {
    return Draggable(
      maxSimultaneousDrags: accept! || isDrag! ? 0 : 1,
      onDragStarted: () {
        setState(() {
          isDrag = true;
        });
        flutterTts.stop();
        Utils.textToSpeech(options![1].toString(), flutterTts);
      },
      onDragEnd: (_) {
        setState(() {
          isDrag = false;
        });
      },
      data: options![1],
      child: accept! && answer == options![1]
          ? SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.height * 0.08,
            )
          : Container(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.height * 0.08,
              decoration: BoxDecoration(
                  border: Border.all(color: Colur.white, width: 3),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colur.redSquare),
              child: Center(
                child: Text(
                  options![1].toString(),
                  style: const TextStyle(fontSize: 24, color: Colur.white),
                ),
              ),
            ),
      feedback: Material(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.height * 0.08,
          decoration: BoxDecoration(
              border: Border.all(color: Colur.white, width: 3),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colur.redSquare),
          child: Center(
            child: Text(
              options![1].toString(),
              style: const TextStyle(fontSize: 24, color: Colur.white),
            ),
          ),
        ),
      ),
      childWhenDragging: SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.height * 0.08,
      ),

    );
  }

  _option3(BuildContext context) {
    return Draggable(
      maxSimultaneousDrags: accept! || isDrag! ? 0 : 1,
      onDragStarted: () {
        setState(() {
          isDrag = true;
        });
        flutterTts.stop();
        Utils.textToSpeech(options![2].toString(), flutterTts);
      },
      onDragEnd: (_) {
        setState(() {
          isDrag = false;
        });
      },
      data: options![2],
      child: accept! && answer == options![2]
          ? SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.height * 0.08,
            )
          : Container(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.height * 0.08,
              decoration: BoxDecoration(
                  border: Border.all(color: Colur.white, width: 3),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Colur.blueSquare),
              child: Center(
                child: Text(
                  options![2].toString(),
                  style: const TextStyle(fontSize: 24, color: Colur.white),
                ),
              ),
            ),
      feedback: Material(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.height * 0.08,
          decoration: BoxDecoration(
              border: Border.all(color: Colur.white, width: 3),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Colur.blueSquare),
          child: Center(
            child: Text(
              options![2].toString(),
              style: const TextStyle(
                fontSize: 24,
                color: Colur.white,
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.height * 0.08,
      ),

    );
  }

  Set<int>? optionSet = {};

  _generateNumbers() {
    options!.clear();
    optionSet!.clear();
    do {
      num1 = Random().nextInt(30);
    } while(num1 == 0);

    if (widget.categoryId == 14) {
      num2 = Random().nextInt(num1!);
    } else {
      num2 = Random().nextInt(30);
    }

    if (widget.categoryId == 14) {
      answer = num1! - num2!;
    } else {
      answer = num1! + num2!;
    }

    int n1;
    int n2;
    optionSet!.add(answer!);
    do {
      do{
        n1 =  Random().nextInt(60);
        do {
          n2 =  Random().nextInt(60);
        } while (n2 == answer);
      } while(n1 == answer);
    } while (n1 == n2);
    Debug.printLog("n1: $n1");
    Debug.printLog("n2: $n2");
    Debug.printLog("ans " + answer.toString());



    optionSet!.add(n1);
    optionSet!.add(n2);


    options = optionSet!.toList();
    options!.shuffle();



    setState(() {});

    textSpeech();


  }

  textSpeech() {
    if (widget.categoryId == 14) {
        flutterTts.stop();
        Utils.textToSpeech("$num1 minus $num2 =", flutterTts);
      } else {
    flutterTts.stop();
    Utils.textToSpeech("$num1 + $num2 =", flutterTts);
    }
  }

  _answerColor() {
    if(options![0] == answer) {
      return Colur.violetSquare;
    } else if(options![1] == answer) {
      return Colur.redSquare;
    } else {
      return Colur.blueSquare;
    }
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.strBack) {
      Navigator.of(context).pop();
    }

    if(name == Constant.strSound) {
     textSpeech();
    }
  }
}
