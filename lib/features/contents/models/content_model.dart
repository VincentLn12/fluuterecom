import '../../../app/config/api_config.dart';

class ContentCategory {
  final String id;
  final String name;
  final String? description;

  ContentCategory({required this.id, required this.name, this.description});

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

class SubDistrict {
  final String id;
  final String name;

  SubDistrict({required this.id, required this.name});

  factory SubDistrict.fromJson(Map<String, dynamic> json) {
    return SubDistrict(
      id: json['subDistrictId']?.toString() ?? json['id']?.toString() ?? '',
      name: json['subDistrictName']?.toString() ?? json['name']?.toString() ?? '',
    );
  }
}

class ContentShopOption {
  final String id;
  final String name;

  ContentShopOption({required this.id, required this.name});

  factory ContentShopOption.fromJson(Map<String, dynamic> json) {
    return ContentShopOption(
      id: json['shopId']?.toString() ?? json['id']?.toString() ?? '',
      name: json['shopName']?.toString() ?? json['name']?.toString() ?? '',
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
  final String? subDistrictId;
  final String? subDistrictName;
  final String? shopId;
  final String? shopName;
  final double? latitude;
  final double? longitude;
  final int viewCount;
  final double rating;
  final List<String> tags;
  final String? publishedAt;
  final String? status;

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
    this.subDistrictId,
    this.subDistrictName,
    this.shopId,
    this.shopName,
    this.latitude,
    this.longitude,
    this.viewCount = 0,
    this.rating = 5.0,
    this.tags = const [],
    this.publishedAt,
    this.status = 'Published',
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    var rawTags = json['tags'];
    List<String> parsedTags = [];
    if (rawTags is List) {
      parsedTags = rawTags
          .map((e) {
            if (e is Map) {
              return e['tagName']?.toString() ?? e['name']?.toString() ?? '';
            }
            return e.toString();
          })
          .where((t) => t.isNotEmpty)
          .toList();
    }

    double? parseCoord(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString());
    }

    String? resolveUrl(dynamic val) {
      if (val == null) return null;
      String str = val.toString().trim();
      if (str.isEmpty) return null;
      if (str.startsWith('http://') || str.startsWith('https://')) {
        return str;
      }
      if (str.startsWith('/')) {
        return ApiConfig.baseUrl.replaceAll('/api', '') + str;
      }
      return '${ApiConfig.baseUrl.replaceAll('/api', '')}/$str';
    }

    return ContentModel(
      id: json['contentId']?.toString() ?? json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'ไม่มีชื่อเรื่อง',
      description:
          json['description']?.toString() ?? json['summary']?.toString(),
      body:
          json['content']?.toString() ??
          json['body']?.toString() ??
          json['details']?.toString(),
      coverImageUrl: resolveUrl(json['coverImageUrl'] ?? json['imageUrl']),
      youtubeUrl: json['youtubeUrl']?.toString(),
      categoryId:
          json['contentCategoryId']?.toString() ??
          json['categoryId']?.toString(),
      categoryName:
          json['categoryName']?.toString() ??
          json['category']?['categoryName']?.toString(),
      districtId: json['districtId']?.toString(),
      districtName:
          json['districtName']?.toString() ??
          json['district']?['districtName']?.toString(),
      subDistrictId: json['subDistrictId']?.toString(),
      subDistrictName: json['subDistrictName']?.toString(),
      shopId: json['shopId']?.toString(),
      shopName: json['shopName']?.toString(),
      latitude: parseCoord(json['latitude']),
      longitude: parseCoord(json['longitude']),
      viewCount: int.tryParse(json['viewCount']?.toString() ?? '0') ?? 0,
      rating: double.tryParse(json['rating']?.toString() ?? '5.0') ?? 5.0,
      tags: parsedTags,
      publishedAt:
          json['publishedAt']?.toString() ?? json['createdAt']?.toString(),
      status: json['status']?.toString() ?? 'Published',
    );
  }

  String get statusLabel {
    final s = status?.trim() ?? '';
    if (s.toLowerCase() == 'pending') return 'รอตรวจสอบ';
    if (s.toLowerCase() == 'archived' || s.toLowerCase() == 'draft') {
      return 'เก็บถาวร';
    }
    return 'เผยแพร่แล้ว';
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

class ContentSchedule {
  final String scheduleId;
  final String title;
  final String? startDateTime;
  final String? endDateTime;
  final String? address;
  final String? description;

  ContentSchedule({
    required this.scheduleId,
    required this.title,
    this.startDateTime,
    this.endDateTime,
    this.address,
    this.description,
  });

  factory ContentSchedule.fromJson(Map<String, dynamic> json) {
    return ContentSchedule(
      scheduleId: json['scheduleId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      startDateTime: json['startDateTime']?.toString(),
      endDateTime: json['endDateTime']?.toString(),
      address: json['address']?.toString(),
      description: json['description']?.toString(),
    );
  }
}

class ContentShopProduct {
  final String productId;
  final String shopId;
  final String? shopName;
  final String productName;
  final String? description;
  final double price;
  final String? imageUrl;

  ContentShopProduct({
    required this.productId,
    required this.shopId,
    this.shopName,
    required this.productName,
    this.description,
    required this.price,
    this.imageUrl,
  });

  factory ContentShopProduct.fromJson(Map<String, dynamic> json) {
    String? resolveUrl(dynamic val) {
      if (val == null) return null;
      String str = val.toString().trim();
      if (str.isEmpty) return null;
      if (str.startsWith('http://') || str.startsWith('https://')) {
        return str;
      }
      if (str.startsWith('/')) {
        return ApiConfig.baseUrl.replaceAll('/api', '') + str;
      }
      return '${ApiConfig.baseUrl.replaceAll('/api', '')}/$str';
    }

    return ContentShopProduct(
      productId: json['productId']?.toString() ?? '',
      shopId: json['shopId']?.toString() ?? '',
      shopName: json['shopName']?.toString(),
      productName: json['productName']?.toString() ?? 'สินค้าชุมชน',
      description: json['description']?.toString(),
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      imageUrl: resolveUrl(json['imageUrl'] ?? json['coverImageUrl']),
    );
  }
}

class ContentReview {
  final String reviewId;
  final String userName;
  final String comment;
  final String? createdAt;
  final double rating;

  ContentReview({
    required this.reviewId,
    required this.userName,
    required this.comment,
    this.createdAt,
    this.rating = 5.0,
  });

  factory ContentReview.fromJson(Map<String, dynamic> json) {
    return ContentReview(
      reviewId: json['reviewId']?.toString() ?? '',
      userName: json['userName']?.toString() ?? 'ผู้ใช้งานกาญจนบุรี',
      comment: json['comment']?.toString() ?? '',
      createdAt: json['createdAt']?.toString(),
      rating: double.tryParse(json['rating']?.toString() ?? '5.0') ?? 5.0,
    );
  }
}
