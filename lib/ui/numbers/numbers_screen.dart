import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids_preschool/common/commonTopBar/common_topbar.dart';
import 'package:kids_preschool/custom/convert/number_to_word.dart';
import 'package:kids_preschool/interfaces/topbar_clicklistener.dart';
import 'package:kids_preschool/utils/color.dart';
import 'package:kids_preschool/utils/constant.dart';
import 'package:kids_preschool/utils/utils.dart';


class NumbersScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;

  const NumbersScreen({Key? key, this.categoryName, this.categoryId})
      : super(key: key);

  @override
  _NumbersScreenState createState() => _NumbersScreenState();
}

class _NumbersScreenState extends State<NumbersScreen>
    implements TopBarClickListener {
  int? current = 1;
  FlutterTts flutterTts = FlutterTts();


  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  void initState() {
    flutterTts.stop();
    Utils.textToSpeech(widget.categoryName!, flutterTts).then((value) =>
        Utils.textToSpeech(NumberToWord().convert(current!), flutterTts));
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
              widget.categoryName!,
              this,
              totalCount: " ",
              isShowBack: true,
            ),
            _numScreenWidget()
          ],
        ),
      ),
    );
  }

  _numScreenWidget() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/background/bg_background.webp"),
              fit: BoxFit.fill),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _numberBoy(),
            _numText(),
            _numbers(),
          ],
        ),
      ),
    );
  }

  _numText() {
    return Text(
      NumberToWord().convert(current!).toUpperCase(),
      style: const TextStyle(
          fontSize: 22, fontWeight: FontWeight.w500, color: Colur.theme),
    );
  }

  _numbers() {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
            vertical: MediaQuery.of(context).size.height * 0.01),
        itemCount: 30,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () async {
              setState(() {
                current = index + 1;
              });
              flutterTts.stop();
              Utils.textToSpeech(NumberToWord().convert(current!), flutterTts);
            },
            child: Image.asset(
                "assets/numbers/${index + 1}${Constant.extensionWebp}",
              ),

          );
        });
  }

  _numberBoy() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          "assets/images/number_boy.webp",
          height: MediaQuery.of(context).size.height * 0.35,
        ),
        Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12),
          child: Text(
            current!.toString(),
            style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 58,
                fontFamily: "Bubble Bobble",
                color: Colur.lime),
          ),
        ),
      ],
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.strBack) {
      Navigator.of(context).pop();
    }
  }
}
