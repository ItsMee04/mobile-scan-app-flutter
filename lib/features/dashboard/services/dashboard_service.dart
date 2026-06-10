import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/session_service.dart';

class DashboardService {
  final ApiClient _apiClient = ApiClient();

  // 1. Ambil Harga Emas (Lama)
  Future<List<dynamic>> fetchHargaEmas() async {
    try {
      String? token = await SessionService.getToken();

      final response = await _apiClient.dio.get(
        '/dashboard/getHargaEmas',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      developer.log(
        'Status Code Harga Emas: ${response.statusCode}',
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
      developer.log(
        'Gagal memuat harga emas',
        error: e,
        stackTrace: stackTrace,
        name: 'dashboard.service',
      );
      return [];
    }
  }

  // 2. Ambil Total Pelanggan
  Future<int> fetchTotalPelanggan() async {
    try {
      String? token = await SessionService.getToken();

      final response = await _apiClient.dio.get(
        '/dashboard/getTotalPelanggan',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      developer.log(
        'Status Code Total Pelanggan: ${response.statusCode}',
        name: 'dashboard.service',
      );

      if (response.data is Map) {
        final dataResponse = response.data as Map<String, dynamic>;

        if (dataResponse['status'] == true && dataResponse['data'] != null) {
          return int.tryParse(dataResponse['data'].toString()) ?? 0;
        }
      }

      return 0;
    } catch (e, stackTrace) {
      developer.log(
        'Gagal memuat total pelanggan',
        error: e,
        stackTrace: stackTrace,
        name: 'dashboard.service',
      );
      return 0;
    }
  }

  // 3. Ambil Total Produk
  Future<int> fetchTotalProduk() async {
    try {
      String? token = await SessionService.getToken();

      final response = await _apiClient.dio.get(
        '/dashboard/getProduk',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      developer.log(
        'Status Code Total Produk: ${response.statusCode}',
        name: 'dashboard.service',
      );

      if (response.data is Map) {
        final dataResponse = response.data as Map<String, dynamic>;

        if (dataResponse['status'] == true && dataResponse['data'] != null) {
          return int.tryParse(dataResponse['data'].toString()) ?? 0;
        }
      }

      return 0;
    } catch (e, stackTrace) {
      developer.log(
        'Gagal memuat total produk',
        error: e,
        stackTrace: stackTrace,
        name: 'dashboard.service',
      );
      return 0;
    }
  }

  // 4. Ambil Total Penjualan Hari Ini
  Future<int> fetchTotalPenjualanHariIni() async {
    try {
      String? token = await SessionService.getToken();

      final response = await _apiClient.dio.get(
        '/dashboard/getTotalPenjualanHariIni',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      developer.log(
        'Status Code Penjualan Hari Ini: ${response.statusCode}',
        name: 'dashboard.service',
      );

      if (response.data is Map) {
        final dataResponse = response.data as Map<String, dynamic>;

        if (dataResponse['status'] == true && dataResponse['data'] != null) {
          return int.tryParse(dataResponse['data'].toString()) ?? 0;
        }
      }

      return 0;
    } catch (e, stackTrace) {
      developer.log(
        'Gagal memuat total penjualan hari ini',
        error: e,
        stackTrace: stackTrace,
        name: 'dashboard.service',
      );
      return 0;
    }
  }

  // 5. Ambil Total Pembelian Hari Ini
  Future<int> fetchTotalPembelianHariIni() async {
    try {
      String? token = await SessionService.getToken();

      final response = await _apiClient.dio.get(
        '/dashboard/getTotalPembelianHariIni',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      developer.log(
        'Status Code Pembelian Hari Ini: ${response.statusCode}',
        name: 'dashboard.service',
      );

      if (response.data is Map) {
        final dataResponse = response.data as Map<String, dynamic>;

        if (dataResponse['status'] == true && dataResponse['data'] != null) {
          return int.tryParse(dataResponse['data'].toString()) ?? 0;
        }
      }

      return 0;
    } catch (e, stackTrace) {
      developer.log(
        'Gagal memuat total pembelian hari ini',
        error: e,
        stackTrace: stackTrace,
        name: 'dashboard.service',
      );
      return 0;
    }
  }
}
