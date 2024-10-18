import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skeleton extends StatelessWidget {
  final double height,
      width,
      padding,
      margin,
      borderRadius,
      marginBottom,
      marginTop,
      marginLeft,
      marginRight;
  final Widget child;

  Skeleton({
    Key key,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.child,
    this.borderRadius,
    this.marginBottom = 0,
    this.marginTop = 0,
    this.marginLeft = 0,
    this.marginRight = 0,
  }) : super(key: key);

   
@override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color.fromRGBO(202, 204, 207, 0.8),
      highlightColor: Colors.white,
      child: child != null
          ? child
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    borderRadius != null ? borderRadius : 6),
                color: Colors.grey[300],
              ),
              height: height,
              padding: padding != null
                  ? EdgeInsets.all(padding)
                  : EdgeInsets.all(0.0),
              margin: margin != null
                  ? EdgeInsets.all(margin)
                  : EdgeInsets.only(
                      top: marginTop,
                      bottom: marginBottom,
                      left: marginLeft,
                      right: marginRight),
              width: width != null ? width : double.infinity,
            ),
    );
  }
}
