import 'dart:convert';

import 'package:mosaic_rs_application/state/result_list.dart';

class TaskProgress {
  TaskProgress()
      : currentStep = '',
        pipelineProgress = '',
        pipelinePercentage = 0,
        stepProgress = '',
        stepPercentage = 0,
        hasFinished = false,
        result = ResultList.fromJSON('[]', '[]');

  TaskProgress.fromJSON(dynamic json)
      : currentStep = '',
        pipelineProgress = '',
        pipelinePercentage = 0,
        stepProgress = '',
        stepPercentage = 0,
        hasFinished = false,
        result = ResultList.fromJSON('[]', '[]') {
    currentStep = json['current_step'];
    pipelineProgress = json['pipeline_progress'];
    pipelinePercentage = json['pipeline_percentage'];
    stepProgress = json['step_progress'];
    stepPercentage = json['step_percentage'];
    hasFinished = json['has_finished'];

    var dataJSON;
    var metadataJSON;
    if (json.containsKey('result') && json['result'] != null) {
      dataJSON = json['result'];
    }

    if (json.containsKey('metadata') && json['metadata'] != null) {
      metadataJSON = json['metadata'];
    }

    if (dataJSON == null) dataJSON = '[]';
    if (metadataJSON == null) metadataJSON = '[]';

    result = ResultList.fromJSON(dataJSON, metadataJSON);
  }

  ResultList result;
  bool hasFinished;

  String currentStep;

  String pipelineProgress;
  double pipelinePercentage;

  String stepProgress;
  double stepPercentage;
}
