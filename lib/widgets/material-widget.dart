import 'dart:ui';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:pinemoji/enums/marker-type-enum.dart';
import 'package:pinemoji/widgets/blur-widget.dart';
import 'package:pinemoji/widgets/feature_shower.dart';

class MaterialStatusModel {
  String emoji;
  String id;
  String text;
  bool isActive = false;
  bool isBlur = false;
  bool hasBorder = true;
  MarkerType markerType;
  Color color;

  MaterialStatusModel({String emoji, String text, Color color, String id}) {
    this.emoji = emoji;
    this.text = text;
    this.color = color;
    this.id = id;
  }
}

class MaterialStatusContent extends StatelessWidget {
  final MaterialStatusModel materialStatusModel;

  const MaterialStatusContent({Key key, this.materialStatusModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: materialStatusModel.hasBorder
            ? Border.all(
                color: materialStatusModel.color,
              )
            : Border.fromBorderSide(BorderSide.none),
      ),
      height: size.width / 3,
      width: size.width / 3,
      margin: EdgeInsets.all(size.height / 60),
      child: BlurWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/emoji/" + getMaterialIcon(materialStatusModel.id),
              width: size.height / 18,
            ).showFeature(
              context,
              title: 'Malzeme Durumu',
              description:
              'Stok durumunu bildirmek istediğiniz malzemeyi seçebilirsiniz',
              featureId: 'emoji',
              onCompleteCallback: () async {
                await Future.delayed(Duration(milliseconds: 500));
                FeatureDiscovery.discoverFeatures(
                  context,
                  const <String>{
                    // Feature ids for every feature that you want to showcase in order.
                    'map',
                  },
                );
              },
              show: int.tryParse(materialStatusModel.id) == 1,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              materialStatusModel.text,
              style: TextStyle(
                fontSize: size.height / 50,
                fontStyle: FontStyle.italic,
                color: Color(0xFFC7CAD1),
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
        isVisible: materialStatusModel.isBlur,
      ),
    );
  }

  String getMaterialIcon(id) {
    switch (id) {
      case "1":
        return "mask.png";
        break;
      case "2":
        return "mask.png";
        break;
      case "3":
        return "glasses.png";
        break;
      case "4":
        return "glove.png";
        break;
      case "5":
        return "robe.png";
        break;
      case "6":
        return "unknown.png";
        break;
      default:
        return "mask.png";
    }
  }
}
