import 'dart:developer' as developer;
import '../../../core/services/session_service.dart';

class ProfileService {
  // Fungsi logout untuk menghapus sesi lokal
  Future<bool> logoutUser() async {
    try {
      final success = await SessionService.logout();
      developer.log(
        'User berhasil logout dari sistem',
        name: 'profile.service',
      );
      return success;
    } catch (e, stackTrace) {
      developer.log(
        'Gagal melakukan logout',
        error: e,
        stackTrace: stackTrace,
        name: 'profile.service',
      );
      return false;
    }
  }
}
