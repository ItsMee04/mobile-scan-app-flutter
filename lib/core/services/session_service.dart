import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _tokenKey = 'access_token';
  static const String _userKey = 'user_data';

  // Menyimpan token dan data user setelah sukses login (Tetap dipertahankan utuh)
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

  // Hapus sesi saat logout (Membersihkan key utama Anda)
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // Mengambil Nama User (Sesuai kode Anda)
  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userKey);

    if (userDataString != null) {
      final Map<String, dynamic> user = jsonDecode(userDataString);
      return user['nama'] ?? 'User';
    }
    return 'User';
  }

  // --- TAMBAHKAN 3 FUNGSI GETTER BARU MEMBEDAH JSON ANDA ---

  // Mengambil Email User
  static Future<String> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userKey);

    if (userDataString != null) {
      final Map<String, dynamic> user = jsonDecode(userDataString);
      return user['email'] ?? '-';
    }
    return '-';
  }

  // Mengambil Kontak (Telepon) User
  static Future<String> getUserKontak() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userKey);

    if (userDataString != null) {
      final Map<String, dynamic> user = jsonDecode(userDataString);
      return user['kontak'] ?? '-';
    }
    return '-';
  }

  // Mengambil Alamat (Lokasi) User
  static Future<String> getUserAlamat() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userKey);

    if (userDataString != null) {
      final Map<String, dynamic> user = jsonDecode(userDataString);
      return user['alamat'] ?? '-';
    }
    return '-';
  }

  // Fungsi Logout dimodifikasi sedikit agar ikut membersihkan tokenKey & userKey asli Anda
  static Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();

    // Menghapus data token dan status login dari memori lokal HP sesuai key Anda
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);

    // Opsional: Tetap hapus key cadangan jika memang pernah terpakai di main.dart
    await prefs.remove('token');
    await prefs.remove('user_name');
    await prefs.remove('is_logged_in');

    return true;
  }
}
