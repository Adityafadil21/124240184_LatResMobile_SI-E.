
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'list_screen.dart';
import 'favorite_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({
    super.key,
    required this.username,
  });

  Widget menuCard(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: Icon(
          icon,
          color: const Color(0xFF8E24AA),
          size: 35,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ListScreen(category: title),
            ),
          );
        },
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await AuthService.logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halo, $username'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Favorite',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FavoriteScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 15),
            const Text(
              'Selamat Datang!',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5865F2),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pilih kategori berita yang ingin kamu baca.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),

            menuCard(
              context,
              'News',
              Icons.article,
            ),
            menuCard(
              context,
              'Blog',
              Icons.edit_document,
            ),
            menuCard(
              context,
              'Reports',
              Icons.description,
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () => logout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
