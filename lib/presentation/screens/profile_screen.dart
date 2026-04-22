import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final AuthService _authService = AuthService();
  final isDarkMode = Get.isDarkMode.obs;

  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed('/login');
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: FutureBuilder(
        future: _authService.getCurrentUser(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          return ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(
                        user?.name[0].toUpperCase() ?? 'U',
                        style: const TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.name ?? 'User',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user?.email ?? 'email@example.com',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Chip(
                      label: Text(
                        user?.role ?? 'user',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: user?.role == 'admin'
                          ? Colors.red
                          : (user?.role == 'helpdesk' ? Colors.orange : Colors.blue),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.dark_mode),
                title: const Text('Mode Gelap'),
                trailing: Obx(() => Switch(
                  value: isDarkMode.value,
                  onChanged: (_) => toggleTheme(),
                )),
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifikasi'),
                trailing: Switch(value: true, onChanged: (_) {}),
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Riwayat Tiket'),
                onTap: () => Get.toNamed('/tickets'),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Tentang Aplikasi'),
                onTap: () {
                  Get.defaultDialog(
                    title: 'E-Ticketing Helpdesk',
                    content: const Text('Versi 1.0.0\nAplikasi untuk pelaporan dan monitoring tiket helpdesk IT.'),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Get.defaultDialog(
                    title: 'Logout',
                    middleText: 'Apakah Anda yakin ingin logout?',
                    onConfirm: () {
                      logout();
                      Get.back();
                    },
                    textConfirm: 'Ya',
                    textCancel: 'Batal',
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}