import 'package:flutter/material.dart';
import '../services/scan_service.dart';

class ScanController extends ChangeNotifier {
  final ScanService _scanService = ScanService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _scannedCode;
  String? get scannedCode => _scannedCode;

  // Tempat menampung data JSON produk dari Laravel
  Map<String, dynamic>? _produkData;
  Map<String, dynamic>? get produkData => _produkData;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> handleBarcodeScanned(String code) async {
    if (_isLoading) return false;

    _isLoading = true;
    _scannedCode = code;
    _produkData = null;
    _errorMessage = null;
    notifyListeners();

    final result = await _scanService.verifikasiBarcode(code);

    _isLoading = false;
    notifyListeners();

    if (result != null) {
      // Jika status true, simpan seluruh object data JSON produk dari Laravel
      if (result['status'] == true) {
        _produkData =
            result; // Menyimpan seluruh struktur JSON (status, message, data)
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'] ?? 'Produk tidak ditemukan.';
        notifyListeners();
        return false;
      }
    }

    _errorMessage = 'Gagal memuat data dari server.';
    notifyListeners();
    return false;
  }

  void resetScan() {
    _scannedCode = null;
    _produkData = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
