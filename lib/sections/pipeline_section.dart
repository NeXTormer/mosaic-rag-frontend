import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mosaic_rs_application/backend/mosaic_rs.dart';
import 'package:mosaic_rs_application/backend/pipeline_manager.dart';
import 'package:mosaic_rs_application/widgets/mosaic_pipeline_step_card.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_card.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_heading.dart';
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

  @override
  Widget build(BuildContext context) {
    final pipelineSteps =
        Provider.of<PipelineManager>(context, listen: false).pipelineSteps;

    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 16, bottom: 16),
      child: Column(
        children: [
          SizedBox(height: 10),
          FredericHeading('Retrieval pipeline'),
          SizedBox(height: 32),
          Expanded(
              child: FredericCard(
                  child: Padding(
            padding: const EdgeInsets.all(16),
            child: ReorderableListView.builder(
                buildDefaultDragHandles: false,
                itemExtent: 440,
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
                  return MosaicPipelineStepCard(
                      index: index,
                      key: pipelineSteps[index].key,
                      height: 420,
                      step: pipelineSteps[index]);
                }),
          ))),
        ],
      ),
    );
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 0,
      color: Colors.white,
      child: child,
    );
  }
}
