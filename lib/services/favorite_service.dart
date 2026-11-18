import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article_model.dart';

class FavoriteService extends ChangeNotifier {
  static final FavoriteService instance = FavoriteService._();

  FavoriteService._();

  static late SharedPreferences prefs;

  final Map<String, Article> _favorites = {};

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();

    final data = prefs.getString('favorite_articles');

    if (data != null) {
      try {
        final List list = jsonDecode(data);

        for (final item in list) {
          final article = Article.fromStoredJson(
            Map<String, dynamic>.from(item),
          );

          instance._favorites[article.key] = article;
        }
      } catch (_) {}
    }
  }

  List<Article> get items => _favorites.values.toList();

  bool contains(Article article) {
    return _favorites.containsKey(article.key);
  }

  Future<void> toggle(Article article) async {
    if (contains(article)) {
      _favorites.remove(article.key);
    } else {
      _favorites[article.key] = article;
    }

    await save();
    notifyListeners();
  }

  Future<void> remove(Article article) async {
    _favorites.remove(article.key);

    await save();
    notifyListeners();
  }

  Future<void> save() async {
    final data = _favorites.values
        .map((article) => article.toJson())
        .toList();

    await prefs.setString(
      'favorite_articles',
      jsonEncode(data),
    );
  }
}