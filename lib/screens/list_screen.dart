
import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../services/api_service.dart';
import '../services/favorite_service.dart';
import '../widgets/article_card.dart';
import 'detail_screen.dart';
import 'favorite_screen.dart';

class ListScreen extends StatefulWidget {
  final String category;

  const ListScreen({
    super.key,
    required this.category,
  });

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late Future<List<Article>> futureArticles;
  String selectedAuthor = 'Semua';

  @override
  void initState() {
    super.initState();
    futureArticles = ApiService.fetchArticles(widget.category);
  }

  void reload() {
    setState(() {
      selectedAuthor = 'Semua';
      futureArticles = ApiService.fetchArticles(widget.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
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
      body: FutureBuilder<List<Article>>(
        future: futureArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Gagal memuat data artikel'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: reload,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final articles = snapshot.data ?? [];

          if (articles.isEmpty) {
            return const Center(
              child: Text('Belum ada artikel'),
            );
          }

          final authors = articles
              .map((article) => article.author)
              .where((author) => author.isNotEmpty)
              .toSet()
              .toList()
            ..sort();

          final filteredArticles = selectedAuthor == 'Semua'
              ? articles
              : articles
                  .where((a) => a.author == selectedAuthor)
                  .toList();

          return Column(
            children: [
              SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  children: [
                    ChoiceChip(
                      label: const Text('Semua'),
                      selected: selectedAuthor == 'Semua',
                      selectedColor: const Color(0xFF5865F2),
                      labelStyle: TextStyle(
                        color: selectedAuthor == 'Semua'
                            ? Colors.white
                            : Colors.black,
                      ),
                      onSelected: (_) {
                        setState(() {
                          selectedAuthor = 'Semua';
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    ...authors.map((author) {
                      final selected = selectedAuthor == author;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(author),
                          selected: selected,
                          selectedColor: const Color(0xFF5865F2),
                          labelStyle: TextStyle(
                            color: selected
                                ? Colors.white
                                : Colors.black,
                          ),
                          onSelected: (_) {
                            setState(() {
                              selectedAuthor = author;
                            });
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),

              Expanded(
                child: filteredArticles.isEmpty
                    ? const Center(
                        child: Text('Tidak ada artikel untuk author ini'),
                      )
                    : ListView.builder(
                        itemCount: filteredArticles.length,
                        itemBuilder: (context, index) {
                          final article = filteredArticles[index];

                          return AnimatedBuilder(
                            animation: FavoriteService.instance,
                            builder: (context, child) {
                              final isFavorite =
                                  FavoriteService.instance.contains(article);

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
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    FavoriteService.instance.toggle(article);
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
