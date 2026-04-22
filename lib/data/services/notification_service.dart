import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationService {
  // Init tetap ada tapi kosong (biar tidak error di main.dart)
  static Future<void> init() async {
    // Tidak melakukan apa-apa, hanya untuk kompatibilitas
    debugPrint('NotificationService initialized (mock mode)');
  }

  // Notifikasi hanya berupa snackbar (tanpa notifikasi lokal)
  static Future<void> showTicketNotification(String title, String body, {int? ticketId}) async {
    // Hanya tampilkan snackbar, tidak perlu notifikasi lokal
    Get.snackbar(
      title,
      body,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      backgroundColor: Get.isDarkMode ? Colors.grey[800] : Colors.grey[200],
      colorText: Get.isDarkMode ? Colors.white : Colors.black,
    );
    debugPrint('Notifikasi: $title - $body (Ticket ID: $ticketId)');
  }
}