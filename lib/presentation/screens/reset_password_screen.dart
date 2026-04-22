import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_service.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final AuthService _authService = AuthService();
  final emailController = TextEditingController();
  final isLoading = false.obs;

  Future<void> resetPassword() async {
    if (emailController.text.isEmpty) {
      Get.snackbar('Error', 'Email harus diisi');
      return;
    }
    isLoading.value = true;
    try {
      await _authService.resetPassword(emailController.text);
      isLoading.value = false;
      Get.snackbar('Sukses', 'Link reset password telah dikirim ke email Anda');
      Get.back();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Icon(Icons.lock_reset, size: 80, color: Theme.of(context).primaryColor),
            const SizedBox(height: 20),
            const Text('Lupa Password?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Masukkan email Anda, kami akan mengirimkan link untuk reset password', textAlign: TextAlign.center),
            const SizedBox(height: 30),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            Obx(() => ElevatedButton(
              onPressed: isLoading.value ? null : resetPassword,
              child: isLoading.value
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Kirim Link Reset'),
            )),
          ],
        ),
      ),
    );
  }
}