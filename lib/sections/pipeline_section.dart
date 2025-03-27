import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mosaic_rag_frontend/api/mosaic_rs.dart';
import 'package:mosaic_rag_frontend/state/chat_bloc.dart';
import 'package:mosaic_rag_frontend/state/chat_state.dart';
import 'package:mosaic_rag_frontend/state/mosaic_pipeline_state.dart';
import 'package:mosaic_rag_frontend/main.dart';
import 'package:mosaic_rag_frontend/state/pipeline_cubit.dart';
import 'package:mosaic_rag_frontend/state/task_bloc.dart';
import 'package:mosaic_rag_frontend/state/task_state.dart';
import 'package:mosaic_rag_frontend/widgets/add_pipeline_dialog.dart';
import 'package:mosaic_rag_frontend/widgets/mosaic_pipeline_step_card.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_button.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_card.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_heading.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/progress_bar.dart';
import 'package:toastification/toastification.dart';

class PipelineSection extends StatelessWidget {
  const PipelineSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 8, right: 16, bottom: 16),
      child: BlocBuilder<TaskBloc, TaskState>(builder: (context, taskState) {
        var taskProgress = null;
        if (taskState is TaskInProgress) {
          taskProgress = taskState.taskProgress;
        }

        return Column(
          children: [
            SizedBox(height: 10),
            FredericHeading('Retrieval pipeline'),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 2,
                    child: FredericButton('Add step',
                        mainColor: !(taskState is TaskInProgress)
                            ? theme.mainColor
                            : theme.greyColor, onPressed: () {
                      if (taskState is TaskInProgress) return;
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
                    flex: 2,
                    child: FredericButton(
                        switch (taskState) {
                          TaskDoesNotExist() => 'Reset everything',
                          TaskInProgress() => 'Cancel',
                          TaskFinished() => 'Reset everything',
                        },
                        mainColor: switch (taskState) {
                          TaskDoesNotExist() => theme.disabledGreyColor,
                          TaskInProgress() => theme.negativeColor,
                          TaskFinished() => theme.mainColor
                        },
                        onPressed: () => switch (taskState) {
                              TaskDoesNotExist() => null,
                              TaskInProgress() =>
                                BlocProvider.of<TaskBloc>(context)
                                    .add(CancelTaskEvent()),
                              TaskFinished() => {
                                  BlocProvider.of<TaskBloc>(context)
                                      .add(ResetTaskEvent()),
                                  BlocProvider.of<ChatBloc>(context)
                                      .add(ResetChatEvent()),
                                }
                            })),
                const SizedBox(width: 32),
                Flexible(
                  child: FredericButton('Get link', onPressed: () {
                    final pipeline = BlocProvider.of<PipelineCubit>(context)
                        .state
                        .currentSteps;
                    final command =
                        MosaicRS.generateCurlCommandForPipeline(pipeline);
                    Clipboard.setData(ClipboardData(text: command));
                    toastification.show(
                      context: context,
                      type: ToastificationType.success,
                      style: ToastificationStyle.flat,
                      title: Text("Copied to clipboard"),
                      description: Text(
                          "A curl command with the parameters to run the currently configured pipeline has been copied to your clipboard.\nDon't forget to add a query before running the command."),
                      alignment: Alignment.topRight,
                      icon: Icon(Icons.copy),
                      autoCloseDuration: const Duration(seconds: 2),
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: lowModeShadow,
                    );
                  }),
                )
              ],
            ),
            SizedBox(height: 8),
            ProgressBar(
              taskProgress?.stepPercentage ?? 0,
              taskProgress?.currentStep?.isEmpty ?? true
                  ? ''
                  : '${taskProgress?.currentStep ?? 0}: ${taskProgress?.stepProgress ?? 0}',
              length: double.infinity,
            ),
            const SizedBox(height: 12),
            Expanded(
                child: FredericCard(
                    child: Padding(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<PipelineCubit, PipelineState>(
                  builder: (context, pipeline) {
                return BlocBuilder<TaskBloc, TaskState>(
                    buildWhen: (last, current) {
                  if (current is TaskInProgress && last is TaskInProgress) {
                    if (current.taskProgress.currentStepIndex !=
                        last.taskProgress.currentStepIndex) {
                      return true;
                    }
                  }
                  if (current is TaskInProgress && !(last is TaskInProgress))
                    return true;
                  if (!(current is TaskInProgress) && last is TaskInProgress)
                    return true;
                  return false;
                }, builder: (context, taskState) {
                  final activeStepIndex = (taskState is TaskInProgress)
                      ? taskState.taskProgress.currentStepIndex - 1
                      : -1;
                  return IgnorePointer(
                    ignoring: taskState is TaskInProgress,
                    child: ReorderableListView.builder(
                        buildDefaultDragHandles: false,
                        itemExtent: 237,
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
                                activeStepIndex: activeStepIndex,
                                index: index,
                                step: pipeline.currentSteps[index]),
                          );
                        }),
                  );
                });
              }),
            ))),
          ],
        );
      }),
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
