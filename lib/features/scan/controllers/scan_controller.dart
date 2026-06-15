import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../services/scan_service.dart';
import '../../transaksi/services/transaksi_service.dart'; // Impor service transaksi baru

class ScanController extends ChangeNotifier {
  final ScanService _scanService = ScanService();
  final TransaksiService _transaksiService = TransaksiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // State untuk memantau loading ketika tombol "Tambah ke Keranjang" ditekan
  bool _isActionLoading = false;
  bool get isActionLoading => _isActionLoading;

  String? _scannedCode;
  String? get scannedCode => _scannedCode;

  // Tempat menampung data JSON produk dari Laravel
  Map<String, dynamic>? _produkData;
  Map<String, dynamic>? get produkData => _produkData;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Tempat menampung Kode Transaksi Otomatis (TR-xxxx) yang sinkron dengan Vue.js
  String _transaksiId = "Memuat data...";
  String get transaksiId => _transaksiId;

  /// Fungsi Utama saat Barcode Terdeteksi Kamera
  Future<bool> handleBarcodeScanned(String code) async {
    if (_isLoading) return false;

    _isLoading = true;
    _scannedCode = code;
    _produkData = null;
    _errorMessage = null;
    _transaksiId = "Memuat data..."; // Set status memuat data awal
    notifyListeners();

    // 1. Verifikasi barcode produk ke server via ScanService
    final result = await _scanService.verifikasiBarcode(code);

    if (result != null) {
      if (result['status'] == true) {
        _produkData =
            result; // Menyimpan seluruh struktur JSON (status, message, data)

        // 2. SINKRONISASI LOGIC: Ambil atau buat nomor kode transaksi secara otomatis
        await sinkronisasiKodeTransaksi();

        _isLoading = false;
        notifyListeners();
        return true; // Berhasil, trigger View untuk tampilkan modal detail
      } else {
        _errorMessage = result['message'] ?? 'Produk tidak ditemukan.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    }

    _errorMessage = 'Gagal memuat data dari server.';
    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Fungsi Sinkronisasi Kode Transaksi (Meniru Persis Alur fetchKodeTransaksi Vue.js)
  Future<void> sinkronisasiKodeTransaksi() async {
    try {
      final detailResponse = await _transaksiService.getTransaksiDetail();

      // Mengantisipasi apakah data dari Laravel langsung berupa List atau dibungkus object 'data'
      final List<dynamic> keranjangItems = detailResponse.data is List
          ? detailResponse.data
          : (detailResponse.data['data'] ?? []);

      if (keranjangItems.isNotEmpty) {
        // Logic Sync: Jika di keranjang sudah ada barang, bajak kode transaksi dari item pertama
        _transaksiId = keranjangItems[0]['kode'];
      } else {
        // Jika keranjang kosong, minta nomor TR-xxxx otomatis baru dari backend Laravel
        final codeResponse = await _transaksiService.getKodeTransaksi();
        _transaksiId = codeResponse.data['kode'] ?? "ERR-GENERATE";
      }
    } catch (e) {
      _transaksiId = "ERR-GENERATE";
    }
  }

  /// Logika untuk Tombol "Tambah ke Keranjang" di Modal Detail
  Future<bool> tambahKeKeranjang() async {
    // Validasi awal kode transaksi
    if (_transaksiId.isEmpty ||
        _transaksiId.contains("Memuat") ||
        _transaksiId == "ERR-GENERATE") {
      throw "Tunggu kode transaksi selesai dimuat";
    }

    final product = _produkData?['data'];
    if (product == null) {
      throw "Data produk tidak ditemukan, silakan scan ulang";
    }

    _isActionLoading = true;
    notifyListeners();

    try {
      // Susun Payload gabungan yang lolos aturan $request->validate() di Laravel Anda
      final Map<String, dynamic> payload = {
        'kode': _transaksiId,
        'kodeproduk': product['kodeproduk'],
        'harga': product['harga']?['harga'] ?? 0,
        'berat': product['berat'] ?? 0,
        'karat': product['karat']?['karat'] ?? 0,
        'lingkar': product['lingkar'] ?? 0,
        'panjang': product['panjang'] ?? 0,
      };

      // Kirim data ke TransaksiDetail di Laravel
      final response = await _transaksiService.storeProdukToTransaksiDetail(
        payload,
      );

      if (response.data['status'] != true) {
        throw response.data['message'] ??
            'Gagal menambahkan produk ke keranjang';
      }

      return true;
    } on DioException catch (e) {
      final String serverMessage =
          e.response?.data['message'] ??
          "Gagal menambahkan produk ke keranjang";

      throw serverMessage;
    } finally {
      _isActionLoading = false;
      notifyListeners();
    }
  }

  /// Reset State ketika Modal Detail ditutup
  void resetScan() {
    _scannedCode = null;
    _produkData = null;
    _errorMessage = null;
    _isLoading = false;
    _isActionLoading = false;
    _transaksiId = "Memuat data...";
    notifyListeners();
  }
}
