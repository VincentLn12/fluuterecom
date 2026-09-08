class ContentCategory {
  final String id;
  final String name;
  final String? description;

  ContentCategory({
    required this.id,
    required this.name,
    this.description,
  });

  factory ContentCategory.fromJson(Map<String, dynamic> json) {
    return ContentCategory(
      id: json['contentCategoryId']?.toString() ?? json['id']?.toString() ?? '',
      name: json['categoryName']?.toString() ?? json['name']?.toString() ?? '',
      description: json['description']?.toString(),
    );
  }
}

class District {
  final String id;
  final String name;

  District({required this.id, required this.name});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['districtId']?.toString() ?? json['id']?.toString() ?? '',
      name: json['districtName']?.toString() ?? json['name']?.toString() ?? '',
    );
  }
}

class ContentModel {
  final String id;
  final String title;
  final String? description;
  final String? body;
  final String? coverImageUrl;
  final String? youtubeUrl;
  final String? categoryId;
  final String? categoryName;
  final String? districtId;
  final String? districtName;
  final String? subDistrictName;
  final String? shopId;
  final String? shopName;
  final double? latitude;
  final double? longitude;
  final int viewCount;
  final double rating;
  final List<String> tags;
  final String? publishedAt;

  ContentModel({
    required this.id,
    required this.title,
    this.description,
    this.body,
    this.coverImageUrl,
    this.youtubeUrl,
    this.categoryId,
    this.categoryName,
    this.districtId,
    this.districtName,
    this.subDistrictName,
    this.shopId,
    this.shopName,
    this.latitude,
    this.longitude,
    this.viewCount = 0,
    this.rating = 5.0,
    this.tags = const [],
    this.publishedAt,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    var rawTags = json['tags'];
    List<String> parsedTags = [];
    if (rawTags is List) {
      parsedTags = rawTags.map((e) {
        if (e is Map) return e['tagName']?.toString() ?? e['name']?.toString() ?? '';
        return e.toString();
      }).where((t) => t.isNotEmpty).toList();
    }

    double? parseCoord(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString());
    }

    return ContentModel(
      id: json['contentId']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'ไม่มีชื่อเรื่อง',
      description: json['description']?.toString() ?? json['summary']?.toString(),
      body: json['content']?.toString() ?? json['body']?.toString() ?? json['details']?.toString(),
      coverImageUrl: json['coverImageUrl']?.toString() ?? json['imageUrl']?.toString(),
      youtubeUrl: json['youtubeUrl']?.toString(),
      categoryId: json['contentCategoryId']?.toString() ?? json['categoryId']?.toString(),
      categoryName: json['categoryName']?.toString() ?? json['category']?['categoryName']?.toString(),
      districtId: json['districtId']?.toString(),
      districtName: json['districtName']?.toString() ?? json['district']?['districtName']?.toString(),
      subDistrictName: json['subDistrictName']?.toString(),
      shopId: json['shopId']?.toString(),
      shopName: json['shopName']?.toString(),
      latitude: parseCoord(json['latitude']),
      longitude: parseCoord(json['longitude']),
      viewCount: int.tryParse(json['viewCount']?.toString() ?? '0') ?? 0,
      rating: double.tryParse(json['rating']?.toString() ?? '5.0') ?? 5.0,
      tags: parsedTags,
      publishedAt: json['publishedAt']?.toString() ?? json['createdAt']?.toString(),
    );
  }

  String get youtubeThumbnail {
    if (youtubeUrl == null || youtubeUrl!.isEmpty) return '';
    try {
      final uri = Uri.parse(youtubeUrl!);
      String? videoId;
      if (uri.host.contains('youtu.be')) {
        videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      } else {
        videoId = uri.queryParameters['v'];
      }
      if (videoId != null && videoId.isNotEmpty) {
        return 'https://i.ytimg.com/vi/$videoId/hqdefault.jpg';
      }
    } catch (_) {}
    return '';
  }
}
