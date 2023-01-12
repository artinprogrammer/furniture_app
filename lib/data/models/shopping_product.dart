import 'package:hive_flutter/adapters.dart';
part 'shopping_product.g.dart';
@HiveType(typeId: 2)
class ShoppingProduct extends HiveObject {
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
  @HiveField(9)
  final int number;

  ShoppingProduct(
      {required this.id,
      required this.categoryId,
      required this.imageUrl,
      required this.title,
      required this.subtitle,
      required this.color,
      required this.description,
      required this.rating,
      required this.price,
      required this.number});
}
