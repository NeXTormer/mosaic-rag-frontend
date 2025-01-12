import 'package:flutter/material.dart';
import 'package:mosaic_rs_application/backend/pipeline_manager.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_text_field.dart';
import 'package:provider/provider.dart';

import '../backend/search_manager.dart';
import '../main.dart';

class MosaicSearchBar extends StatelessWidget {
  const MosaicSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return FredericTextField(
      'Enter search query...',
      onSubmit: (query) {
        final pipelineSteps =
            Provider.of<PipelineManager>(context, listen: false).pipelineSteps;

        Provider.of<SearchManager>(context, listen: false)
            .runPipeline(query, pipelineSteps);
      },
      icon: Icons.search,
      suffixIcon: Padding(
        padding: const EdgeInsets.all(4),
        child: Container(
          decoration: BoxDecoration(
              color: theme.mainColor, borderRadius: BorderRadius.circular(8)),
          child: Icon(
            Icons.settings,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
