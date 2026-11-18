
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

class ApiService {
  static const String baseUrl =
      'https://api.spaceflightnewsapi.net/v4';

  static String getEndpoint(String category) {
    switch (category.toLowerCase()) {
      case 'blog':
      case 'blogs':
        return 'blogs';
      case 'report':
      case 'reports':
        return 'reports';
      case 'article':
      case 'articles':
      case 'news':
      default:
        return 'articles';
    }
  }

  static Future<List<Article>> fetchArticles(
    String category,
  ) async {
    final endpoint = getEndpoint(category);

    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint/'),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data API');
    }

    final decoded = jsonDecode(response.body);
    final List results =
        decoded is List ? decoded : decoded['results'] ?? [];

    return results
        .map((item) => Article.fromJson(item, endpoint))
        .toList();
  }

  static Future<Article> fetchDetail(
    String category,
    int id,
  ) async {
    final endpoint = getEndpoint(category);

    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint/$id/'),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil detail artikel');
    }

    return Article.fromJson(
      jsonDecode(response.body),
      endpoint,
    );
  }
}
