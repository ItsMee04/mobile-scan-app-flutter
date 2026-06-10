import 'package:flutter/material.dart';
import '../services/dashboard_service.dart';

class DashboardController extends ChangeNotifier {
  final DashboardService _dashboardService = DashboardService();

  // Penampung data Harga Emas bawaan Anda
  List<dynamic> _goldPrices = [];
  List<dynamic> get goldPrices => _goldPrices;

  // --- VARIABEL BARU UNTUK 4 CARD STATISTIK ---
  int _totalPelanggan = 0;
  int _totalProduk = 0;
  int _totalPenjualan = 0;
  int _totalPembelian = 0;

  // Getter deklarasi langsung agar bisa dibaca reaktif oleh UI Component
  int get totalPelanggan => _totalPelanggan;
  int get totalProduk => _totalProduk;
  int get totalPenjualan => _totalPenjualan;
  int get totalPembelian => _totalPembelian;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadHargaEmas() async {
    // Sesuai rule: Hanya pemicu loading jika seluruh data di memori benar-benar masih kosong
    if (_goldPrices.isEmpty &&
        _totalPelanggan == 0 &&
        _totalProduk == 0 &&
        _totalPenjualan == 0 &&
        _totalPembelian == 0) {
      _isLoading = true;
      notifyListeners(); // Memberitahu UI untuk menampilkan "Memuat data..."
    }

    try {
      // Menggunakan Future.wait agar ke-5 API dari service ditembak bersamaan (paralel)
      final results = await Future.wait([
        _dashboardService.fetchHargaEmas(),
        _dashboardService.fetchTotalPelanggan(),
        _dashboardService.fetchTotalProduk(),
        _dashboardService.fetchTotalPenjualanHariIni(),
        _dashboardService.fetchTotalPembelianHariIni(),
      ]);

      // Memetakan hasil urutan array Future.wait ke masing-masing variabel
      _goldPrices = results[0] as List<dynamic>;
      _totalPelanggan = results[1] as int;
      _totalProduk = results[2] as int;
      _totalPenjualan = results[3] as int;
      _totalPembelian = results[4] as int;
    } catch (e) {
      // Menangkap error agar aplikasi tidak crash dan status loading tetap bisa dimatikan
      debugPrint("Error saat memuat data dashboard: $e");
    } finally {
      // Blok finally AKAN SELALU DIEKSEKUSI baik saat sukses maupun error
      _isLoading = false;
      notifyListeners(); // Memberitahu UI bahwa loading selesai dan saatnya render data asli
    }
  }
}
