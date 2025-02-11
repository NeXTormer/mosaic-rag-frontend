import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic_rs_application/state/pipeline_cubit.dart';
import 'package:mosaic_rs_application/main.dart';
import 'package:mosaic_rs_application/state/mosaic_pipeline_step.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_card.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_heading.dart';
import 'package:provider/provider.dart';

import 'mosaic_pipeline_step_card.dart';

class AddPipelineDialog extends StatefulWidget {
  AddPipelineDialog({super.key});

  @override
  State<AddPipelineDialog> createState() => _AddPipelineDialogState();
}

class _AddPipelineDialogState extends State<AddPipelineDialog> {
  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    final pipeline = BlocProvider.of<PipelineCubit>(context);
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: LayoutBuilder(builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth * 0.6,
            height: constraints.maxHeight * 0.8,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16),
                    child: Column(
                      children: [
                        FredericHeading('Select a Pipeline Step'),
                        for (final cat in pipeline.state.categories) ...[
                          const SizedBox(height: 16),
                          Material(
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = cat;
                                  });
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: _PipelineStepFilterCard(
                                    text: cat,
                                    selected: selectedCategory == cat)),
                          ),
                        ],
                        const SizedBox(height: 64),
                        Material(
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedCategory = '';
                                });
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: _PipelineStepFilterCard(
                                  text: 'All',
                                  selected: selectedCategory == '')),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            // key: UniqueKey(),
                            padding: EdgeInsets.only(top: 16 + 34, right: 16),
                            children: pipeline.state.allSteps
                                .where((step) => selectedCategory == ''
                                    ? true
                                    : step.category == selectedCategory)
                                .map((step) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 24),
                                      child: Material(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                            height: 200,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: IgnorePointer(
                                                  child: MosaicPipelineStepCard(
                                                      showDescription: true,
                                                      bottomPadding: 0,
                                                      step: step,
                                                      index: 1)),
                                              onTap: () {
                                                pipeline.addStep(step);
                                                Navigator.of(context).pop();
                                              },
                                            )),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _PipelineStepFilterCard extends StatelessWidget {
  const _PipelineStepFilterCard(
      {super.key, required this.text, required this.selected});

  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return FredericCard(
      width: double.infinity,
      borderRadius: 10,
      borderColor: selected ? theme.mainColor : theme.greyTextColor,
      borderWidth: 0.7,
      color: selected
          ? theme.mainColorLight
          : theme.disabledGreyColor.withAlpha(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(text,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: theme.textColor,
            )),
      ),
    );
  }
}

class _IncrementalList extends StatefulWidget {
  final List<Widget> children;
  final Duration delay;
  final EdgeInsets? padding;

  const _IncrementalList(
      {Key? key,
      required this.children,
      this.padding,
      this.delay = const Duration(milliseconds: 50)})
      : super(key: key);

  @override
  _IncrementalListState createState() => _IncrementalListState();
}

class _IncrementalListState extends State<_IncrementalList> {
  int _visibleItemCount = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _startIncrementing();
  }

  void _startIncrementing() {
    timer = Timer.periodic(widget.delay, (timer) {
      if (_visibleItemCount < widget.children.length) {
        setState(() {
          _visibleItemCount++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: widget.padding,
      itemCount: _visibleItemCount,
      itemBuilder: (context, index) {
        return widget.children[index];
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
