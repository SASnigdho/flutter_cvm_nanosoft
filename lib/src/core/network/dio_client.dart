import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'api_url.dart';

@lazySingleton
class DioClient {
  late Dio _dio;

  DioClient() {
    _dio = Dio(BaseOptions(baseUrl: ApiUrl.base));
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      ),
    );
  }

  Future<Response> post(String path, {dynamic data, String? token}) async {
    return await _dio.post(
      path,
      data: data,
      options: Options(
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      ),
    );
  }
}
