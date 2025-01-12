import 'package:flutter/material.dart';

class MosaicPipelineStep {
  MosaicPipelineStep(this.title, this.id, this.parameterDescriptions)
      : key = UniqueKey(),
        parameterData = {} {}
  Key key;

  String title;
  String id;
  Map<String, String> parameterDescriptions;
  Map<String, String> parameterData;
}

enum MosaicPipelineStepParameterType {
  CustomText,
  CustomNumber,
  SelectableText,
  SelectableNumber,
  Checkbox,
}
