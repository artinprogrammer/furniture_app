import 'package:hive_flutter/adapters.dart';
part 'product.g.dart';

@HiveType(typeId: 1)
class Product extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int categoryId;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final String title;
  @HiveField(4)
  final String subtitle;
  @HiveField(5)
  final String color;
  @HiveField(6)
  final String description;
  @HiveField(7)
  final String rating;
  @HiveField(8)
  final int price;

  Product({
    required this.id,
    required this.categoryId,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.description,
    required this.rating,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json["id"],
        categoryId: json["categoryId"],
        imageUrl: json["imageUrl"],
        title: json["title"],
        subtitle: json["subtitle"],
        color: json["color"],
        description: json["description"],
        rating: json["rating"],
        price: json["price"]);
  }
}
