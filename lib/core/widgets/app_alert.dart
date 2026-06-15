import 'dart:async';
import 'package:flutter/material.dart';

class AppAlert {
  static Future<void> success(
    BuildContext context, {
    required String message,
    String title = 'Berhasil',
    int duration = 2,
    VoidCallback? onOk, // ✅ TAMBAHKAN INI
  }) {
    return _show(
      context,
      title: title,
      message: message,
      icon: Icons.check_circle,
      iconColor: Colors.green,
      duration: duration,
    );
  }

  static Future<void> error(
    BuildContext context, {
    required String message,
    String title = 'Gagal',
    int duration = 3,
  }) {
    return _show(
      context,
      title: title,
      message: message,
      icon: Icons.error,
      iconColor: Colors.red,
      duration: duration,
    );
  }

  static Future<void> _show(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
    required int duration,
  }) async {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder:
          (
            BuildContext dialogContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            Timer(Duration(seconds: duration), () {
              if (Navigator.canPop(dialogContext)) {
                Navigator.pop(dialogContext);
              }
            });

            return Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: 320,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: iconColor, size: 70),
                      const SizedBox(height: 16),

                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(message, textAlign: TextAlign.center),

                      const SizedBox(height: 20),

                      const LinearProgressIndicator(),
                    ],
                  ),
                ),
              ),
            );
          },
      transitionBuilder:
          (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1).animate(animation),
                child: child,
              ),
            );
          },
    );
  }
}
