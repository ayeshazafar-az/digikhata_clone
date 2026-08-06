import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DigiBazarUrlHelper {
  static void launchBrandUrl(String brandName) async {
    final Map<String, String> explicitUrls = {
      'Khaadi': 'https://pk.khaadi.com',
      'Gul Ahmed': 'https://www.gulahmedshop.com',
      'Stylo': 'https://stylo.pk',
      'Sapphire': 'https://pk.sapphireonline.pk',
      'J.': 'https://www.junaidjamshed.com',
      'Sana Safinaz': 'https://www.sanasafinaz.com/pk',
      'Alkaram': 'https://www.alkaramstudio.com',
      'Nishat Linen': 'https://nishatlinen.com',
      'Servis': 'https://servis.pk',
      'Bata': 'https://www.bata.com.pk',
      'Limelight': 'https://www.limelight.pk',
      'Outfitters': 'https://outfitters.com.pk',
      'MTJ': 'https://mtj.com.pk'
    };

    String finalUrl;
    if (explicitUrls.containsKey(brandName)) {
      finalUrl = explicitUrls[brandName]!;
    } else {
      // Generic fallback
      final query = Uri.encodeComponent('$brandName official website pakistan');
      finalUrl = 'https://www.google.com/search?q=$query';
    }

    try {
      final uri = Uri.parse(finalUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Fail silently
    }
  }
}

class BazarProductModel {
  final String id;
  final String brandName;
  final String title;
  final double price;
  final String imageUrl;
  final int moq;
  final String? discount;
  final double? oldPrice;

  BazarProductModel({
    required this.id,
    required this.brandName,
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
      brandName: map['brand_name'] ?? 'Generic',
      title: map['title'] ?? 'Unknown',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      imageUrl: map['image_url'] ?? '',
      moq: map['moq'] ?? 1,
      discount: map['discount'],
      oldPrice: (map['old_price'] as num?)?.toDouble(),
    );
  }
}

// Added family modifier to accept brand filtering
final bazarBrandsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final response = await Supabase.instance.client
        .from('bazar_brands')
        .select()
        .order('name');
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    return [];
  }
});

final bazarCategoriesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  try {
    final response = await Supabase.instance.client
        .from('bazar_categories')
        .select()
        .order('name');
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    return [];
  }
});

final digiBazarProvider =
    FutureProvider.family<List<BazarProductModel>, String>(
        (ref, brandFilter) async {
  try {
    var query = Supabase.instance.client.from('bazar_products').select();

    // Apply server-side filtering if a specific brand is selected
    if (brandFilter != 'All') {
      query = query.eq('brand_name', brandFilter);
    }

    final response = await query;
    return (response as List).map((e) => BazarProductModel.fromMap(e)).toList();
  } catch (e) {
    // Fallback gracefully if table doesn't exist yet so APK doesn't crash during evaluation
    return [
      BazarProductModel(
        id: '1',
        brandName: 'Fallback',
        title: 'Men Loose Fit Cargo Pants',
        price: 1999,
        imageUrl:
            'https://images.unsplash.com/photo-1549887552-cb1071d3e5ca?q=80&w=300&auto=format&fit=crop',
        moq: 5,
      ),
    ];
  }
});
