import 'mosaic_pipeline_step.dart';

class PipelineState {
  PipelineState.empty()
      : allSteps = [],
        currentSteps = [],
        categories = [],
        dataColumns = [];

  PipelineState({
    required this.allSteps,
    required this.currentSteps,
    required this.categories,
    required this.dataColumns,
  });

  PipelineState copyWith({
    allSteps,
    currentSteps,
    categories,
    dataColumns,
  }) =>
      PipelineState(
          allSteps: allSteps ?? this.allSteps,
          currentSteps: currentSteps ?? this.currentSteps,
          categories: categories ?? this.categories,
          dataColumns: dataColumns ?? this.dataColumns);

  final List<MosaicPipelineStep> allSteps;

  //TODO: currently currentSteps isn't immutable. It works for now but we should change that sometime
  final List<MosaicPipelineStep> currentSteps;

  final List<String> categories;
  final List<String> dataColumns;
}
