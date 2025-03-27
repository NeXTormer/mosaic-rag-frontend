import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:mosaic_rag_frontend/state/mosaic_pipeline_step.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_drop_down_text_field.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_text_field.dart';

class MosaicPipelineStepParameterCard extends StatefulWidget {
  const MosaicPipelineStepParameterCard(
      {super.key,
      required this.parameter,
      required this.onChanged,
      this.defaultValue});

  final MosaicPipelineStepParameter parameter;
  final Function(String) onChanged;
  final String? defaultValue;

  @override
  State<MosaicPipelineStepParameterCard> createState() =>
      _MosaicPipelineStepParameterCardState();
}

class _MosaicPipelineStepParameterCardState
    extends State<MosaicPipelineStepParameterCard> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(textFieldListener);

    controller.text = widget.defaultValue ?? widget.parameter.defaultValue;
  }

  void textFieldListener() {
    widget.onChanged(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: constraints.maxWidth * 0.5 - 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              widget.parameter.title,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            if (widget.parameter.type == 'string')
              SizedBox(
                height: 44,
                child: FredericTextField(
                  widget.parameter.title,
                  text: widget.parameter.defaultValue,
                  defaultValue: null,
                  controller: controller,
                  icon: null,
                  onSubmit: widget.onChanged,
                ),
              ),
            if (widget.parameter.type == 'dropdown')
              FredericDropDownTextField(
                height: 44,
                controller: controller,
                defaultValue: widget.parameter.defaultValue,
                suggestedValues: widget.parameter.supportedValues,
                onSubmit: (data) {
                  if (data.isEmpty)
                    widget.onChanged(controller.text);
                  else
                    widget.onChanged(data);
                },
              ),
            SizedBox(height: 8),
          ],
        ),
      );
    });
  }

  void dispose() {
    super.dispose();
    controller.removeListener(textFieldListener);
  }
}
