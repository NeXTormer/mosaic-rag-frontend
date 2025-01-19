import 'package:mosaic_rs_application/backend/result_list.dart';

class TaskProgress {
  TaskProgress()
      : currentStep = '',
        pipelineProgress = '',
        pipelinePercentage = 0,
        stepProgress = '',
        stepPercentage = 0;

  TaskProgress.fromJSON(dynamic json)
      : currentStep = '',
        pipelineProgress = '',
        pipelinePercentage = 0,
        stepProgress = '',
        stepPercentage = 0 {
    currentStep = json['current_step'];
    pipelineProgress = json['pipeline_progress'];
    pipelinePercentage = json['pipeline_percentage'];
    stepProgress = json['step_progress'];
    stepPercentage = json['step_percentage'];

    if (json.containsKey('result') && json['result'] != null) {
      result = ResultList.fromJSON(json['result']);
    }
  }

  ResultList? result;

  String currentStep;

  String pipelineProgress;
  double pipelinePercentage;

  String stepProgress;
  double stepPercentage;
}
