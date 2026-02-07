 import 'package:flutter/material.dart';


class BigCard extends StatelessWidget {
  final Color? backgroundColor;
  final Color? settingColor;
  final double? cardRadius;
  final Color? backgroundMotifColor;
  final Widget? cardActionWidget;



  BigCard({
    this.backgroundColor,
    this.settingColor,
    this.cardRadius = 30,

    this.backgroundMotifColor = Colors.white,
    this.cardActionWidget,

  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 120,
      child: Stack(
      children: [

        Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: (cardActionWidget != null)
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.center,
            children: [

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: settingColor ?? Theme.of(context).cardColor,
                ),
                child: (cardActionWidget != null)
                    ? cardActionWidget
                    : Container(),
              )
            ],
          ),
        ),
      ],
    ),);
  }
}
