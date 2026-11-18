
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/article_model.dart';
import '../services/api_service.dart';
import '../services/favorite_service.dart';

class DetailScreen extends StatefulWidget {
  final Article article;

  const DetailScreen({
    super.key,
    required this.article,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<Article> futureDetail;

  @override
  void initState() {
    super.initState();

    futureDetail = ApiService.fetchDetail(
      widget.article.category,
      widget.article.id,
    );
  }

  String formatDate(String value) {
    try {
      final date = DateTime.parse(value).toLocal();
      return DateFormat('dd MMMM yyyy, HH:mm').format(date);
    } catch (_) {
      return value.isEmpty ? 'Tanggal tidak tersedia' : value;
    }
  }

  Future<void> openWebsite(String url) async {
    final uri = Uri.tryParse(url);

    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('URL artikel tidak valid'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat membuka website'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal membuka website'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Artikel'),
        actions: [
          AnimatedBuilder(
            animation: FavoriteService.instance,
            builder: (context, child) {
              final favorite =
                  FavoriteService.instance.contains(widget.article);

              return IconButton(
                icon: Icon(
                  favorite ? Icons.favorite : Icons.favorite_border,
                  color: favorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  FavoriteService.instance.toggle(widget.article);
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Article>(
        future: futureDetail,
        builder: (context, snapshot) {
          final article = snapshot.data ?? widget.article;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: article.imageUrl.isNotEmpty
                        ? Image.network(
                            article.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                color: Colors.grey.shade300,
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 60,
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey.shade300,
                            child: const Icon(
                              Icons.image,
                              size: 60,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5865F2),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'Author: ${article.author}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Published: ${formatDate(article.publishedAt)}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  article.summary.isEmpty
                      ? 'Ringkasan tidak tersedia.'
                      : article.summary,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: article.url.isEmpty
                        ? null
                        : () => openWebsite(article.url),
                    icon: const Icon(Icons.open_in_browser),
                    label: const Text('Buka Website Resmi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5865F2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(14),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
