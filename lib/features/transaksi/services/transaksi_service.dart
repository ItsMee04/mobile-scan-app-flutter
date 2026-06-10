import 'package:dio/dio.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/session_service.dart'; // Tambahkan impor SessionService

class TransaksiService {
  final ApiClient _apiClient = ApiClient();

  // 1. GET '/transaksi/getKodeTransaksi'
  Future<Response> getKodeTransaksi() async {
    final token = await SessionService.getToken();
    return await _apiClient.dio.get(
      '/transaksi/getKodeTransaksi',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        validateStatus: (status) => status! < 500,
      ),
    );
  }

  // 2. GET '/transaksi/getTransaksiDetail'
  Future<Response> getTransaksiDetail() async {
    final token = await SessionService.getToken();
    return await _apiClient.dio.get(
      '/transaksi/getTransaksiDetail',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        validateStatus: (status) => status! < 500,
      ),
    );
  }

  // 3. POST '/transaksi/storeProdukToTransaksiDetail'
  Future<Response> storeProdukToTransaksiDetail(
    Map<String, dynamic> payload,
  ) async {
    try {
      final token = await SessionService.getToken();
      return await _apiClient.dio.post(
        '/transaksi/storeProdukToTransaksiDetail',
        data: payload,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status! < 500,
        ),
      );
    } on DioException {
      rethrow;
    }
  }
}
