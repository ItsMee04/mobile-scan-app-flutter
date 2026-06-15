import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'session_service.dart';

class ApiClient {
  final Dio _dio = Dio();

  // 1. NavigatorKey global untuk mengatur perpindahan halaman tanpa BuildContext
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // 2. ScaffoldMessengerKey global untuk menampilkan SnackBar tanpa BuildContext
  static final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();

  ApiClient() {
    // Mengambil base URL dari file .env
    final baseUrl = dotenv.env['API_URL'] ?? 'http://192.168.1.215/api';

    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    // Tambahkan Interceptor untuk mendeteksi status 401 (Force Logout)
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // Hapus sesi lokal di HP Android via SessionService
            await SessionService.logout();

            // Pindah halaman menggunakan navigatorState langsung
            final navigatorState = navigatorKey.currentState;
            if (navigatorState != null) {
              navigatorState.pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
            }

            // PERBAIKAN FINAL: Menampilkan SnackBar menggunakan snackbarKey global
            // Cara ini murni tanpa menyentuh properti '.context' atau 'BuildContext' sama sekali
            final snackbarState = snackbarKey.currentState;
            if (snackbarState != null) {
              snackbarState.showSnackBar(
                const SnackBar(
                  content: Text(
                    'Sesi Anda berakhir. Akun ini telah login di perangkat lain.',
                  ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  // Getter untuk mengakses instance Dio
  Dio get dio => _dio;
}
