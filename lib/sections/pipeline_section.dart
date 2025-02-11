import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mosaic_rs_application/api/mosaic_rs.dart';
import 'package:mosaic_rs_application/state/mosaic_pipeline_state.dart';
import 'package:mosaic_rs_application/main.dart';
import 'package:mosaic_rs_application/state/pipeline_cubit.dart';
import 'package:mosaic_rs_application/state/task_bloc.dart';
import 'package:mosaic_rs_application/state/task_state.dart';
import 'package:mosaic_rs_application/widgets/add_pipeline_dialog.dart';
import 'package:mosaic_rs_application/widgets/mosaic_pipeline_step_card.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_button.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_card.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_heading.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/progress_bar.dart';

class PipelineSection extends StatelessWidget {
  const PipelineSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 8, right: 16, bottom: 16),
      child: Column(
        children: [
          SizedBox(height: 10),
          FredericHeading('Retrieval pipeline'),
          const SizedBox(height: 3),
          BlocBuilder<TaskBloc, TaskState>(builder: (context, taskState) {
            var taskProgress = null;
            if (taskState is TaskInProgress) {
              taskProgress = taskState.taskProgress;
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: FredericButton('Add step', onPressed: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext innerContext) {
                      return BlocProvider.value(
                          value: context.watch<PipelineCubit>(),
                          child: AddPipelineDialog());
                    },
                  );
                })),
                const SizedBox(width: 16),
                Flexible(
                    child: FredericButton('Cancel',
                        mainColor: taskState is TaskInProgress
                            ? theme.negativeColor
                            : theme.disabledGreyColor, onPressed: () {
                  print('adding cancel event');
                  BlocProvider.of<TaskBloc>(context).add(CancelTaskEvent());
                })),
                const SizedBox(width: 32),
                Column(
                  children: [
                    ProgressBar(
                        taskProgress?.stepPercentage ?? 0,
                        taskProgress?.currentStep?.isEmpty ?? true
                            ? ''
                            : '${taskProgress?.currentStep ?? 0}: ${taskProgress?.stepProgress ?? 0}'),
                    const SizedBox(height: 8),
                    ProgressBar(
                        taskProgress?.pipelinePercentage ?? 0,
                        taskProgress?.pipelineProgress?.isEmpty ?? true
                            ? ''
                            : 'Total: ${taskProgress?.pipelineProgress ?? ''}'),
                  ],
                )
              ],
            );
          }),
          SizedBox(height: 16),
          Expanded(
              child: FredericCard(
                  child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<PipelineCubit, PipelineState>(
                builder: (context, pipeline) {
              return ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  itemExtent: 250,
                  physics: BouncingScrollPhysics(),
                  proxyDecorator: _proxyDecorator,
                  onReorder: (oldIndex, newIndex) {
                    BlocProvider.of<PipelineCubit>(context)
                        .reorderStep(oldIndex, newIndex);
                  },
                  itemCount: pipeline.currentSteps.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      key: pipeline.currentSteps[index].key,
                      child: MosaicPipelineStepCard(
                          index: index, step: pipeline.currentSteps[index]),
                    );
                  });
            }),
          ))),
        ],
      ),
    );
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 10,
      color: Colors.white,
      child: child,
    );
  }
}
