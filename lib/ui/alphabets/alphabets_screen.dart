import 'dart:io';

import 'package:floodfill_image/floodfill_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids_preschool/common/commonTopBar/common_topbar.dart';
import 'package:kids_preschool/database/database_helper.dart';
import 'package:kids_preschool/database/tables/alphabets_table.dart';
import 'package:kids_preschool/dialog/complete_dialog/complete_dialog_screen.dart';
import 'package:kids_preschool/interfaces/topbar_clicklistener.dart';
import 'package:kids_preschool/utils/color.dart';
import 'package:kids_preschool/utils/constant.dart';
import 'package:kids_preschool/utils/utils.dart';

class AlphabetsScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;

  const AlphabetsScreen({Key? key, this.categoryId, this.categoryName})
      : super(key: key);

  @override
  _AlphabetsScreenState createState() => _AlphabetsScreenState();
}

class _AlphabetsScreenState extends State<AlphabetsScreen>
    implements TopBarClickListener {
  PageController? pageController =
      PageController(viewportFraction: 1.0, keepPage: true);
  FlutterTts flutterTts = FlutterTts();
  List<AlphabetsTable>? alphabetsList = [];
  bool? isShow = false;
  Color? currentColor;


  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  void initState() {
    flutterTts.stop();
    Utils.textToSpeech(widget.categoryName!, flutterTts);
    currentColor = Utils.colorList["orange"];
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
            ),
            _alphabetsScreen(),
          ],
        ),
      ),
    );
  }

  _alphabetsScreen() {
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
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                scrollDirection: Axis.horizontal,
                itemCount: alphabetsList!.length,
                itemBuilder: (BuildContext context, int index) {
                  return _itemAlphabet(context, index);
                },
              ),
            ),
            _colorPencils()
          ],
        ),
      ),
    );
  }

  _itemAlphabet(BuildContext context, int index) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          margin:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.07),
          child: Image.asset("assets/background/alpha_frame.webp"),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _alphabetColor(context, index),
            _alphabetObject(context, index)
          ],
        )
      ],
    );
  }

  _colorPencils() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _color("orange"),
        _color("violet"),
        _color("red"),
        _color("green"),
        _color("cyan"),
        _color("pink"),
        _color("blue"),
        _color("yellow"),
      ],
    );
  }

  _alphabetColor(BuildContext context, int index) {
    if(isShow!) {
      flutterTts.stop();
      Utils.textToSpeech(alphabetsList![index].ttsText!, flutterTts);
    }
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.07),
      child: FloodFillImage(
        fillColor: currentColor!,
        avoidColor: const [Colors.transparent, Colors.black],
        imageProvider: AssetImage(
          "assets/${alphabetsList![index].alphaImage}${Constant.extensionWebp}",
        ),
        height: (MediaQuery.of(context).size.height * 0.25).toInt(),
        onFloodFillEnd: (value) async{
          setState(() {
            isShow = true;
          });
          await Future.delayed(const Duration(milliseconds: 1500), () {
            if (index != alphabetsList!.length - 1) {
              pageController!.jumpToPage(index+1);
              setState(() {
                isShow = false;
              });
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CompleteDialog(restartFunction: () {
                      Navigator.of(context).pop();
                      pageController!.jumpToPage(0);
                      setState(() {
                        isShow = false;
                      });
                    });
                  });
            }
          });

        },
      ),
    );
  }

  _alphabetObject(BuildContext context, int index) {
    return AnimatedOpacity(
      opacity: !isShow! ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 800),
      child: Container(
        margin:
        EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.075 ),
        child: Column(
          children: [
            Image.asset(
              "assets/${alphabetsList![index].objectImage}${Constant.extensionWebp}",
              height: MediaQuery.of(context).size.height * 0.25,
            ),
            Text(
              alphabetsList![index].name!,
              style: const TextStyle(
                color: Colur.theme,
                fontSize: 22,
              ),
            )
          ],
        ),
      ),
    );
  }

  _color(String color) {
    return InkWell(
      onTap: () {
        if (!isShow!) {
          setState(() {
            currentColor = Utils.colorList[color];
          });
        }
      },
      child: Container(
        margin:
            EdgeInsets.only(bottom: currentColor == Utils.colorList[color] ? 10 : 0),
        child: Image.asset(
          "assets/colours/$color.webp",
          height: MediaQuery.of(context).size.height * 0.08,
        ),
      ),
    );
  }

  _getDataFromDatabase() async {
    alphabetsList = await DataBaseHelper().getAlphabetsData();
    setState(() {});
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.strBack) {
      Navigator.of(context).pop();
    }
  }
}
