import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/business.dart';

class BusinessRepository {
  static const String _assetPath = 'assets/data/buffalo_businesses.json';
  static List<Business>? _cache;

  static Future<List<Business>> loadBusinesses() async {
    if (_cache != null) return _cache!;
    final String jsonString = await rootBundle.loadString(_assetPath);
    final Map<String, dynamic> decoded =
        jsonDecode(jsonString) as Map<String, dynamic>;
    final List<dynamic> rawBusinesses =
        decoded['businesses'] as List<dynamic>? ?? <dynamic>[];
    _cache = rawBusinesses
        .map((dynamic row) => Business.fromJson(row as Map<String, dynamic>))
        .toList();
    return _cache!;
  }

  /// For tests: set an in-memory cache of businesses
  static void setCache(List<Business>? cache) {
    _cache = cache;
  }
}
