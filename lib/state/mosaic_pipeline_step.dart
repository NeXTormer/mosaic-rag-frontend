import 'package:flutter/material.dart';

class MosaicPipelineStep {
  MosaicPipelineStep(this.title, this.id, this.parameterDescriptions)
      : key = UniqueKey(),
        parameterData = {} {}

  MosaicPipelineStep.clone(MosaicPipelineStep other)
      : key = UniqueKey(),
        this.title = other.title,
        this.id = other.id,
        this.parameterDescriptions = Map.from(other.parameterDescriptions),
        this.parameterData = Map.from(other.parameterData);

  Key key;

  String title;
  String id;
  Map<String, MosaicPipelineStepParameter> parameterDescriptions;
  Map<String, String> parameterData;
}

class MosaicPipelineStepParameter {
  MosaicPipelineStepParameter(
      {required this.title,
      required this.type,
      this.description = '',
      this.required = false,
      this.enforceLimit = false,
      this.supportedValues = const [],
      this.defaultValue = ''});

  String title;
  String description;
  bool required;
  bool enforceLimit;
  String type;
  List<String> supportedValues;
  String defaultValue;
}
