import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids_preschool/common/commonTopBar/common_topbar.dart';
import 'package:kids_preschool/database/database_helper.dart';
import 'package:kids_preschool/database/tables/item_table.dart';
import 'package:kids_preschool/dialog/complete_dialog/complete_dialog_screen.dart';
import 'package:kids_preschool/interfaces/topbar_clicklistener.dart';
import 'package:kids_preschool/localization/language/languages.dart';
import 'package:kids_preschool/utils/color.dart';
import 'package:kids_preschool/utils/constant.dart';
import 'package:kids_preschool/utils/debug.dart';
import 'package:kids_preschool/utils/preference.dart';
import 'package:kids_preschool/utils/utils.dart';

class QuizScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;

  const QuizScreen({Key? key, this.categoryName, this.categoryId})
      : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin
    implements TopBarClickListener {
  PageController? pageController =
      PageController(viewportFraction: 1.0, keepPage: true);
  String? answer;
  bool? accept = false;
  int? current = 1;
  bool? isDrag = false;
  List<ItemTable> itemList = [];
  List<String> options = [];

  String? currentItem;

  FlutterTts flutterTts = FlutterTts();
  AnimationController? animationController;
  Animation<double>? animation;

  bool? showHint = false;

  @override
  void dispose() {
    flutterTts.stop();
    animationController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _getPreference();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    animationController!.repeat();
    animation = Tween<double>(begin: 0, end: -250).animate(animationController!)
      ..addListener(() {
        setState(() {});
      });
    _getDataFromDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _setPreference();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colur.lightBG,
        body: SafeArea(
          top: false,
          bottom: Platform.isAndroid ? true : false,
          child: Column(
            children: [
              CommonTopBar(
                "$current/",
                this,
                totalCount: "${itemList.length}",
                isShowBack: true,
                isSound: true,
              ),
              _quizWidget()
            ],
          ),
        ),
      ),
    );
  }

  _quizWidget() {
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
          itemCount: itemList.length,
          itemBuilder: (BuildContext context, int index) {
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  children: [
                    _dragTarget(index: index),
                    _nameText(index),
                    _draggableOptions(context, index: index)
                  ],
                ),
                _animation(context)
              ],
            );
          },
        ),
      ),
    );
  }

  _animation(BuildContext context) {
    return Visibility(
      visible: accept!,
      child: Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.48),
          child: Image.asset("assets/animation/animation_success.gif")),
    );
  }

  _nameText(int index) {
    return AnimatedOpacity(
      opacity: accept! && widget.categoryId != 17 ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: Text(
        itemList[index].itemName!.toUpperCase(),
        style: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.w500, color: Colur.theme),
      ),
    );
  }

  _draggableOptions(BuildContext context, {int? index}) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.08),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Draggable(
                maxSimultaneousDrags: accept! || isDrag! ? 0 : 1,
                onDragStarted: () {
                  setState(() {
                    isDrag = true;
                    showHint = false;
                  });
                },
                onDragEnd: (_) {
                  setState(() {
                    isDrag = false;
                    //_setPreference();
                  });
                },
                data: options[0],
                child: Image.asset(
                  "assets/${options[0]}${Constant.extensionWebp}",
                  height: MediaQuery.of(context).size.height * 0.13,
                  color: options[0] == answer && accept!
                      ? Colur.transparent
                      : Colur.white.withOpacity(1),
                  colorBlendMode: BlendMode.modulate,
                ),
                feedback: Image.asset(
                  "assets/${options[0]}${Constant.extensionWebp}",
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
                childWhenDragging: Image.asset(
                  "assets/${options[0]}${Constant.extensionWebp}",
                  height: MediaQuery.of(context).size.height * 0.13,
                  color: Colors.transparent,
                ),
              ),
              Draggable(
                maxSimultaneousDrags: accept! || isDrag! ? 0 : 1,
                onDragStarted: () {
                  setState(() {
                    isDrag = true;
                    showHint = false;
                  });
                },
                onDragEnd: (_) {
                  setState(() {
                    isDrag = false;
                  });
                },
                data: options[1],
                child: Image.asset(
                  "assets/${options[1]}${Constant.extensionWebp}",
                  height: MediaQuery.of(context).size.height * 0.13,
                  color: options[1] == answer && accept!
                      ? Colur.transparent
                      : Colur.white.withOpacity(1),
                  colorBlendMode: BlendMode.modulate,
                ),
                feedback: Image.asset(
                  "assets/${options[1]}${Constant.extensionWebp}",
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
                childWhenDragging: Image.asset(
                  "assets/${options[1]}${Constant.extensionWebp}",
                  height: MediaQuery.of(context).size.height * 0.13,
                  color: Colors.transparent,
                ),
              ),
              Draggable(
                maxSimultaneousDrags: accept! || isDrag! ? 0 : 1,
                onDragStarted: () {
                  setState(() {
                    isDrag = true;
                    showHint = false;
                  });
                },
                onDragEnd: (_) {
                  setState(() {
                    isDrag = false;
                  });
                },
                data: options[2],
                child: Image.asset(
                  "assets/${options[2]}${Constant.extensionWebp}",
                  height: MediaQuery.of(context).size.height * 0.13,
                  color: options[2] == answer && accept!
                      ? Colur.transparent
                      : Colur.white.withOpacity(1),
                  colorBlendMode: BlendMode.modulate,
                ),
                feedback: Image.asset(
                  "assets/${options[2]}${Constant.extensionWebp}",
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
                childWhenDragging: Image.asset(
                  "assets/${options[2]}${Constant.extensionWebp}",
                  height: MediaQuery.of(context).size.height * 0.13,
                  color: Colors.transparent,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: options[0] == answer &&
                    showHint! &&
                    widget.categoryId != 17,
                child: Transform.rotate(
                  angle: 3.14 / 7,
                  child: Transform.translate(
                    offset: Offset(0, animation!.value),
                    child: Image.asset(
                      "assets/images/hint_hand.webp",
                      height: 50,
                      width: 50,
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: options[1] == answer &&
                    showHint! &&
                    widget.categoryId != 17,
                child: Transform.translate(
                  offset: Offset(0, animation!.value),
                  child: Image.asset(
                    "assets/images/hint_hand.webp",
                    height: 50,
                    width: 50,
                  ),
                ),
              ),
              Visibility(
                visible: options[2] == answer &&
                    showHint! &&
                    widget.categoryId != 17,
                child: Transform.rotate(
                  angle: -3.14 / 7,
                  child: Transform.translate(
                    offset: Offset(0, animation!.value),
                    child: Image.asset(
                      "assets/images/hint_hand.webp",
                      height: 50,
                      width: 50,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
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
          return widget.categoryId != 17
              ? Image.asset(
                  "assets/${itemList[index!].itemImage}${Constant.extensionWebp}",
                  height: MediaQuery.of(context).size.height * 0.25,
                  color: accept!
                      ? Colur.white.withOpacity(1)
                      : Colur.white.withOpacity(0.5),
                  colorBlendMode: BlendMode.modulate,
                )
              : accept!
                  ? Image.asset(
                      "assets/${itemList[index!].itemImage}${Constant.extensionWebp}",
                      height: MediaQuery.of(context).size.height * 0.25,
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      decoration: BoxDecoration(
                          color: Colur.brown,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colur.black.withOpacity(0.25),
                                blurRadius: 8)
                          ]),
                      child: Center(
                        child: Text(
                          itemList[index!].itemName!.toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                              color: Colur.white),
                        ),
                      ),
                    );
        },
        onAccept: (data) async {
          setState(() {
            accept = true;
          });
          flutterTts.stop();
          if (widget.categoryId == 17 && itemList[index!].itemName == "Half") {
            Utils.textToSpeech(itemList[index].itemName! + Languages.of(context)!.txtDollar, flutterTts);
          } else if (widget.categoryId == 17 && itemList[index!].itemName == "Dollar") {
            Utils.textToSpeech(Languages.of(context)!.txtOne + itemList[index].itemName!, flutterTts);
          } else {
            Utils.textToSpeech(itemList[index!].itemName!, flutterTts);
          }
          await Future.delayed(const Duration(milliseconds: 2280), () async {
            if (index != itemList.length - 1) {
              pageController!.jumpToPage(index + 1);
              setState(() {
                current = current! + 1;
              });
              await _generateOptions(index + 1);
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CompleteDialog(restartFunction: () {
                      Navigator.of(context).pop();
                      pageController!.jumpToPage(0);
                      setState(() {
                        current = 1;
                      });
                      _getDataFromDatabase();
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
      ),
    );
  }

  _getDataFromDatabase() async {
    itemList = await DataBaseHelper().getItemData(widget.categoryId!);
    itemList.shuffle();
    await _generateOptions(0);
    setState(() {});
  }

  _generateOptions(int index) {
    currentItem = itemList[index].itemName;

    int n1;
    int n2;

    do {
      do {
        n1 = Random().nextInt(itemList.length);
        do {
          n2 = Random().nextInt(itemList.length);
        } while (n2 == index);
      } while (n1 == index);
    } while (n1 == n2);

    Debug.printLog("n1: $n1");
    Debug.printLog("n2: $n2");
    Debug.printLog("index: " + index.toString());
    Set<String> opt = {};
    answer = itemList[index].itemImage!;
    opt.add(itemList[index].itemImage!);
    opt.add(itemList[n1].itemImage!);
    opt.add(itemList[n2].itemImage!);
    Debug.printLog(opt.toString());

    options = opt.toList();
    options.shuffle();
    Debug.printLog("options: " + options.toString());
    setState(() {});
  }

  _getPreference() {
    if (widget.categoryId == 1) {
      var count = Preference.shared.getBool(Preference.hintAnimal) ?? true;
      Debug.printLog(count.toString() + widget.categoryId.toString());
      if (count) {
        showHint = count;
      }
    } else if (widget.categoryId == 2) {
      var count = Preference.shared.getBool(Preference.hintFruits) ?? true;
      Debug.printLog(count.toString() + widget.categoryId.toString());
      if (count) {
        showHint = count;
      }
    } else if (widget.categoryId == 3) {
      var count = Preference.shared.getBool(Preference.hintBirds) ?? true;
      Debug.printLog(count.toString() + widget.categoryId.toString());
      if (count) {
        showHint = count;
      }
    } else if (widget.categoryId == 4) {
      var count = Preference.shared.getBool(Preference.hintShapes) ?? true;
      Debug.printLog(count.toString() + widget.categoryId.toString());
      if (count) {
        showHint = count;
      }
    } else if (widget.categoryId == 5) {
      var count = Preference.shared.getBool(Preference.hintEducation) ?? true;
      Debug.printLog(count.toString() + widget.categoryId.toString());
      if (count) {
        showHint = count;
      }
    } else if (widget.categoryId == 6) {
      var count = Preference.shared.getBool(Preference.hintVehicles) ?? true;
      Debug.printLog(count.toString() + widget.categoryId.toString());
      if (count) {
        showHint = count;
      }
    }
    setState(() {});
  }

  _setPreference() {
    if (widget.categoryId == 1) {
      Preference.shared.setBool(Preference.hintAnimal, showHint!);
    } else if (widget.categoryId == 2) {
      Preference.shared.setBool(Preference.hintFruits, showHint!);
    } else if (widget.categoryId == 3) {
      Preference.shared.setBool(Preference.hintBirds, showHint!);
    } else if (widget.categoryId == 4) {
      Preference.shared.setBool(Preference.hintShapes, showHint!);
    } else if (widget.categoryId == 5) {
      Preference.shared.setBool(Preference.hintEducation, showHint!);
    } else if (widget.categoryId == 6) {
      Preference.shared.setBool(Preference.hintVehicles, showHint!);
    }
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.strBack) {
      _setPreference();
      Navigator.of(context).pop();
    }
    if (name == Constant.strSound) {
      flutterTts.stop();
      Utils.textToSpeech(currentItem!, flutterTts);
    }
  }
}
