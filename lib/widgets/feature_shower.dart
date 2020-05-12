import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';

extension FeatureShower on Widget {
  Widget showFeature(
    BuildContext context, {
    @required String featureId,
    @required String title,
    @required String description,
    bool show = true,
  }) {
    return DescribedFeatureOverlay(
      featureId: featureId,
      tapTarget: this,
      title: Text(title),
      onComplete: () async {
        return true;
      },
      onDismiss: () async {
        return false;
      },
      description: Text(description),
      backgroundColor: Theme.of(context).primaryColor,
      targetColor: Colors.transparent,
      textColor: Colors.white,
      child: this,
    );
  }
}
