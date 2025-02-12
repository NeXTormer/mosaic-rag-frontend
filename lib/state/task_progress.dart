import 'dart:convert';

class DataField {
  DataField()
      : data = null,
        metadata = [];

  final dynamic data;
  final List<Map<String, dynamic>> metadata;
}

class TaskInfo {
  TaskInfo()
      : taskProgress = TaskProgress(),
        hasFinished = false,
        data = [],
        _metadata = [],
        aggregated_data = [],
        chipColumns = [],
        rankColumns = [],
        textColumns = [];

  TaskInfo.fromJSON(dynamic json)
      : taskProgress = TaskProgress(),
        hasFinished = false,
        data = [],
        _metadata = [],
        aggregated_data = [],
        chipColumns = [],
        rankColumns = [],
        textColumns = [] {
    taskProgress = TaskProgress.fromJSON(json['progress']);
    hasFinished = json['has_finished'];

    if (json['result'] != null) {
      final results = json['result'] as Map<String, dynamic>;

      data = (jsonDecode(results['data']) as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();

      _metadata = (jsonDecode(results['metadata']) as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();

      _parseMetadata();

      aggregated_data =
          (jsonDecode(results['aggregated_data']) as List<dynamic>)
              .map((e) => e as Map<String, dynamic>)
              .toList();
    }
  }

  TaskProgress taskProgress;
  bool hasFinished;

  void _parseMetadata() {
    textColumns.clear();
    chipColumns.clear();
    rankColumns.clear();

    for (final column in _metadata) {
      if (column['chip'] == true) {
        chipColumns.add(column['id']);
      }

      if (column['text'] == true) {
        textColumns.add(column['id']);
      }

      if (column['rank'] == true) {
        rankColumns.add(column['id']);
      }
    }
  }

  List<Map<String, dynamic>> data;

  List<Map<String, dynamic>> _metadata;
  List<String> textColumns;
  List<String> chipColumns;
  List<String> rankColumns;

  // final List<String> resultColumns;
  // final List<String> chipColumns;
  // final Map<String, List<int>> resultColumnsWordCountList;
  // final Map<String, int> resultColumnsWordCount;

  List<Map<String, dynamic>> aggregated_data;
}

class TaskProgress {
  TaskProgress()
      : currentStep = '',
        pipelineProgress = '',
        pipelinePercentage = 0,
        stepProgress = '',
        currentStepIndex = 0,
        stepPercentage = 0,
        logs = [];

  TaskProgress.fromJSON(dynamic json)
      : currentStep = '',
        pipelineProgress = '',
        pipelinePercentage = 0,
        stepProgress = '',
        stepPercentage = 0,
        currentStepIndex = 0,
        logs = [] {
    currentStep = json['current_step'];
    currentStepIndex = json['current_step_index'];
    pipelineProgress = json['pipeline_progress'];
    pipelinePercentage = json['pipeline_percentage'];
    stepProgress = json['step_progress'];
    stepPercentage = json['step_percentage'];
    logs = (json['log'] as List)
        .map((item) => item as String)
        .toList()
        .reversed
        .toList();
    ;
  }

  List<String> logs;

  String currentStep;
  int currentStepIndex;

  String pipelineProgress;
  double pipelinePercentage;

  String stepProgress;
  double stepPercentage;
}
