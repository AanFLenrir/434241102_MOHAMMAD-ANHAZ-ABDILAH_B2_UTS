import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  Future<Map<String, dynamic>> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 1));
    if (password.length < 6) {
      throw Exception('Password minimal 6 karakter');
    }
    
    UserModel user;
    if (email.contains('admin')) {
      user = UserModel(id: 1, name: 'Admin User', email: email, role: 'admin');
    } else if (email.contains('helpdesk')) {
      user = UserModel(id: 2, name: 'Helpdesk Agent', email: email, role: 'helpdesk');
    } else {
      user = UserModel(id: 3, name: 'Regular User', email: email, role: 'user');
    }
    
    String dummyToken = 'dummy_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
    await _saveSession(dummyToken, user);
    return {'token': dummyToken, 'user': user};
  }

  Future<void> register(String name, String email, String password) async {
    await Future.delayed(Duration(seconds: 1));
    if (name.isEmpty || email.isEmpty || password.length < 6) {
      throw Exception('Data tidak valid');
    }
  }

  Future<void> resetPassword(String email) async {
    await Future.delayed(Duration(seconds: 1));
    if (email.isEmpty) throw Exception('Email wajib diisi');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey);
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      try {
        final Map<String, dynamic> map = jsonDecode(userJson);
        return UserModel.fromJson(map);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> _saveSession(String token, UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }
}