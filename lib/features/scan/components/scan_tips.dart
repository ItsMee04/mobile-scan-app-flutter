import 'package:flutter/material.dart';

class ScanTips extends StatelessWidget {
  const ScanTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Text(
                'Tips Scanning',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            '• Pastikan pencahayaan cukup\n'
            '• Posisikan barcode di tengah frame\n'
            '• Jaga jarak 10-20cm dari kamera',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
}
