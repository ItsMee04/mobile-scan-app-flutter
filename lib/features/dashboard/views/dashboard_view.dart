import 'dart:async'; // <- Tambahkan import Timer
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/session_service.dart';
import '../controllers/dashboard_controller.dart';
import '../components/greeting_card.dart';
import '../components/stat_card_grid.dart';
import '../components/gold_price_list.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  Timer? _searchTimer; // <- Wadah untuk menyimpan timer

  @override
  void initState() {
    super.initState();
    _refreshData(); // Ambil data pertama kali

    // SET TIMING AUTOMATIC: Jalankan refresh data setiap 60 detik secara senyap
    _searchTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _refreshData();
    });
  }

  @override
  void dispose() {
    _searchTimer
        ?.cancel(); // <- WAJIB dihancurkan saat pindah halaman agar memori tidak bocor
    super.dispose();
  }

  Future<void> _refreshData() async {
    if (mounted) {
      await context.read<DashboardController>().loadHargaEmas();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardController = context.watch<DashboardController>();

    // Aturan baku: Tampilkan loading penuh HANYA saat data benar-benar masih kosong di awal
    if (dashboardController.isLoading &&
        dashboardController.goldPrices.isEmpty) {
      return _buildLoadingScreen();
    }

    return FutureBuilder<String>(
      future: SessionService.getUserName(),
      builder: (context, nameSnapshot) {
        if (nameSnapshot.connectionState == ConnectionState.waiting &&
            dashboardController.goldPrices.isEmpty) {
          return _buildLoadingScreen();
        }

        final String currentUserName = nameSnapshot.data ?? 'Admin';
        final List<dynamic> liveGoldPrices = dashboardController.goldPrices;

        // KUNCI REFRESH: Membungkus konten utama dengan RefreshIndicator
        return RefreshIndicator(
          color: const Color(0xFFFF7B00), // Warna panah loading putar
          backgroundColor: Colors.white,
          onRefresh:
              _refreshData, // Fungsi yang otomatis dijalankan saat ditarik ke bawah
          child: SingleChildScrollView(
            // physics wajib dipasang AlwaysScrollableScrollPhysics agar halaman
            // tetap bisa ditarik ke bawah meskipun datanya sedikit/pendek.
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Komponen Header & Greeting dengan nama dinamis
                GreetingCard(name: currentUserName),

                // Komponen Grid 4 Card Ringkasan Data
                const StatCardGrid(),

                // Komponen List Harga Emas Hari Ini
                GoldPriceList(goldPrices: liveGoldPrices),

                const SizedBox(height: 25),
              ],
            ),
          ),
        );
      },
    );
  }

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
