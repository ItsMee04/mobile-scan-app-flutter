import 'package:flutter/material.dart';
import '../../../core/services/session_service.dart';
import '../components/profile_header.dart';
import '../components/profile_info.dart';
import '../services/profile_service.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final profileService = ProfileService();

    return FutureBuilder<List<String>>(
      // Mengambil ke-4 data session secara paralel dari SharedPreferences
      future: Future.wait([
        SessionService.getUserName(), // index 0
        SessionService.getUserEmail(), // index 1
        SessionService.getUserKontak(), // index 2
        SessionService.getUserAlamat(), // index 3
      ]),
      builder: (context, snapshot) {
        // Tampilkan loading jika data session sedang dibaca
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFFDF5E6),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFFF7B00)),
            ),
          );
        }

        // Petakan hasil snapshot ke variabel lokal
        final List<String> userData = snapshot.data ?? ['Admin', '-', '-', '-'];
        final String currentUserName = userData[0];
        final String currentUserEmail = userData[1];
        final String currentUserKontak = userData[2];
        final String currentUserAlamat = userData[3];

        return Scaffold(
          backgroundColor: const Color(0xFFFDF5E6),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // 1. Komponen Header (Nama & Email Dinamis)
                ProfileHeader(name: currentUserName, email: currentUserEmail),

                const SizedBox(
                  height: 120,
                ), // Spasi penyeimbang posisi stack card atas
                // 2. Komponen Informasi Pribadi (Dinamis dari Response Login)
                ProfileInfo(
                  email: currentUserEmail,
                  phone: currentUserKontak, // Mengambil data kontak
                  location: currentUserAlamat, // Mengambil data alamat
                ),

                const SizedBox(height: 20),

                // 3. Tombol Keluar Tunggal
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    leading: const Icon(
                      Icons.logout_rounded,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Keluar',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                    onTap: () async {
                      final success = await profileService.logoutUser();
                      if (success && context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        );
      },
    );
  }
}
