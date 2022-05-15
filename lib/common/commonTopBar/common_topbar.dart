import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:kids_preschool/interfaces/topbar_clicklistener.dart';
import 'package:kids_preschool/utils/color.dart';
import 'package:kids_preschool/utils/constant.dart';



class CommonTopBar extends StatefulWidget {
  final String headerName;
  final TopBarClickListener clickListener;

  final bool isShowBack;
  final bool isSetting;
  final bool isSound;
  final bool isNoSound;
  final bool isRestart;
  final String totalCount;
  final TextAlign align;

  const CommonTopBar(
    this.headerName,
    this.clickListener, {
    this.isShowBack = false,
    this.isSetting = false,
    this.isSound = false,
    this.isNoSound = false,
    this.isRestart = false,
    this.totalCount = "",
    this.align = TextAlign.center,
    Key? key,
  }) : super(key: key);

  @override
  _CommonTopBarState createState() => _CommonTopBarState();
}

class _CommonTopBarState extends State<CommonTopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
       color: Colur.theme,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20) )
      ),

      child: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: widget.totalCount == "" ? MainAxisAlignment.start:MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AutoSizeText(
                    widget.headerName,
                    maxLines: 1,
                    softWrap: true,
                    textAlign: widget.align,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                        color: Colur.yellow),
                  ),
                  Visibility(
                    visible: widget.totalCount != "",
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 1),
                      child: AutoSizeText(
                        widget.totalCount,
                        maxLines: 1,
                        softWrap: true,
                        textAlign: widget.align,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colur.yellow),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    widget.clickListener.onTopBarClick(Constant.strBack);
                  },
                  child: Visibility(
                    visible: widget.isShowBack,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 15.0, left: 15.0, right: 15.0),
                      child: Image.asset(
                        'assets/icons/ic_back.webp',
                        height: 35,
                        width: 35,
                      ),
                    ),
                  ),
                ),
                Expanded(child: Container()),
                InkWell(
                  onTap: () {
                    widget.clickListener.onTopBarClick(Constant.strSetting);
                  },
                  child: Visibility(
                    visible: widget.isSetting,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 15.0, left: 15.0, right: 15.0),
                      child: Image.asset(
                        'assets/icons/ic_setting.webp',
                        width: 35,
                        height: 35,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async{
                    widget.clickListener.onTopBarClick(Constant.strSound);
                  },
                  child: Visibility(
                    visible: widget.isSound,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 15.0, left: 15.0, right: 15.0),
                      child: Image.asset(
                        'assets/icons/ic_sound.webp',
                        width: 35,
                        height: 35,
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
