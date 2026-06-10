import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  final Dio _dio = Dio();

  ApiClient() {
    // Mengambil base URL dari file .env
    final baseUrl = dotenv.env['API_URL'] ?? 'http://172.16.200.65:8000/api';

    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10), // Timeout 10 detik
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
  }

  // Getter untuk mengakses instance Dio
  Dio get dio => _dio;
}
