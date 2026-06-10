import 'package:flutter/material.dart';

class ScanHeader extends StatelessWidget {
  // Konstruktor kelas utama tetap boleh const
  const ScanHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 25, left: 20, right: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF9100), Color(0xFFFF5500)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        // PENTING: Pastikan di depan kata 'Column' ini BERSIH dari kata 'const'
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            // Tambahkan const di sini karena teks ini statis
            'Scan Barcode',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4), // Tambahkan const di sini
          Text(
            'Arahkan kamera ke barcode C128',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(
                alpha: 0.9,
              ), // Properti ini dinamis (Runtime), jadi aman tanpa const di atasnya
            ),
          ),
        ],
      ),
    );
  }
}
