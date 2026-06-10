import 'package:flutter/material.dart';
import '../../../core/services/session_service.dart';
import '../services/dashboard_service.dart';
import '../components/greeting_card.dart';
import '../components/stat_card_grid.dart';
import '../components/gold_price_list.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardService = DashboardService();

    // 1. Ambil nama user terlebih dahulu dari lokal memori HP
    return FutureBuilder<String>(
      future: SessionService.getUserName(),
      builder: (context, nameSnapshot) {
        if (nameSnapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        }

        final String currentUserName = nameSnapshot.data ?? 'Admin';

        // 2. Bungkus area bawah dengan FutureBuilder kedua khusus untuk API Harga Emas
        return FutureBuilder<List<dynamic>>(
          future: dashboardService
              .fetchHargaEmas(), // Tembak API secara independen
          builder: (context, priceSnapshot) {
            // Sesuai rule: tampilkan "Memuat data..." saat API backend sedang dimuat
            if (priceSnapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingScreen();
            }

            // Ambil data asli dari backend, jika null pasang array kosong []
            final List<dynamic> liveGoldPrices = priceSnapshot.data ?? [];

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Komponen Header & Greeting dengan nama dinamis yang sudah sukses dibaca
                  GreetingCard(name: currentUserName),

                  // Komponen Grid 4 Card Ringkasan Data (Masih statis)
                  const StatCardGrid(),

                  // Komponen List Harga Emas Hari Ini (Data Asli Backend)
                  GoldPriceList(goldPrices: liveGoldPrices),

                  const SizedBox(height: 25),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Fungsi deklarasi langsung untuk widget loading screen biar tidak duplikasi kode
  Widget _buildLoadingScreen() {
    return const Scaffold(
      backgroundColor: Color(0xFFFDF5E6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFFF7B00)),
            SizedBox(height: 10),
            Text(
              'Memuat data...',
              style: TextStyle(
                color: Color(0xFFFF7B00),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
