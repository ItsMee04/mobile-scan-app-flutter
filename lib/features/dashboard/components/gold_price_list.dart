import 'package:flutter/material.dart';

class GoldPriceList extends StatelessWidget {
  final List<dynamic> goldPrices;

  const GoldPriceList({super.key, required this.goldPrices});

  // DIUBAH: Menggunakan deklarasi fungsi langsung (Function Declaration)
  String formatRupiah(dynamic number) {
    if (number == null) return 'Rp 0';
    String valueString = number.toString();
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

    // Perbaikan linter: Fungsi di dalam fungsi dideklarasikan langsung, bukan diisi ke variabel
    String matchFunc(Match match) => '${match[1]}.';

    return 'Rp ${valueString.replaceAllMapped(reg, matchFunc)}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Harga Emas Hari Ini',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 15),
            if (goldPrices.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'Tidak ada data harga emas tersedia.',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: goldPrices.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 25, color: Color(0xFFF0F0F0)),
                itemBuilder: (context, index) {
                  final item = goldPrices[index];

                  final String karat =
                      item['karat']?['karat']?.toString() ?? '-';
                  final String jenis =
                      item['jeniskarat']?['jenis']?.toString() ?? '';
                  final dynamic hargaRaw = item['harga'];

                  final String title = 'Emas $karat Karat';
                  final String subTitle = 'Jenis: $jenis';
                  final String priceFormatted = formatRupiah(
                    hargaRaw,
                  ); // Dipanggil di sini

                  return _buildItem(title, subTitle, priceFormatted);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String title, String subTitle, String price) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF5E6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.card_giftcard_rounded,
            color: Color(0xFFFF7B00),
            size: 24,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Text(
                subTitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        Text(
          price,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Color(0xFFFF7B00),
          ),
        ),
      ],
    );
  }
}
