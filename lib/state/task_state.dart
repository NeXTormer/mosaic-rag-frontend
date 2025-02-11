import 'package:mosaic_rs_application/state/result_list.dart';
import 'package:mosaic_rs_application/state/task_progress.dart';
import 'package:mosaic_rs_application/widgets/mosaic_pipeline_step_parameter_card.dart';

import 'mosaic_pipeline_step.dart';

sealed class TaskState {}

class TaskDoesNotExist extends TaskState {}

class TaskInProgress extends TaskState {
  TaskInProgress(this.taskProgress, this.currentTaskID);

  final TaskProgress taskProgress;
  final String currentTaskID;
}

class TaskFinished extends TaskState {
  TaskFinished(
      {required this.currentTaskID,
      required this.resultColumns,
      required this.chipColumns,
      required this.resultColumnsWordCountList,
      required this.resultColumnsWordCount,
      required this.resultList});

  final String currentTaskID;

  final ResultList resultList;

  final List<String> resultColumns;
  final List<String> chipColumns;
  final Map<String, List<int>> resultColumnsWordCountList;
  final Map<String, int> resultColumnsWordCount;
}

sealed class TaskEvent {}

class CancelTaskEvent extends TaskEvent {}

class StartTaskEvent extends TaskEvent {
  StartTaskEvent(this.query, this.steps);

  final String query;
  final List<MosaicPipelineStep> steps;
}
