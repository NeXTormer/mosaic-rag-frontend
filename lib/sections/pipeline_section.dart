import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mosaic_rs_application/backend/mosaic_rs.dart';
import 'package:mosaic_rs_application/backend/pipeline_manager.dart';
import 'package:mosaic_rs_application/backend/search_manager.dart';
import 'package:mosaic_rs_application/main.dart';
import 'package:mosaic_rs_application/widgets/add_pipeline_dialog.dart';
import 'package:mosaic_rs_application/widgets/mosaic_pipeline_step_card.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_button.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_card.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_heading.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/progress_bar.dart';
import 'package:provider/provider.dart';

import '../state/mosaic_pipeline_step.dart';

class PipelineSection extends StatefulWidget {
  const PipelineSection({super.key});

  @override
  State<PipelineSection> createState() => _PipelineSectionState();
}

class _PipelineSectionState extends State<PipelineSection> {
  @override
  void initState() {
    super.initState();
  }

  void onSelectStep(MosaicPipelineStep step) {
    Provider.of<PipelineManager>(context, listen: false).addStep(step);
  }

  @override
  Widget build(BuildContext context) {
    final pipelineSteps =
        Provider.of<PipelineManager>(context, listen: false).pipelineSteps;

    final allPipelineSteps =
        Provider.of<PipelineManager>(context, listen: false).allPipelineSteps;

    final pipelineStepsCategories =
        Provider.of<PipelineManager>(context, listen: false)
            .pipelineStepCategories;

    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 8, right: 16, bottom: 16),
      child: Column(
        children: [
          SizedBox(height: 10),
          FredericHeading('Retrieval pipeline'),
          // SizedBox(height: 22),
          const SizedBox(height: 3),
          Consumer<SearchManager>(builder: (context, searchManager, child) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: FredericButton('Add step', onPressed: () {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AddPipelineDialog(
                        allPipelineSteps,
                        pipelineStepsCategories,
                        onSelect: onSelectStep,
                      );
                    },
                  );
                })),
                const SizedBox(width: 16),
                Flexible(
                    child: FredericButton('Cancel',
                        mainColor: searchManager.showLoadingBar
                            ? theme.negativeColor
                            : theme.disabledGreyColor, onPressed: () {
                  searchManager.cancelTask();
                })),
                const SizedBox(width: 32),
                Column(
                  children: [
                    ProgressBar(
                        searchManager.taskProgress.stepPercentage,
                        searchManager.taskProgress.currentStep.isEmpty
                            ? ''
                            : '${searchManager.taskProgress.currentStep}: ${searchManager.taskProgress.stepProgress}'),
                    const SizedBox(height: 8),
                    ProgressBar(
                        searchManager.taskProgress.pipelinePercentage,
                        searchManager.taskProgress.pipelineProgress.isEmpty
                            ? ''
                            : 'Total: ${searchManager.taskProgress.pipelineProgress}'),
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
            child: Consumer<PipelineManager>(builder: (context, data, child) {
              return ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  itemExtent: 250,
                  physics: BouncingScrollPhysics(),
                  proxyDecorator: _proxyDecorator,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final item = pipelineSteps.removeAt(oldIndex);
                      pipelineSteps.insert(newIndex, item);
                    });
                  },
                  itemCount: pipelineSteps.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      key: pipelineSteps[index].key,
                      child: MosaicPipelineStepCard(
                          index: index, step: pipelineSteps[index]),
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
