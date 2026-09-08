import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../contents/models/content_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/shop_model.dart';

class ShopRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<List<ShopCategory>> fetchShopCategories() async {
    try {
      final response = await _apiClient.get(
        '/shop-categories',
        query: {'page': '1', 'pageSize': '100'},
      );
      if (response.isOk && response.body != null) {
        final data = response.body;
        List items = [];
        if (data is Map && data.containsKey('items') && data['items'] is List) {
          items = data['items'] as List;
        } else if (data is List) {
          items = data;
        }
        return items
            .map((e) => ShopCategory.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching shop categories: $e');
    }
    return [];
  }

  Future<List<District>> fetchDistricts() async {
    try {
      final response = await _apiClient.get('/locations/districts');
      if (response.isOk && response.body != null) {
        final data = response.body;
        List items = [];
        if (data is List) {
          items = data;
        } else if (data is Map &&
            data.containsKey('items') &&
            data['items'] is List) {
          items = data['items'] as List;
        }
        return items
            .map((e) => District.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching districts: $e');
    }
    return [];
  }

  Future<List<ShopModel>> fetchShops({
    String? search,
    String? categoryId,
    String? districtId,
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final query = <String, String>{
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };
      if (search != null && search.trim().isNotEmpty) {
        query['search'] = search.trim();
      }
      if (categoryId != null && categoryId.isNotEmpty) {
        query['categoryId'] = categoryId;
      }
      if (districtId != null && districtId.isNotEmpty) {
        query['districtId'] = districtId;
      }

      final response = await _apiClient.get('/shops', query: query);
      if (response.isOk && response.body != null) {
        final data = response.body;
        List items = [];
        if (data is Map && data.containsKey('items') && data['items'] is List) {
          items = data['items'] as List;
        } else if (data is List) {
          items = data;
        }
        return items
            .map((e) => ShopModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching shops: $e');
    }
    return [];
  }

  Future<ShopModel?> fetchShopById(String id) async {
    try {
      final response = await _apiClient.get('/shops/$id');
      if (response.isOk && response.body != null) {
        final data = response.body;
        if (data is Map<String, dynamic>) {
          return ShopModel.fromJson(data);
        }
      }
    } catch (e) {
      debugPrint('Error fetching shop by id: $e');
    }
    return null;
  }

  Future<List<ProductModel>> fetchProducts({
    String? shopId,
    String? search,
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final query = <String, String>{
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };
      if (shopId != null && shopId.isNotEmpty) {
        query['shopId'] = shopId;
      }
      if (search != null && search.trim().isNotEmpty) {
        query['search'] = search.trim();
      }

      final response = await _apiClient.get('/products', query: query);
      if (response.isOk && response.body != null) {
        final data = response.body;
        List items = [];
        if (data is Map && data.containsKey('items') && data['items'] is List) {
          items = data['items'] as List;
        } else if (data is List) {
          items = data;
        }
        final list = items
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
        if (shopId != null && shopId.isNotEmpty) {
          return list
              .where((p) => p.shopId.toLowerCase() == shopId.toLowerCase())
              .toList();
        }
        return list;
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
    }
    return [];
  }

  Future<ProductModel?> fetchProductById(String id) async {
    try {
      final response = await _apiClient.get('/products/$id');
      if (response.isOk && response.body != null) {
        final data = response.body;
        if (data is Map<String, dynamic>) {
          return ProductModel.fromJson(data);
        }
      }
    } catch (e) {
      debugPrint('Error fetching product by id: $e');
    }
    return null;
  }
}
