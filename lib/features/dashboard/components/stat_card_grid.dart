import 'package:flutter/material.dart';

class StatCardGrid extends StatelessWidget {
  const StatCardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 1.4,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        children: [
          _buildCard(
            Icons.inventory_2_outlined,
            Colors.blue,
            'Total Produk',
            '124',
          ),
          _buildCard(
            Icons.people_outline_rounded,
            Colors.green,
            'Total Pelanggan',
            '8',
          ),
          _buildCard(
            Icons.trending_up_rounded,
            Colors.orange,
            'Total Penjualan Hari Ini',
            '15',
          ),
          _buildCard(
            Icons.history_toggle_off_rounded,
            Colors.purple,
            'Total Pembelian Hari Ini',
            '3',
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    IconData icon,
    Color iconColor,
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
