import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kids_preschool/localization/language/languages.dart';
import 'package:kids_preschool/ui/settings/settings_screen.dart';
import 'package:kids_preschool/utils/color.dart';
import 'package:collection/collection.dart';
import 'package:kids_preschool/utils/debug.dart';

class ParentDialog extends StatefulWidget {
  const ParentDialog({Key? key}) : super(key: key);

  @override
  _ParentDialogState createState() => _ParentDialogState();
}

class _ParentDialogState extends State<ParentDialog> {
  Map<int, String> numMap = {
    0: "Zero",
    1: "One",
    2: "Two",
    3: "Three",
    4: "Four",
    5: "Five",
    6: "Six",
    7: "Seven",
    8: "Eight",
    9: "Nine",
  };

  List<int>? numList;
  TextEditingController numController = TextEditingController();
  String numStr = "";
  List<int>? list;
  String answer = "";

  @override
  void initState() {
    numController.text = "";
    numList = numMap.keys.toList();
    _randomNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [_dialogWidget(context), topBar(context)],
    );
  }

  _dialogWidget(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      height: MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: Colur.themeGradient)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AutoSizeText(
            Languages.of(context)!.txtToAccessEnterNumbers,
            maxLines: 1,
            style: const TextStyle(
                color: Colur.white, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          AutoSizeText(
            numStr,
            maxLines: 1,
            style: const TextStyle(
                color: Colur.lightYellow, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.12,
                ),
                decoration: BoxDecoration(
                  color: Colur.brown,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colur.border, width: 2),
                ),
                child: TextField(
                    controller: numController,
                    maxLength: 4,
                    keyboardType: TextInputType.none,
                    cursorWidth: 0,
                    style: const TextStyle(color: Colur.white),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 5),
                      counterText: "",
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    )),
              ),
              GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.12,
                      vertical: MediaQuery.of(context).size.height * 0.01),
                  itemCount: 11,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 0.95,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if(index == 9) {
                      return InkWell(
                        onTap: (){
                          if (numController.text.length < 4) {
                            numController.text = numController.text + "0";
                          }
                          if(numController.text == answer){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const SettingsScreen()));
                          }
                        },
                        child: Image.asset(
                          "assets/numbers/0.webp",
                        ),
                      );
                    } else if(index == 10){
                      return InkWell(
                        onTap: (){
                          if (numController.text != "") {
                            numController.text = numController.text.substring(0, numController.text.length - 1);
                          }
                        },
                        child: Image.asset(
                          "assets/numbers/backspace.webp",
                        ),
                      );
                    } else{
                      return InkWell(
                        onTap: (){
                          if (numController.text.length < 4) {
                            numController.text = numController.text + (index+1).toString();
                          }
                          if(numController.text == answer){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => const SettingsScreen()));
                          }
                        },
                        child: Image.asset(
                          "assets/numbers/${index + 1}.webp",
                        ),
                      );
                    }
                  }),
            ],
          ),

        ],
      ),
    );
  }

  topBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: Container()),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(200)),
              color: Colur.brown),
          child: Text(
            Languages.of(context)!.txtForGrownUps,
            style: const TextStyle(
                color: Colur.yellow, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.085, right: MediaQuery.of(context).size.width * 0.065
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image.asset(
              "assets/icons/ic_close.webp",
              height: 45,
              width: 45,
            ),
          ),
        ),
      ],
    );
  }

  _randomNumber() {
    list = numList!.sample(4);
    Debug.printLog("sample" + list.toString());

    for (var element in list!) {
      if (element != list!.last) {
        numStr = numStr + numMap[element]! + ", ";
      } else {
        numStr = numStr + numMap[element]!;
      }
      answer = answer + element.toString();
    }
    Debug.printLog(numStr);
    Debug.printLog(answer);
  }
}
