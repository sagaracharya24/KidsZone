import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:collection/collection.dart';
import 'package:kids_preschool/common/commonTopBar/common_topbar.dart';
import 'package:kids_preschool/dialog/complete_dialog/complete_dialog_screen.dart';
import 'package:kids_preschool/interfaces/topbar_clicklistener.dart';
import 'package:kids_preschool/utils/color.dart';
import 'package:kids_preschool/utils/constant.dart';
import 'package:kids_preschool/utils/debug.dart';
import 'package:kids_preschool/utils/utils.dart';


class CountingScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;

  const CountingScreen({Key? key, this.categoryId, this.categoryName})
      : super(key: key);

  @override
  _CountingScreenState createState() => _CountingScreenState();
}

class _CountingScreenState extends State<CountingScreen>
    implements TopBarClickListener {
  PageController? pageController =
      PageController(viewportFraction: 1.0, keepPage: true);
  bool? accept = false;

  bool? isDrag = false;

  int? currentQue = 1;
  int? totalQue = 20;

  List<int> options = [];
  int? countAnswer;

  List<int> numQue = [];

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
              "${currentQue!}/",
              this,
              totalCount: "${totalQue!}",
              isShowBack: true,
              isSound: true,
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
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  children: [
                    Expanded(
                      child:
                          Padding(padding: const EdgeInsets.all(15),
                          child: Image.asset("assets/counting/$countAnswer${Constant.extensionWebp}")),
                    ),
                    _dragTarget(index: index),
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

  _draggableOptions(BuildContext context, {int? index}) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.08),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _option1(context),
          _option2(context),
          _option3(context),
          _option4(context),
        ],
      ),
    );
  }

  _option1(BuildContext context) {
    return Draggable(
      maxSimultaneousDrags: accept! || isDrag! ? 0 : 1,
      onDragStarted: () {
        flutterTts.stop();
        Utils.textToSpeech(options[0].toString(), flutterTts);
        setState(() {
          isDrag = true;
        });
      },
      onDragEnd: (_) {
        setState(() {
          isDrag = false;
        });
      },
      data: options[0],
      child: accept! && countAnswer == options[0]
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
            options[0].toString(),
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
              options[0].toString(),
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
        flutterTts.stop();
        Utils.textToSpeech(options[1].toString(), flutterTts);
        setState(() {
          isDrag = true;
        });
      },
      onDragEnd: (_) {
        setState(() {
          isDrag = false;
        });
      },
      data: options[1],
      child: accept! && countAnswer == options[1]
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
            options[1].toString(),
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
              options[1].toString(),
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
        flutterTts.stop();
        Utils.textToSpeech(options[2].toString(), flutterTts);
        setState(() {
          isDrag = true;
        });
      },
      onDragEnd: (_) {
        setState(() {
          isDrag = false;
        });
      },
      data: options[2],
      child: accept! && countAnswer == options[2]
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
            options[2].toString(),
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
              options[2].toString(),
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

  _option4(BuildContext context) {
    return Draggable(
      maxSimultaneousDrags: accept! || isDrag! ? 0 : 1,
      onDragStarted: () {
        flutterTts.stop();
        Utils.textToSpeech(options[3].toString(), flutterTts);
        setState(() {
          isDrag = true;
        });
      },
      onDragEnd: (_) {
        setState(() {
          isDrag = false;
        });
      },
      data: options[3],
      child: accept! && countAnswer ==  options[3]
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
                  color: Colur.lightBlueSquare),
              child: Center(
                child: Text(
                  options[3].toString(),
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
              color: Colur.lightBlueSquare),
          child: Center(
            child: Text(
              options[3].toString(),
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

  _dragTarget({int? index}) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.05),
      child: DragTarget(
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
                      countAnswer!.toString(),
                      style: const TextStyle(fontSize: 24, color: Colur.white),
                    ),
                  ),
                );
        },
        onAccept: (data) async {
          setState(() {
            accept = true;
          });
          await Future.delayed(const Duration(milliseconds: 2280), () {
            if (index != totalQue! - 1) {
              pageController!.jumpToPage(index! + 1);
              setState(() {
                accept = false;
                currentQue = currentQue! + 1;
              });
              options.clear();
              _getOptions(index+1);
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
            setState(() {
              accept = false;
            });
          });
        },
        onWillAccept: (data) {
          if (data == countAnswer) {
            Debug.printLog("accept");
            return true;
          } else {
            Debug.printLog("reject");
            return false;
          }
        },
      ),
    );
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
    if (countAnswer! < 8) {
      do{
        int num;
        do{
          num = Random().nextInt(10);
        } while (num == 0);
        opt.add(num);
      } while(opt.length != 4);
    } else {
      opt.add(countAnswer! + Random().nextInt(6));
      opt.add(countAnswer! - Random().nextInt(4));
      do{
        opt.add(countAnswer! + Random().nextInt(10));
      } while(opt.length != 4);
    }

    Debug.printLog("options: $opt");

    options = opt.toList();
    options.shuffle();
    flutterTts.stop();
    Utils.textToSpeech(Constant.txtCountTheObjects, flutterTts);
  }

  _answerColor() {
    if(options[0] == countAnswer) {
      return Colur.violetSquare;
    } else if(options[1] == countAnswer) {
      return Colur.redSquare;
    } else if(options[2] == countAnswer){
      return Colur.blueSquare;
    } else {
      return Colur.lightBlueSquare;
    }
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.strBack) {
      Navigator.of(context).pop();
    }

    if(name == Constant.strSound) {
      flutterTts.stop();
      Utils.textToSpeech(Constant.txtCountTheObjects, flutterTts);
    }
  }
}
