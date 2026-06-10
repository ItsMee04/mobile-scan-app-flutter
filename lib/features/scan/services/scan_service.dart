import 'dart:developer' as developer;
import 'package:dio/dio.dart'; // Dibutuhkan untuk class Options
import '../../../core/services/session_service.dart'; // Pastikan path impor SessionService Anda benar
import '../../../core/services/api_client.dart';

class ScanService {
  final ApiClient _apiClient = ApiClient();

  // Fungsi untuk mengirimkan hasil scan ke backend Laravel dengan Token Resmi
  Future<Map<String, dynamic>?> verifikasiBarcode(String code) async {
    try {
      // 1. Ambil token secara resmi melalui SessionService
      final token = await SessionService.getToken();

      developer.log(
        'Mengirim request scan ke Laravel...',
        name: 'scan.service',
      );

      // 2. Kirim request dengan menyertakan token autentikasi
      final response = await _apiClient.dio.post(
        '/produk/getProdukByKode',
        data: {'kodeproduk': code},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          receiveDataWhenStatusError: true,
          // Mencegah interceptor global melempar error logout jika respons server 404/401/403
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      if (response.data != null) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e, stackTrace) {
      developer.log(
        'Gagal verifikasi barcode ke server',
        error: e,
        stackTrace: stackTrace,
        name: 'scan.service',
      );
      return null;
    }
  }
}
