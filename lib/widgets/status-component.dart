import 'package:flutter/material.dart';
import 'package:pinemoji/enums/marker-type-enum.dart';

class MaterialStatusComponent extends StatelessWidget {
  final bool isActive;
  final MarkerType markerType;

  MaterialStatusComponent({this.isActive, this.markerType});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: this.isActive ? Color(0xFFF93963) : Colors.white38,
        ),
      ),
      child: Column(
        children: <Widget>[
          Image.asset(getAssetName(this.markerType)),
        ],
      ),
    );
  }

  static String getAssetName(MarkerType markerType) {
    if (markerType == MarkerType.red) {
      return 'assets/pins/red.png';
    } else if (markerType == MarkerType.yellow) {
      return 'assets/pins/yellow.png';
    } else if (markerType == MarkerType.blue) {
      return 'assets/pins/blue.png';
    } else {
      return 'assets/pins/blue.png';
    }
  }
}
