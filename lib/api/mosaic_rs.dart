import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mosaic_rs_application/state/mosaic_pipeline_step.dart';
import 'package:mosaic_rs_application/state/task_progress.dart';
import 'package:mosaic_rs_application/main.dart';

class MosaicRS {
  static final serverURL = kUseLocalMosaicRS
      ? 'http://127.0.0.1:5000'
      : 'https://mosaicrs-api.felixholz.com';

  static Future<String> enqueueTask(Map<String, dynamic> parameters) async {
    final dio = Dio();
    final response = await dio.post(serverURL + '/task/enqueue',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(parameters));
    print("TaskID: ${response.data}");
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
}
