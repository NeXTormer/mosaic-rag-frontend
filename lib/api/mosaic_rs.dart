import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mosaic_rag_frontend/state/mosaic_pipeline_step.dart';
import 'package:mosaic_rag_frontend/state/task_progress.dart';
import 'package:mosaic_rag_frontend/main.dart';
import 'package:mosaic_rag_frontend/widgets/mosaic_pipeline_step_card.dart';

class MosaicRS {
  static Future<String> enqueueTask(Map<String, dynamic> parameters) async {
    final dio = Dio();
    final response = await dio.post(serverURL + '/task/enqueue',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(parameters));

    return response.data as String;
  }

  static Future<String> _savePipeline(String pipelineJSON) async {
    final dio = Dio();
    final response = await dio.post(serverURL + '/pipeline/save',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: pipelineJSON);

    return response.data as String;
  }

  static Future<TaskInfo> getTaskProgress(String taskID) async {
    final dio = Dio();
    final response = await dio.get(serverURL + '/task/progress/$taskID');

    return TaskInfo.fromJSON(response.data);
  }

  static void cancelTask(String taskID) {
    final dio = Dio();
    dio.get(serverURL + '/task/cancel/$taskID');
  }

  static Future<Map<String, dynamic>> getPipelineInfo() async {
    final dio = Dio();
    final response = await dio.get(serverURL + '/pipeline/info');

    return response.data;
  }

  static Map<String, dynamic> getPipelineParameters(
      List<MosaicPipelineStep> steps, String query) {
    Map<String, dynamic> parameters = {};

    print(steps.length);
    parameters['pipeline'] = <String, dynamic>{
      'query': query,
    };

    for (int i = 0; i < steps.length; i++) {
      final index = i + 1;
      final step = steps[i];

      final parameterData = step.parameterData;
      List<String> parametersToRemove = [];
      for (final entry in parameterData.entries) {
        if (entry.value.isEmpty) parametersToRemove.add(entry.key);
      }
      for (final param in parametersToRemove) parameterData.remove(param);

      parameters['pipeline']['$index'] = <String, dynamic>{
        'id': step.id,
        'parameters': step.parameterData
      };
    }
    print(parameters['pipeline'].length);
    return parameters;
  }

  static Future<String> chat(String taskID, String? chatID, String model,
      String column, String message) async {
    final dio = Dio();
    final response = await dio.get(serverURL + '/task/chat/${chatID ?? 'new'}',
        queryParameters: {
          'task_id': taskID,
          'model': model,
          'column': column,
          'message': message
        });

    return response.data;
  }

  static String generateCurlCommandForPipeline(List<MosaicPipelineStep> steps) {
    final parameters = getPipelineParameters(steps, '');
    final jsonBody = jsonEncode(parameters);
    return "curl -X POST ${serverURL}/task/run -H 'Content-Type: application/json' -d '$jsonBody'";
  }

  static Future<String> getPipelineID(
      List<MosaicPipelineStep> steps, Map<String, dynamic> settings) {
    final newSettings = Map<String, dynamic>.from(settings);
    if (newSettings.containsKey('pipeline')) {
      newSettings.remove('pipeline');
    }

    final parameters = getPipelineParameters(steps, '');

    parameters.addAll(newSettings);
    final jsonBody = jsonEncode(parameters);

    print(jsonBody);
    return _savePipeline(jsonBody);
  }

  static String getPipelineJSON(
      List<MosaicPipelineStep> steps, Map<String, dynamic> settings) {
    final newSettings = Map<String, dynamic>.from(settings);
    if (newSettings.containsKey('pipeline')) {
      newSettings.remove('pipeline');
    }

    final parameters = getPipelineParameters(steps, '');
    parameters.addAll(newSettings);

    return jsonEncode(parameters);
  }

  static Future<List<MosaicPipelineStep>> getPipelineStateFromID(
      String pipelineID) async {
    // ======== DUPLICATE CODE
    final pipelineInfo = await getPipelineInfo();
    final Map<String, MosaicPipelineStep> allSteps = {};
    pipelineInfo.keys.forEach((key) {
      final parameters = Map.from(pipelineInfo[key]['parameters']);
      final parameterDescriptions = <String, MosaicPipelineStepParameter>{};
      for (final parameter in parameters.entries) {
        final p = MosaicPipelineStepParameter(
            title: parameter.value['title'], type: parameter.value['type']);

        if (parameter.value.containsKey('description'))
          p.description = parameter.value['description'];

        if (parameter.value.containsKey('enforce-limit'))
          p.enforceLimit = parameter.value['enforce-limit'];

        if (parameter.value.containsKey('required'))
          p.required = parameter.value['required'];

        if (parameter.value.containsKey('supported-values'))
          p.supportedValues =
              List<String>.from(parameter.value['supported-values']);

        if (parameter.value.containsKey('default'))
          p.defaultValue = parameter.value['default'];

        parameterDescriptions[parameter.key] = p;
      }

      final category = pipelineInfo[key]['category'];
      final step = MosaicPipelineStep(pipelineInfo[key]['name'], category,
          pipelineInfo[key]['description'], key, parameterDescriptions);

      allSteps[key] = step;
    });
    // ======== END DUPLICATE CODE

    final dio = Dio();
    final response =
        (await dio.get(serverURL + '/pipeline/restore/$pipelineID')).data;

    Map<String, dynamic> pipeline = response['pipeline'];
    List<MosaicPipelineStep> steps = [];

    for (int i = 1; i <= pipeline.length; i++) {
      if (pipeline.containsKey('$i')) {
        final step = pipeline['$i'];

        if (allSteps.containsKey(step['id'])) {
          final newStep = MosaicPipelineStep.clone(allSteps[step['id']]!);

          newStep.parameterData = Map.from(step['parameters']);
          steps.add(newStep);
        } else {
          print('Pipeline step not found: ${step['id']}');
        }
      } else {
        break;
      }
    }

    return steps;
  }

  static Future<List<MosaicPipelineStep>> getPipelineStateFromJSON(
      String jsonData) async {
    // ======== DUPLICATE CODE
    final pipelineInfo = await getPipelineInfo();
    final Map<String, MosaicPipelineStep> allSteps = {};
    pipelineInfo.keys.forEach((key) {
      final parameters = Map.from(pipelineInfo[key]['parameters']);
      final parameterDescriptions = <String, MosaicPipelineStepParameter>{};
      for (final parameter in parameters.entries) {
        final p = MosaicPipelineStepParameter(
            title: parameter.value['title'], type: parameter.value['type']);

        if (parameter.value.containsKey('description'))
          p.description = parameter.value['description'];

        if (parameter.value.containsKey('enforce-limit'))
          p.enforceLimit = parameter.value['enforce-limit'];

        if (parameter.value.containsKey('required'))
          p.required = parameter.value['required'];

        if (parameter.value.containsKey('supported-values'))
          p.supportedValues =
              List<String>.from(parameter.value['supported-values']);

        if (parameter.value.containsKey('default'))
          p.defaultValue = parameter.value['default'];

        parameterDescriptions[parameter.key] = p;
      }

      final category = pipelineInfo[key]['category'];
      final step = MosaicPipelineStep(pipelineInfo[key]['name'], category,
          pipelineInfo[key]['description'], key, parameterDescriptions);

      allSteps[key] = step;
    });
    // ======== END DUPLICATE CODE

    final data = jsonDecode(jsonData);

    Map<String, dynamic> pipeline = data['pipeline'];
    List<MosaicPipelineStep> steps = [];

    for (int i = 1; i <= pipeline.length; i++) {
      if (pipeline.containsKey('$i')) {
        final step = pipeline['$i'];

        if (allSteps.containsKey(step['id'])) {
          final newStep = MosaicPipelineStep.clone(allSteps[step['id']]!);

          newStep.parameterData = Map.from(step['parameters']);
          steps.add(newStep);
        } else {
          print('Pipeline step not found: ${step['id']}');
        }
      } else {
        break;
      }
    }

    return steps;
  }
}
