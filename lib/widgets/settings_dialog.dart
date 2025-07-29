import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mosaic_rag_frontend/main.dart';
import 'package:mosaic_rag_frontend/mosaic_application.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_button.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_card.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_divider.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_drop_down_text_field.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_heading.dart';
import 'package:mosaic_rag_frontend/widgets/standard_elements/frederic_text_field.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  bool pipelineConfigAllowed = config['pipelineConfigAllowed'];
  bool logsAllowed = config['logsAllowed'];
  String colorTheme = config['colorTheme'];
  String title = config['title'];
  String subTitle = config['subTitle'];

  String aboutLinkTitle = config['aboutLinkText'];
  String aboutLinkURL = config['aboutLinkURL'];

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
                  height: 580, //constraints.maxHeight * 0.4,
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
                                          allowCustomText: false,
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
                                        defaultValue: title,
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
                                        defaultValue: subTitle,
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
                                  Text('Info Link Title',
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
                                          setState(() {
                                            aboutLinkTitle = x;
                                          });
                                        },
                                        icon: null,
                                        defaultValue: aboutLinkTitle,
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
                                  Text('Info Link URL',
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
                                          setState(() {
                                            aboutLinkURL = x;
                                          });
                                        },
                                        icon: null,
                                        defaultValue: aboutLinkURL,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        FredericButton('Save Settings', onPressed: () {
                          config['colorTheme'] = colorTheme;
                          config['title'] = title;
                          config['subTitle'] = subTitle;
                          config['pipelineConfigAllowed'] =
                              pipelineConfigAllowed;
                          config['logsAllowed'] = logsAllowed;

                          config['aboutLinkText'] = aboutLinkTitle;
                          config['aboutLinkURL'] = aboutLinkURL;

                          MosaicApplication.rebuildApplication(context);
                          Navigator.of(context).pop();
                        }),
                      ],
                    ),
                  ));
            })));
  }
}
