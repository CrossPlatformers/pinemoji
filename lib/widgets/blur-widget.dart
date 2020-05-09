import 'dart:ui';

import 'package:flutter/material.dart';

class BlurWidget extends StatelessWidget {
  BlurWidget({this.isVisible, this.child});
  bool isVisible;
  Widget child;

  @override
  Widget build(BuildContext context) {
    return isVisible
        ? Stack(
            fit: StackFit.expand,
            children: <Widget>[
              child,
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(90)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 4.0,
                    sigmaY: 4.0,
                  ),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              )
            ],
          )
        : child;
  }
}
