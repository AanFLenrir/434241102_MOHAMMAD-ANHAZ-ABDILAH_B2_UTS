import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;
  var obscurePassword = true.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Email dan password harus diisi', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isLoading.value = true;
    try {
      await _authService.login(emailController.text, passwordController.text);
      Get.offAllNamed('/dashboard');
      Get.snackbar('Sukses', 'Login berhasil', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Login Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void toggleObscure() => obscurePassword.value = !obscurePassword.value;
  void goToRegister() => Get.toNamed('/register');
  void goToResetPassword() => Get.toNamed('/reset-password');

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}