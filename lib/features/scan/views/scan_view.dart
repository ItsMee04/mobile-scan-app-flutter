import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/services/api_client.dart'; // Impor ApiClient untuk mengambil baseUrl Anda
import '../components/scan_header.dart';
import '../components/scan_tips.dart';
import '../controllers/scan_controller.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  final MobileScannerController cameraController = MobileScannerController(
    formats: [BarcodeFormat.code128],
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  // Helper untuk format Rupiah
  String formatRupiah(dynamic number) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(number ?? 0);
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _showResultSheet(BuildContext context, String code) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return Consumer<ScanController>(
          builder: (context, scanController, child) {
            final product = scanController.produkData?['data'];

            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              child: scanController.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    )
                  : Column(
                      children: [
                        // Header Detail Produk
                        _buildHeader(
                          context,
                          product?['kodeproduk'] ?? code,
                          scanController,
                        ),

                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 1. Gambar Produk Langsung dari Backend Laravel
                                _buildProductImage(product?['kodeproduk']),

                                const SizedBox(height: 20),

                                // 2. Nama & Kode Produk
                                Text(
                                  product?['nama'] ?? 'Produk Tidak Dikenal',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Kode: ${product?['kodeproduk'] ?? code}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),

                                const SizedBox(height: 25),

                                // 3. Spesifikasi Produk (Grid)
                                const Text(
                                  'Spesifikasi Produk',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                _buildSpecGrid(product),

                                const SizedBox(height: 25),

                                // 4. Harga Section
                                _buildPriceCard(product),

                                const SizedBox(height: 30),

                                // 5. Tombol Aksi
                                _buildActionButtons(context, scanController),

                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            );
          },
        );
      },
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget _buildHeader(
    BuildContext context,
    String code,
    ScanController controller,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: const BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              controller.resetScan();
              cameraController.start();
            },
          ),
          const Text(
            'Detail Produk',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Komponen Pengambilan Gambar dari Storage Backend Laravel
  Widget _buildProductImage(String? kodeproduk) {
    final baseUrl = ApiClient().dio.options.baseUrl.replaceAll('/api', '');
    final fullImageUrl = "$baseUrl/storage/images/produk/$kodeproduk.png";

    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: kodeproduk != null && kodeproduk.isNotEmpty
            ? Image.network(
                fullImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[100],
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: Icon(Icons.image_outlined, size: 50, color: Colors.grey),
              ),
      ),
    );
  }

  Widget _buildSpecGrid(Map<String, dynamic>? product) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 2.5,
      children: [
        _buildSpecItem(
          Icons.scale_outlined,
          'Berat',
          '${product?['berat'] ?? 0}g',
        ),
        _buildSpecItem(
          Icons.workspace_premium_outlined,
          'Karat',
          '${product?['karat']?['karat'] ?? 0}K',
        ),
        _buildSpecItem(
          Icons.straighten_outlined,
          'Panjang',
          '${product?['panjang'] ?? 0} cm',
        ),
        _buildSpecItem(
          Icons.ads_click_outlined,
          'Lingkar',
          '${product?['lingkar'] ?? 0} cm',
        ),
      ],
    );
  }

  Widget _buildSpecItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 24),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard(Map<String, dynamic>? product) {
    final hargaGram = product?['harga']?['harga'] ?? 0;
    final berat = double.tryParse(product?['berat'].toString() ?? '0') ?? 0;
    final totalHarga = hargaGram * berat;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Harga per Gram', style: TextStyle(fontSize: 14)),
              Text(
                formatRupiah(hargaGram),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: Colors.orange),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Harga',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                formatRupiah(totalHarga),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ScanController controller) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            onPressed: controller.isActionLoading
                ? null
                : () async {
                    try {
                      final success = await controller.tambahKeKeranjang();
                      if (success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Produk berhasil ditambahkan ke keranjang.',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                        controller.resetScan();
                        cameraController.start();
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.all(16),
                          ),
                        );
                      }
                    }
                  },
            icon: controller.isActionLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            label: Text(
              controller.isActionLoading
                  ? 'Menambahkan...'
                  : 'Tambah ke Keranjang',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              controller.resetScan();
              cameraController.start();
            },
            icon: const Icon(Icons.qr_code_scanner, color: Colors.orange),
            label: const Text(
              'Scan Produk Lain',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.orange),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final scanController = context.read<ScanController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Column(
        children: [
          const ScanHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B).withAlpha(153),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFFF9100).withAlpha(128),
                        width: 2,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        MobileScanner(
                          controller: cameraController,
                          onDetect: (capture) async {
                            final List<Barcode> barcodes = capture.barcodes;
                            if (barcodes.isNotEmpty &&
                                barcodes.first.rawValue != null) {
                              final String code = barcodes.first.rawValue!;
                              final currentContext = context;
                              await cameraController.stop();
                              if (!currentContext.mounted) return;
                              _showResultSheet(currentContext, code);
                              await scanController.handleBarcodeScanned(code);
                            }
                          },
                        ),
                        Center(
                          child: Container(
                            width: 260,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFFF9100),
                                width: 2.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const ScanTips(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
