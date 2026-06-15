import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <- Tambahkan ini
import '../controllers/auth_controller.dart'; // <- Tambahkan ini
import '../../../core/widgets/app_alert.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 1. Inisialisasi FocusNode untuk fitur auto-focus saat validasi gagal
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    // Bersihkan node dan controller saat halaman ditutup agar tidak bocor memorinya
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 2. Hubungkan ke AuthController (Sama seperti memanggil store/composable di Vue)
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo TS Orange
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7B00),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        'TS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Trifecta Solutions',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const Text(
                    'Barcode Scanner System',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),

                  // Input Username (Dipasang FocusNode)
                  _buildInputField(
                    label: 'Username',
                    hint: 'Enter your username',
                    controller: _usernameController,
                    focusNode: _usernameFocus,
                  ),
                  const SizedBox(height: 20),

                  // Input Password (Dipasang FocusNode)
                  _buildInputField(
                    label: 'Password',
                    hint: 'Enter your password',
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    isPassword: true,
                  ),
                  const SizedBox(height: 30),

                  // Tombol Login dengan Indikator Loading Reaktif
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      // Jika sedang loading, matikan tombol (onPressed: null)
                      onPressed: authController.isLoading
                          ? null
                          : () async {
                              // Panggil login tanpa melempar context
                              String? errorMessage = await authController.login(
                                username: _usernameController.text,
                                password: _passwordController.text,
                                usernameFocus: _usernameFocus,
                                passwordFocus: _passwordFocus,
                              );

                              // Cek guard mounted di level View (sangat aman & disukai linter)
                              if (!context.mounted) return;

                              if (errorMessage != null) {
                                // Jika ada pesan error, tampilkan di atas
                                await AppAlert.error(
                                  context,
                                  message: errorMessage,
                                );
                              } else {
                                // Jika null, berarti sukses!
                                await AppAlert.success(
                                  context,
                                  message: 'Login Berhasil!',
                                );
                                if (!context.mounted) return;
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/dashboard',
                                );
                                // Nanti: Navigator.pushReplacementNamed(context, '/dashboard');
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7B00),
                        disabledBackgroundColor: const Color(
                          0xFFFFB366,
                        ), // Warna orange pudar saat loading
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      // Tampilkan animasi putar jika sedang loading, tampilkan teks jika tidak
                      child: authController.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.login, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode, // Tambahkan parameter focusNode
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          focusNode: focusNode, // Pasangkan ke TextField native Flutter
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}
