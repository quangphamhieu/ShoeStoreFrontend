import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;
  ApiClient({Dio? dio})
    : dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {"Content-Type": "application/json"},
            ),
          );

  Future<Response> get(String url, {Map<String, dynamic>? queryParameters}) =>
      dio.get(url, queryParameters: queryParameters);

  Future<Response> post(String url, dynamic data) => dio.post(url, data: data);

  Future<Response> postMultipart(String url, FormData formData) => dio.post(
    url,
    data: formData,
    options: Options(contentType: 'multipart/form-data'),
  );

  Future<Response> put(String url, dynamic data) => dio.put(url, data: data);

  Future<Response> putMultipart(String url, FormData formData) => dio.put(
    url,
    data: formData,
    options: Options(contentType: 'multipart/form-data'),
  );

  Future<Response> delete(String url) => dio.delete(url);
}
