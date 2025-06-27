// lib/models/asset_batch.dart
import 'package:flutter/material.dart';

// === Centralized Constants ===
const Color kMaroon = Color(0xFF800000);

// === Centralized AssetBatch Model ===
// This class represents a single asset batch with its details.
class AssetBatch {
  final String? id; // Optional ID, typically from backend for CRUD operations
  final String batchNo;
  final String title;
  final List<String> assets;

  AssetBatch({
    this.id,
    required this.batchNo,
    required this.title,
    required this.assets,
  });

  // // Uncomment this section when ready for API integration
  // // Factory constructor to create an AssetBatch instance from a JSON map.
  // factory AssetBatch.fromJson(Map<String, dynamic> json) {
  //   return AssetBatch(
  //     id: json['id'] as String?, // Assuming 'id' field from API
  //     batchNo: json['batchNo'] as String,
  //     title: json['title'] as String,
  //     // Ensure assets is a List<String>, handle null or incorrect types from JSON.
  //     assets: (json['assets'] as List<dynamic>?)
  //             ?.map((e) => e.toString())
  //             .toList() ??
  //         [],
  //   );
  // }

  // // Uncomment this section when ready for API integration
  // // Converts an AssetBatch instance to a JSON map, typically for sending to an API.
  // Map<String, dynamic> toJson() {
  //   return {
  //     // 'id' is typically not sent for POST (backend generates it), but might be for PUT/PATCH if required.
  //     // If your API needs 'id' in the body for updates, uncomment this: 'id': id,
  //     'batchNo': batchNo,
  //     'title': title,
  //     'assets': assets,
  //   };
  // }
}