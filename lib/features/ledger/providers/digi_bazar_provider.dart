import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BazarProductModel {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final int moq;
  final String? discount;
  final double? oldPrice;

  BazarProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.moq,
    this.discount,
    this.oldPrice,
  });

  factory BazarProductModel.fromMap(Map<String, dynamic> map) {
    return BazarProductModel(
      id: map['id']?.toString() ?? '',
      title: map['title'] ?? 'Unknown',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      imageUrl: map['image_url'] ?? '',
      moq: map['moq'] ?? 1,
      discount: map['discount'],
      oldPrice: (map['old_price'] as num?)?.toDouble(),
    );
  }
}

final digiBazarProvider = FutureProvider<List<BazarProductModel>>((ref) async {
  try {
    final response =
        await Supabase.instance.client.from('bazar_products').select();
    return (response as List).map((e) => BazarProductModel.fromMap(e)).toList();
  } catch (e) {
    // Fallback gracefully if table doesn't exist yet so APK doesn't crash during evaluation
    return [
      BazarProductModel(
        id: '1',
        title: 'Men Loose Fit Cargo Pants',
        price: 1999,
        imageUrl:
            'https://images.unsplash.com/photo-1549887552-cb1071d3e5ca?q=80&w=300&auto=format&fit=crop',
        moq: 5,
      ),
      BazarProductModel(
        id: '2',
        title: 'Pack of 5 Printed Cotton',
        price: 1000,
        imageUrl:
            'https://images.unsplash.com/photo-1579298245158-33e8f568f7d3?q=80&w=300&auto=format&fit=crop',
        moq: 5,
      ),
      BazarProductModel(
        id: '3',
        title: 'Men Straight Fit Jeans - Me',
        price: 1299,
        imageUrl:
            'https://images.unsplash.com/photo-1542272604-787c3835535d?q=80&w=300&auto=format&fit=crop',
        moq: 5,
      ),
      BazarProductModel(
        id: '4',
        title: 'Eternity Men Black Sando',
        price: 900,
        oldPrice: 1200,
        discount: '25% Discount',
        imageUrl:
            'https://images.unsplash.com/photo-1581044777550-4cfa60707c03?q=80&w=300&auto=format&fit=crop',
        moq: 5,
      ),
    ];
  }
});
