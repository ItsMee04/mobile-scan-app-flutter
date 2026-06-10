import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _tokenKey = 'access_token';
  static const String _userKey = 'user_data';

  // Menyimpan token dan data user setelah sukses login
  static Future<void> saveSession(
    String token,
    Map<String, dynamic> userData,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(userData));
  }

  // Mengambil token yang tersimpan
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Mengambil data user yang tersimpan
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString(_userKey);
    if (userStr != null) {
      return jsonDecode(userStr) as Map<String, dynamic>;
    }
    return null;
  }

  // Mengecek apakah user sudah login atau belum (untuk auto-login)
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Hapus sesi saat logout
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // Tambahkan atau pastikan fungsi ini ada di dalam class SessionService Anda
  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(
      'user_data',
    ); // Sesuai nama key saat saveSession kemarin

    if (userDataString != null) {
      final Map<String, dynamic> user = jsonDecode(userDataString);
      return user['nama'] ?? 'User';
    }
    return 'User';
  }
}
