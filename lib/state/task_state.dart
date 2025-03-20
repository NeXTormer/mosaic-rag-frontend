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
  TaskFinished(
      {required this.currentTaskID,
      required this.taskInfo,
      required this.textPreviewColumn,
      required this.rankColumn,
      this.activeChipColumns = const []});

  final String currentTaskID;
  final TaskInfo taskInfo;

  final String textPreviewColumn;
  final String rankColumn;
  final List<String> activeChipColumns;
}

sealed class TaskEvent {}

class CancelTaskEvent extends TaskEvent {}

class ResetTaskEvent extends TaskEvent {}

class StartTaskEvent extends TaskEvent {
  StartTaskEvent(this.query, this.steps);

  final String query;
  final List<MosaicPipelineStep> steps;
}

class ChangeTaskDisplayEvent extends TaskEvent {
  ChangeTaskDisplayEvent(
      {this.rankColumn, this.textPreviewColumn, this.activeChipColumns});

  final String? rankColumn;
  final String? textPreviewColumn;
  final List<String>? activeChipColumns;
}
