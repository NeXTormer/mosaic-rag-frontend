import 'package:dio/dio.dart';
import 'package:mosaic_rs_application/backend/result_list.dart';

class MosaicRS {
  static Future<ResultList> search(String query) async {
    final dio = Dio();
    final response = await dio.get('http://127.0.0.1:5000/search?q=' + query);

    return ResultList.fromJSON(response.data);
  }
}
