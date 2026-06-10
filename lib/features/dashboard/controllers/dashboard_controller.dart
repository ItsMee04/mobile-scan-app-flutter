import 'package:flutter/material.dart';
import '../services/dashboard_service.dart';

class DashboardController extends ChangeNotifier {
  final DashboardService _dashboardService = DashboardService();

  List<dynamic> _goldPrices = [];
  List<dynamic> get goldPrices => _goldPrices;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadHargaEmas() async {
    _isLoading = true;
    _errorMessage = null;
    // notifyListeners() bertindak seperti reaktivitas di Vue untuk memberi tahu UI agar render ulang
    notifyListeners();

    try {
      _goldPrices = await _dashboardService.fetchHargaEmas();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }
}
