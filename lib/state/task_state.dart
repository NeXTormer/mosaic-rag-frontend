import 'package:mosaic_rs_application/state/task_progress.dart';

import 'mosaic_pipeline_step.dart';

sealed class TaskState {}

class TaskDoesNotExist extends TaskState {}

class TaskInProgress extends TaskState {
  TaskInProgress(this.taskProgress, this.currentTaskID);

  final TaskProgress taskProgress;
  final String currentTaskID;
}

class TaskFinished extends TaskState {
  TaskFinished({
    required this.currentTaskID,
    required this.taskInfo,
  });

  final String currentTaskID;

  final TaskInfo taskInfo;
}

sealed class TaskEvent {}

class CancelTaskEvent extends TaskEvent {}

class StartTaskEvent extends TaskEvent {
  StartTaskEvent(this.query, this.steps);

  final String query;
  final List<MosaicPipelineStep> steps;
}

class ChangeRankingEvent extends TaskEvent {
  ChangeRankingEvent(this.column);

  final String column;
}
