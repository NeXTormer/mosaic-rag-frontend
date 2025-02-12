import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
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
}
