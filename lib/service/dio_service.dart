import 'package:dio/dio.dart';

class DioService {
  late final Dio _dio;

  DioService() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://baconipsum.com/',
    ));
  }

  static DioService instance = DioService();

  Dio get service => _dio;
}
