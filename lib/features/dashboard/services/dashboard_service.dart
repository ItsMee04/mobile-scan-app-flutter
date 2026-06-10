import 'dart:developer'
    as developer; // <- Menggunakan framework logging bawaan Dart
import 'package:dio/dio.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/session_service.dart';

class DashboardService {
  final ApiClient _apiClient = ApiClient();

  Future<List<dynamic>> fetchHargaEmas() async {
    try {
      String? token = await SessionService.getToken();

      final response = await _apiClient.dio.get(
        '/dashboard/getHargaEmas',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Menggunakan framework logging yang aman dan otomatis disembunyikan saat mode rilis/produksi
      developer.log(
        'Status Code: ${response.statusCode}',
        name: 'dashboard.service',
      );

      if (response.data is Map) {
        final dataResponse = response.data as Map<String, dynamic>;

        if (dataResponse['success'] == true && dataResponse['data'] != null) {
          return dataResponse['data'] as List<dynamic>;
        }
      }

      return [];
    } catch (e, stackTrace) {
      // Merekam error beserta stack trace secara rapi menggunakan logging framework
      developer.log(
        'Gagal memuat harga emas',
        error: e,
        stackTrace: stackTrace,
        name: 'dashboard.service',
      );
      return [];
    }
  }
}
