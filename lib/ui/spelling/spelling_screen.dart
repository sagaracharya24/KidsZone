import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids_preschool/common/commonTopBar/common_topbar.dart';
import 'package:kids_preschool/database/database_helper.dart';
import 'package:kids_preschool/database/tables/spelling_table.dart';
import 'package:kids_preschool/dialog/complete_dialog/complete_dialog_screen.dart';
import 'package:kids_preschool/interfaces/topbar_clicklistener.dart';
import 'package:kids_preschool/utils/color.dart';
import 'package:kids_preschool/utils/constant.dart';
import 'package:kids_preschool/utils/debug.dart';
import 'package:kids_preschool/utils/utils.dart';


class SpellingScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;

  const SpellingScreen({Key? key, this.categoryId, this.categoryName})
      : super(key: key);

  @override
  _SpellingScreenState createState() => _SpellingScreenState();
}

class _SpellingScreenState extends State<SpellingScreen>
    implements TopBarClickListener {
  PageController? pageController =
      PageController(viewportFraction: 1.0, keepPage: true);
  FlutterTts flutterTts = FlutterTts();
  List<SpellingTable>? spellingList = [];

  List<String>? spelling = [];
  List<int>? shuffled = [];
  Map<int, String>? letters = {};

  Set<int>? count = {};
  Set<int>? countOpt = {};
  int? currentIndex;

  String? currentWord;

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  void initState() {
    flutterTts.stop();
    Utils.textToSpeech(widget.categoryName!, flutterTts);
    _getDataFromDatabase();
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
              "",
              this,
              isShowBack: true,
              isSound: true,
            ),
            _spellingScreen(),
          ],
        ),
      ),
    );
  }

  _spellingScreen() {
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
          itemCount: spellingList!.length,
          itemBuilder: (BuildContext context, int pageIndex) {
            return _itemSpelling(context, pageIndex);
          },
        ),
      ),
    );
  }

  _itemSpelling(BuildContext context, int pageIndex) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        image(context, pageIndex),
        dragTargets(context, pageIndex),
        draggables(context, pageIndex)
      ],
    );
  }

  image(BuildContext context, int pageIndex) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          "assets/background/spelling_frame.webp",
          height: MediaQuery.of(context).size.height * 0.43,
        ),
        Image.asset(
            "assets/${spellingList![pageIndex].image}${Constant.extensionWebp}",
            height: 230)
      ],
    );
  }

  dragTargets(BuildContext context, int pageIndex) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
      child: Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        children: List.generate(
            spelling!.length,
            (index) => DragTarget(
                  builder: (
                    BuildContext context,
                    List<dynamic> accepted,
                    List<dynamic> rejected,
                  ) {
                    return count!.contains(index)
                        ? Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            height: MediaQuery.of(context).size.height * 0.052,
                            width: MediaQuery.of(context).size.height * 0.052,
                            decoration: const BoxDecoration(
                                color: Colur.spellingGreen,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Center(
                              child: Text(
                                spelling![index].toUpperCase(),
                                style: const TextStyle(
                                    color: Colur.white, fontSize: 24),
                              ),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            height: MediaQuery.of(context).size.height * 0.052,
                            width: MediaQuery.of(context).size.height * 0.052,
                            decoration: BoxDecoration(
                                color: Colur.white,
                                border: Border.all(
                                    color: Colur.greyBorder, width: 1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: Center(
                              child: Container(
                                margin: EdgeInsets.all(
                                    MediaQuery.of(context).size.height *
                                        0.0045),
                                decoration: const BoxDecoration(
                                    color: Colur.grey,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Center(
                                  child: Text(
                                    spelling![index].toUpperCase(),
                                    style: const TextStyle(
                                        color: Colur.white, fontSize: 24),
                                  ),
                                ),
                              ),
                            ),
                          );
                  },
                  onWillAccept: (data) {
                    if (spelling![index] == data.toString()) {
                      Debug.printLog("accept");
                      return true;
                    } else {
                      Debug.printLog("reject");
                      return false;
                    }
                  },
                  onAccept: (data) =>
                      _onAccept(data, pageIndex, context, index),
                )),
      ),
    ));
  }

  draggables(BuildContext context, int pageIndex) {
    return Expanded(
      child: Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        children: List.generate(
            shuffled!.length,
            (index) => Draggable(
                  data: letters![shuffled![index]],
                  maxSimultaneousDrags: countOpt!.contains(index) ? 0 : 1,
                  child: countOpt!.contains(index)
                      ? Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          height: MediaQuery.of(context).size.height * 0.052,
                          width: MediaQuery.of(context).size.height * 0.052,
                        )
                      : Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          height: MediaQuery.of(context).size.height * 0.052,
                          width: MediaQuery.of(context).size.height * 0.052,
                          decoration: BoxDecoration(
                              color: getColor(index),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: Center(
                            child: AutoSizeText(
                              letters![shuffled![index]]!.toUpperCase(),
                              style: const TextStyle(
                                  color: Colur.white, fontSize: 24),
                            ),
                          ),
                        ),
                  feedback: Material(
                    color: Colur.transparent,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.052,
                      width: MediaQuery.of(context).size.height * 0.052,
                      decoration: BoxDecoration(
                          color: getColor(index),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: Center(
                        child: Text(
                          letters![shuffled![index]]!.toUpperCase(),
                          style:
                              const TextStyle(color: Colur.white, fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                  childWhenDragging: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    height: MediaQuery.of(context).size.height * 0.052,
                    width: MediaQuery.of(context).size.height * 0.052,
                  ),
                  onDragStarted: () {
                    currentIndex = index;
                    flutterTts.stop();
                    Utils.textToSpeech(
                        letters![shuffled![index]]!.toLowerCase(), flutterTts);
                  },
                )),
      ),
    );
  }

  Future<void> _onAccept(
      Object? data, int? pageIndex, BuildContext context, int index) async {
    setState(() {
      count!.add(index);
      countOpt!.add(currentIndex!);
      Debug.printLog("count =>" + count.toString());
    });

    if (count!.length == spelling!.length) {
      flutterTts.stop();
      Utils.textToSpeech(spellingList![pageIndex!].spelling!, flutterTts).then(
          (value) => Utils.textToSpeech("Well done", flutterTts).then((value) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return CompleteDialog(restartFunction: () {
                        Navigator.of(context).pop();
                        count!.clear();
                        countOpt!.clear();
                        spelling!.clear();
                        letters!.clear();
                        shuffled!.clear();
                        if (pageIndex == spellingList!.length - 1) {
                          pageController!.jumpToPage(0);
                          _getOptions(0);
                        } else {
                          pageController!.jumpToPage(pageIndex + 1);
                          _getOptions(pageIndex + 1);
                        }
                      },
                      image: "assets/icons/ic_next.webp",);
                    });
              }));
    }
  }

  _getOptions(int index) {
    currentWord = spellingList![index].spelling!;
    for (var rune in spellingList![index].spelling!.toLowerCase().runes) {
      var char = String.fromCharCode(rune);
      Debug.printLog(char);
      if (char != " ") {
        spelling!.add(char);
      }
    }

    for (int i = 0; i < spelling!.length; i++) {
      letters!.putIfAbsent(i, () => spelling![i]);
    }

    shuffled!.addAll(letters!.keys.toList());
    shuffled!.shuffle();

    Debug.printLog("letters: " + letters.toString());
  }

  _getDataFromDatabase() async {
    spellingList = await DataBaseHelper().getSpellingData();
    spellingList!.shuffle();
    _getOptions(0);
    setState(() {});
  }

  getColor(int index) {
    if (index % 3 == 3 || index % 3 == 0) {
      return Colur.spellingBrown;
    } else if (index % 3 == 2) {
      return Colur.spellingBlue;
    } else if (index % 3 == 1) {
      return Colur.spellingRed;
    }
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.strBack) {
      Navigator.of(context).pop();
    }

    if (name == Constant.strSound) {
      flutterTts.stop();
      Utils.textToSpeech(currentWord!, flutterTts);
    }
  }
}
