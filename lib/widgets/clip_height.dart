import 'package:flutter/cupertino.dart';

class ClipHeightQuarter extends CustomClipper<Rect> {
  double height;

  ClipHeightQuarter({this.height});

  @override
  Rect getClip(Size size) {
    Rect rect = Rect.fromLTRB(0.0, -size.height, size.width, this.height);
    return rect;
  }

  @override
  bool shouldReclip(ClipHeightQuarter oldClipper) {
    return true;
  }
}
