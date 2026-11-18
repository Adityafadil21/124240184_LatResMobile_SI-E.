
import 'package:flutter/material.dart';
import '../services/favorite_service.dart';
import '../widgets/article_card.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite'),
      ),
      body: AnimatedBuilder(
        animation: FavoriteService.instance,
        builder: (context, child) {
          final favorites = FavoriteService.instance.items;

          if (favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text('Belum ada artikel favorit'),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final article = favorites[index];

              return ArticleCard(
                article: article,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(
                        article: article,
                      ),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    FavoriteService.instance.remove(article);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
