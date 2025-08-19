import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mosaic_rag_frontend/state/pipeline_cubit.dart';
import 'package:mosaic_rag_frontend/main.dart';
import 'package:mosaic_rag_frontend/state/mosaic_pipeline_step.dart';
import 'package:mosaic_rag_frontend/state/task_bloc.dart';
import 'package:mosaic_rag_frontend/state/task_state.dart';
import 'package:mosaic_rag_frontend/widgets/mosaic_pipeline_step_parameter_card.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_card.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/hover_icon_button.dart';
import 'package:zo_animated_border/widget/zo_dual_border.dart';

enum PipelineExecutionState { Idle, Running, Success, Error }

class MosaicPipelineStepCard extends StatelessWidget {
  MosaicPipelineStepCard(
      {super.key,
      required this.step,
      required this.index,
      required this.errorText,
      this.activeStepIndex = -1,
      this.showDescription = false,
      this.bottomPadding = 16});

  final bool showDescription;
  final MosaicPipelineStep step;
  final int index;
  final int activeStepIndex;
  final double bottomPadding;
  final String errorText;

  @override
  Widget build(BuildContext context) {
    final showProgressIndicator = index == activeStepIndex;
    final showError = errorText.isNotEmpty;

    return ReorderableDragStartListener(
      index: index,
      child: Stack(
        children: [
          FredericCard(
              color: showError
                  ? theme.negativeColor.withAlpha(30)
                  : theme.mainColorLight,
              borderColor: showError ? theme.negativeColor : theme.mainColor,
              borderWidth: showProgressIndicator ? 0 : 1.0,
              width: double.infinity,
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (showError)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Tooltip(
                            message: errorText,
                            child: Icon(
                              Icons.warning_amber,
                              color: theme.negativeColor,
                            ),
                          ),
                        ),
                      Expanded(
                        child: Text(step.title,
                            maxLines: 1,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: theme.textColor,
                            )),
                      ),
                      if (!showDescription && !showProgressIndicator)
                        HoverIconButton(() {
                          BlocProvider.of<PipelineCubit>(context, listen: false)
                              .removeStep(step);
                          BlocProvider.of<TaskBloc>(context, listen: false)
                              .add(ResetTaskEvent());
                        }),
                    ],
                  ),
                  SizedBox(height: 12),
                  if (showDescription) ...[
                    Text(
                      step.description,
                      style: GoogleFonts.montserrat(
                          color: theme.textColor, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Parameters',
                      style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: theme.textColor,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      step.parameterDescriptions.values
                          .map((v) => v.title)
                          .toList()
                          .join(", "),
                      style: GoogleFonts.montserrat(
                          color: theme.textColor, fontWeight: FontWeight.w400),
                    ),
                  ],
                  if (!showDescription)
                    Wrap(
                      spacing: 16,
                      children: [
                        for (var entry
                            in step.parameterDescriptions.entries) ...[
                          MosaicPipelineStepParameterCard(
                            parameter: entry.value,
                            defaultValue:
                                step.parameterData.containsKey(entry.key)
                                    ? step.parameterData[entry.key]
                                    : null,
                            onChanged: (data) {
                              step.parameterData[entry.key] = data;
                            },
                          )
                        ]
                      ],
                    ),
                ],
              )),
          if (showProgressIndicator)
            ReorderableDragStartListener(
              index: index,
              child: ZoDualBorder(
                trackBorderColor: theme.greyColor,
                borderWidth: 1,
                // snakeHeadColor: theme.accentColor,
                // snakeTailColor: theme.mainColor,
                // duration: 3,
                duration: const Duration(seconds: 2),
                firstBorderColor: theme.mainColor,
                secondBorderColor: theme.mainColor,
                borderRadius: BorderRadius.circular(14),
                child: Container(),
              ),
            )
        ],
      ),
    );
  }
}
