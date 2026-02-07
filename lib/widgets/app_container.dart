import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';

class ContainerCustom extends StatelessWidget {
  const ContainerCustom({
    Key? key,
    required this.children,
    this.cornerRadius,
    this.color,
    this.gradient,
    this.onTap,
    this.height,
    this.border,
    this.padding,
    this.cornerRadiusColor,
    this.setBounceEffect = false,
    this.width,
    this.alignment,
    this.backgroundAssetImage,
    this.canPop,
  }) : super(key: key);
  final Widget children;
  final String? backgroundAssetImage;
  final BorderRadiusGeometry? cornerRadius;
  final Color? color;
  final Gradient? gradient;
  final Function()? onTap;
  final double? height;
  final BoxBorder? border;
  final EdgeInsets? padding;
  final Color? cornerRadiusColor;
  final bool? setBounceEffect;
  final double? width;
  final bool? canPop;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: canPop ?? true,
        onPopInvokedWithResult: (canpop, dynamic) {
          // logic
        },
        child: setBounceEffect == true
            ? Bounce(
                duration: Duration(seconds: 0),
                tapDelay: Duration(milliseconds: 130),
                onTap: onTap ??
                    () {
                      print("Container onTap is not used");
                    },
                child: Container(
                  margin: padding ?? EdgeInsets.all(5),
                  width: width ?? MediaQuery.of(context).size.width,
                  height: height ?? 70,
                  alignment: alignment == null ? Alignment.center : alignment,
                  decoration: BoxDecoration(
                    gradient: gradient ?? null,
                    color: color ?? Colors.white30,
                    borderRadius:
                        cornerRadius ?? BorderRadius.all(Radius.circular(15)),
                  ),
                  child: children,
                ))
            : GestureDetector(
                onTap: onTap,
                child: backgroundAssetImage != null
                    ? Container(
                        margin: padding ?? EdgeInsets.all(0),
                        width: width ?? MediaQuery.of(context).size.width,
                        height: height ?? 70,
                        alignment:
                            alignment == null ? Alignment.center : alignment,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(backgroundAssetImage ?? ""),
                            fit: BoxFit.fill,
                          ),
                          gradient: gradient ?? null,
                          color: color ?? Colors.white30,
                          borderRadius: cornerRadius ??
                              BorderRadius.all(Radius.circular(15)),
                          border: border ??
                              Border.all(
                                  color:
                                      cornerRadiusColor ?? Colors.transparent),
                        ),
                        child: children,
                      )
                    : Container(
                        margin: padding ?? EdgeInsets.all(0),
                        width: width ?? MediaQuery.of(context).size.width,
                        height: height ?? 70,
                        alignment:
                            alignment == null ? Alignment.center : alignment,
                        decoration: BoxDecoration(
                          gradient: gradient ?? null,
                          color: color ?? Colors.white54,
                          borderRadius: cornerRadius ??
                              BorderRadius.all(Radius.circular(15)),
                          border: border ??
                              Border.all(
                                  color:
                                      cornerRadiusColor ?? Colors.transparent),
                        ),
                        child: children,
                      ),
              ));
  }
}
