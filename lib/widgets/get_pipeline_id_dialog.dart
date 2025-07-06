import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mosaic_rag_frontend/main.dart';
import 'package:mosaic_rag_frontend/state/pipeline_cubit.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_button.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_card.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_divider.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_drop_down_text_field.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_heading.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_text_field.dart';
import 'package:toastification/toastification.dart';

import '../api/mosaic_rs.dart';

class GetPipelineIdDialog extends StatefulWidget {
  const GetPipelineIdDialog({super.key});

  @override
  State<GetPipelineIdDialog> createState() => _GetPipelineIdDialogState();
}

class _GetPipelineIdDialogState extends State<GetPipelineIdDialog> {
  bool pipelineConfigAllowed = true;
  bool logsAllowed = true;
  String colorTheme = 'blue-dark';
  String title = 'mosaicRAG';
  String subTitle = '';

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            decoration: BoxDecoration(
                color: theme.cardBackgroundColor,
                borderRadius: BorderRadius.circular(20)),
            child: LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                  width: 400, //constraints.maxWidth * 0.4,
                  height: 440, //constraints.maxHeight * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        FredericHeading(
                            'Confirm settings for the custom configuration'),
                        const SizedBox(height: 4),
                        FredericDivider(),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: FredericCard(
                            borderColor: theme.greyColor,
                            borderWidth: 0.5,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Container(
                              child: Row(
                                children: [
                                  Text('Allow configuration of the pipeline ',
                                      style: TextStyle(color: theme.textColor)),
                                  Expanded(child: Container()),
                                  CupertinoSwitch(
                                      value: pipelineConfigAllowed,
                                      onChanged: (state) async {
                                        setState(() {
                                          pipelineConfigAllowed = state;
                                        });
                                      },
                                      activeColor: theme.mainColor)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: FredericCard(
                            borderColor: theme.greyColor,
                            borderWidth: 0.5,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Container(
                              child: Row(
                                children: [
                                  Text('Allow log access ',
                                      style: TextStyle(color: theme.textColor)),
                                  Expanded(child: Container()),
                                  CupertinoSwitch(
                                      value: logsAllowed,
                                      onChanged: (state) async {
                                        setState(() {
                                          logsAllowed = state;
                                        });
                                      },
                                      activeColor: theme.mainColor)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: FredericCard(
                            borderColor: theme.greyColor,
                            borderWidth: 0.5,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Container(
                              child: Row(
                                children: [
                                  Text('Color theme ',
                                      style: TextStyle(color: theme.textColor)),
                                  const SizedBox(width: 16),
                                  Expanded(child: Container()),
                                  SizedBox(
                                    width: 160,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: FredericDropDownTextField(
                                          height: 42,
                                          maxLength: 100,
                                          onSubmit: (x) {
                                            setState(() {
                                              colorTheme = x;
                                            });
                                          },
                                          defaultValue: colorTheme,
                                          suggestedValues: [
                                            'blue-dark',
                                            'blue-light',
                                            'red-dark',
                                            'red-light',
                                            'orange-dark',
                                            'orange-light',
                                            'pink-dark',
                                            'pink-light'
                                          ]),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: FredericCard(
                            borderColor: theme.greyColor,
                            borderWidth: 0.5,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Container(
                              child: Row(
                                children: [
                                  Text('Title',
                                      style: TextStyle(color: theme.textColor)),
                                  const SizedBox(width: 16),
                                  Expanded(child: Container()),
                                  SizedBox(
                                    width: 160,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: FredericTextField(
                                        'mosaicRAG',
                                        onSubmit: (x) {
                                          title = x;
                                        },
                                        icon: null,
                                        defaultValue: 'mosaicRAG',
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: FredericCard(
                            borderColor: theme.greyColor,
                            borderWidth: 0.5,
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Container(
                              child: Row(
                                children: [
                                  Text('Subtitle',
                                      style: TextStyle(color: theme.textColor)),
                                  const SizedBox(width: 16),
                                  Expanded(child: Container()),
                                  SizedBox(
                                    width: 160,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: FredericTextField(
                                        '',
                                        onSubmit: (x) {
                                          subTitle = x;
                                        },
                                        icon: null,
                                        defaultValue: '',
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Flexible(
                              child: FredericButton('Copy ID', onPressed: () {
                                CopyIDToClipboard(context);
                                Navigator.of(context).pop();
                              }),
                            ),
                            const SizedBox(width: 16),
                            Flexible(
                              child: FredericButton('Download JSON',
                                  onPressed: () {
                                final pipeline =
                                    BlocProvider.of<PipelineCubit>(context)
                                        .state
                                        .currentSteps;
                                String jsonData =
                                    MosaicRS.getPipelineJSON(pipeline, {
                                  'colorTheme': colorTheme,
                                  'title': title,
                                  'subTitle': subTitle,
                                  'pipelineConfigAllowed':
                                      pipelineConfigAllowed,
                                  'logsAllowed': logsAllowed,
                                });

                                FileSaver.instance.saveFile(
                                    name: 'pipeline',
                                    ext: 'json',
                                    mimeType: MimeType.json,
                                    bytes:
                                        Uint8List.fromList(jsonData.codeUnits));
                                toastification.show(
                                    context: context,
                                    type: ToastificationType.success,
                                    style: ToastificationStyle.flat,
                                    title: Text("JSON file downloaded"),
                                    description: Text(
                                        "Custom settings, other than the pipeline configuration, are currently not supported with JSON configs."),
                                    alignment: Alignment.topRight,
                                    icon: Icon(Icons.copy),
                                    autoCloseDuration:
                                        const Duration(seconds: 2),
                                    borderRadius: BorderRadius.circular(12.0),
                                    boxShadow: lowModeShadow);
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ));
            })));
  }

  Future<void> CopyIDToClipboard(BuildContext context) async {
    final pipeline = BlocProvider.of<PipelineCubit>(context).state.currentSteps;
    String pipelineID = await MosaicRS.getPipelineID(pipeline, {
      'colorTheme': colorTheme,
      'title': title,
      'subTitle': subTitle,
      'pipelineConfigAllowed': pipelineConfigAllowed,
      'logsAllowed': logsAllowed,
    });

    Clipboard.setData(ClipboardData(text: pipelineID));
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: Text("Copied to clipboard"),
      description: Text("The pipeline ID has been copied to your clipboard!"),
      alignment: Alignment.topRight,
      icon: Icon(Icons.copy),
      autoCloseDuration: const Duration(seconds: 2),
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: lowModeShadow,
    );
  }
}
