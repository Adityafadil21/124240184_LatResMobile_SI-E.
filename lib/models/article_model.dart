class Article {
  final int id;
  final String category;
  final String title;
  final String imageUrl;
  final String author;
  final String publishedAt;
  final String summary;
  final String url;

  Article({
    required this.id,
    required this.category,
    required this.title,
    required this.imageUrl,
    required this.author,
    required this.publishedAt,
    required this.summary,
    required this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json, String category) {
    String author = '';

    final authors = json['authors'];

    if (authors is List && authors.isNotEmpty) {
      author = authors.map((item) {
        if (item is Map) {
          return item['name']?.toString() ?? '';
        }
        return item.toString();
      }).where((e) => e.isNotEmpty).join(', ');
    }

    if (author.isEmpty) {
      author = (json['news_site'] ?? json['author'] ?? 'Unknown').toString();
    }

    return Article(
      id: int.tryParse('${json['id']}') ?? 0,
      category: category,
      title: json['title']?.toString() ?? 'Tanpa judul',
      imageUrl: json['image_url']?.toString() ?? '',
      author: author,
      publishedAt: json['published_at']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
    );
  }

  String get key => '${category}_$id';

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'title': title,
    'image_url': imageUrl,
    'author': author,
    'published_at': publishedAt,
    'summary': summary,
    'url': url,
  };

  factory Article.fromStoredJson(Map<String, dynamic> json) {
    return Article(
      id: int.tryParse('${json['id']}') ?? 0,
      category: json['category'] ?? 'articles',
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      author: json['author'] ?? '',
      publishedAt: json['published_at'] ?? '',
      summary: json['summary'] ?? '',
      url: json['url'] ?? '',
    );
  }
}