import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/session_service.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final ApiClient _apiClient = ApiClient();

  // Fungsi sekarang mengembalikan String? (null jika sukses, berisi pesan error jika gagal)
  Future<String?> login({
    required String username,
    required String password,
    required FocusNode usernameFocus,
    required FocusNode passwordFocus,
  }) async {
    if (username.trim().isEmpty) {
      usernameFocus.requestFocus();
      return 'Email tidak boleh kosong!';
    }

    if (password.trim().isEmpty) {
      passwordFocus.requestFocus();
      return 'Password tidak boleh kosong!';
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.dio.post(
        '/login',
        data: {'email': username.trim(), 'password': password},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final token = response.data['access_token'];
        final userData = response.data['user'];

        // Simpan sesi secara lokal
        await SessionService.saveSession(token, userData);

        _isLoading = false;
        notifyListeners();
        return null; // Return null artinya SUKSES (tidak ada error)
      }

      _isLoading = false;
      notifyListeners();
      return 'Gagal melakukan autentikasi';
    } on DioException catch (e) {
      _isLoading = false;
      notifyListeners();

      if (e.response != null && e.response?.data != null) {
        return e.response?.data['message'] ?? 'Terjadi kesalahan autentikasi';
      }
      return 'Tidak dapat terhubung ke server. Periksa koneksi atau IP .env Anda.';
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'Terjadi kesalahan sistem: $e';
    }
  }
}
