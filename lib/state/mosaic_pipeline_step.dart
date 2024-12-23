import 'package:flutter/material.dart';

class MosaicPipelineStep {
  MosaicPipelineStep(this.title) : key = UniqueKey() {}

  String title;
  Key key;
}

enum MosaicPipelineStepParameterType {
  CustomText,
  CustomNumber,
  SelectableText,
  SelectableNumber,
  Checkbox,
}
