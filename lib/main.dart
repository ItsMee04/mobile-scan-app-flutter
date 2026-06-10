import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'features/authentication/controllers/auth_controller.dart';
import 'layouts/main_layout.dart';
import 'features/authentication/views/login_view.dart';
import 'features/dashboard/controllers/dashboard_controller.dart';
import 'features/scan/controllers/scan_controller.dart';
import 'core/services/session_service.dart';
import 'core/services/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Gagal memuat file .env: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(create: (_) => ScanController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isCheckingSession = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkUserSession();
  }

  Future<void> _checkUserSession() async {
    final loggedIn = await SessionService.isLoggedIn();
    setState(() {
      _isLoggedIn = loggedIn;
      _isCheckingSession = false; // Proses cek sesi selesai
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trifecta Scan App',
      debugShowCheckedModeBanner: false,

      // Daftarkan kedua key global dari ApiClient di sini
      navigatorKey: ApiClient.navigatorKey,
      scaffoldMessengerKey: ApiClient.snackbarKey, // <- Tambahkan baris ini

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF7B00)),
        useMaterial3: true,
      ),
      home: _isCheckingSession
          ? const Scaffold(
              backgroundColor: Color(0xFFFDF5E6),
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFFFF7B00)),
              ),
            )
          : (_isLoggedIn ? const MainLayout() : const LoginView()),
      routes: {
        '/login': (context) => const LoginView(),
        '/dashboard': (context) => const MainLayout(),
      },
    );
  }
}
