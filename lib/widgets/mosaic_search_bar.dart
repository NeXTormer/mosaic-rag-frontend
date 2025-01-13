import 'package:flutter/material.dart';
import 'package:mosaic_rs_application/backend/pipeline_manager.dart';
import 'package:mosaic_rs_application/widgets/standard_elements/frederic_text_field.dart';
import 'package:provider/provider.dart';

import '../backend/search_manager.dart';
import '../main.dart';

class MosaicSearchBar extends StatefulWidget {
  const MosaicSearchBar({super.key});

  @override
  State<MosaicSearchBar> createState() => _MosaicSearchBarState();
}

class _MosaicSearchBarState extends State<MosaicSearchBar> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(
        fontSize: 13,
        color: theme.textColor,
      ),
      onSubmitted: (query) {
        final pipelineSteps =
            Provider.of<PipelineManager>(context, listen: false).pipelineSteps;

        Provider.of<SearchManager>(context, listen: false)
            .runPipeline(query, pipelineSteps);
      },
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hoverColor: null,
        hintStyle: TextStyle(color: theme.greyTextColor),
        prefixIcon: Icon(
          Icons.search,
          color: theme.mainColorInText,
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
          child: GestureDetector(
            onTap: () {
              final pipelineSteps =
                  Provider.of<PipelineManager>(context, listen: false)
                      .pipelineSteps;

              Provider.of<SearchManager>(context, listen: false)
                  .runPipeline(controller.text, pipelineSteps);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: theme.mainColor,
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        hintText: 'Enter search query...',
        floatingLabelBehavior: FloatingLabelBehavior.never,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 0.6, color: theme.mainColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 0.6, color: theme.greyColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 0.6, color: theme.greyColor),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 0.6)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 0.6, color: theme.greyColor)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 0.6, color: theme.greyColor)),
      ),
    );
  }
}
