import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static String? get currentUsername =>
      prefs.getString('logged_in_username');

  static Map<String, dynamic> get users {
    final data = prefs.getString('registered_users');

    if (data == null) return {};

    try {
      return Map<String, dynamic>.from(jsonDecode(data));
    } catch (_) {
      return {};
    }
  }

  static Future<String?> register(
    String username,
    String password,
  ) async {
    username = username.trim();

    if (username.isEmpty || password.isEmpty) {
      return 'Username dan password wajib diisi';
    }

    if (username.length < 4 || password.length < 4) {
      return 'Minimal 4 karakter';
    }

    final data = users;

    if (data.containsKey(username)) {
      return 'Username sudah terdaftar';
    }

    data[username] = password;

    await prefs.setString(
      'registered_users',
      jsonEncode(data),
    );

    return null;
  }

  static Future<String?> login(
    String username,
    String password,
  ) async {
    username = username.trim();

    if (username.isEmpty || password.isEmpty) {
      return 'Username dan password wajib diisi';
    }

    final data = users;

    if (!data.containsKey(username) ||
        data[username] != password) {
      return 'Username atau password salah';
    }

    await prefs.setString(
      'logged_in_username',
      username,
    );

    return null;
  }

  static Future<void> logout() async {
    await prefs.remove('logged_in_username');
  }
}