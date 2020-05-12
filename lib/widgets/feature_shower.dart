import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';

extension FeatureShower on Widget {
  Widget showFeature(
    BuildContext context, {
    @required String featureId,
    @required String title,
    @required String description,
    ContentLocation contentLocation = ContentLocation.trivial,
    bool show = true,
    VoidCallback onCompleteCallback,
  }) {
    try {
      return DescribedFeatureOverlay(
        featureId: featureId,
        tapTarget: this,
        title: Text(title),
        contentLocation: contentLocation,
        onComplete: () async {
          if (onCompleteCallback != null) {
            onCompleteCallback();
          }
          return true;
        },
        onDismiss: () async {
          return false;
        },
        description: Text(description),
        backgroundColor: Theme.of(context).primaryColor,
        targetColor: Colors.transparent,
        textColor: Theme.of(context).primaryColorDark,
        child: this,
      );
    } catch (e) {
      print(e);
      return this;
    }
  }
}
