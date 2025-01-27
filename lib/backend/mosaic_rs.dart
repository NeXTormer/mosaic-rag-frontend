import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mosaic_rs_application/backend/result_list.dart';
import 'package:mosaic_rs_application/backend/task_progress.dart';

class MosaicRS {
  static final serverURL =
      false ? 'https://mosaicrs-api.felixholz.com' : 'http://127.0.0.1:5000';
  static Future<ResultList> search(String query) async {
    final dio = Dio();
    final response = await dio.get(serverURL + '/search?q=' + query);

    return ResultList.fromJSON(response.data);
  }

  static Future<String> enqueueTask(Map<String, dynamic> parameters) async {
    print(parameters);
    final dio = Dio();
    final response = await dio.post(serverURL + '/task/enqueue',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(parameters));
    print("TaskID: ${response.data}");
    return response.data as String;
  }

  static Future<TaskProgress> getTaskProgress(String taskID) async {
    final dio = Dio();
    print("Getting task progress");
    final response = await dio.get(serverURL + '/task/progress/$taskID');

    return TaskProgress.fromJSON(response.data);
  }

  static Future<void> cancelTask(String taskID) async {
    final dio = Dio();
    final response = await dio.get(serverURL + '/task/cancel/$taskID');
  }

  static Future<ResultList> runPipeline(Map<String, dynamic> parameters) async {
    final dio = Dio();
    final response = await dio.post(serverURL + '/pipeline/run',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(parameters));

    return ResultList.fromJSON(response.data);
  }

  static Future<Map<String, dynamic>> getPipelineInfo() async {
    final dio = Dio();
    final response = await dio.get(serverURL + '/pipeline/info');

    return response.data;
  }
}
