import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:furniture_app/data/models/product.dart';
import 'package:furniture_app/data/models/shopping_product.dart';
import 'package:hive_flutter/adapters.dart';

class ShoppingRepository {
  late Box<ShoppingProduct> _shoppingCart;
  Future<void> init() async {
    _shoppingCart = await Hive.openBox<ShoppingProduct>('shoppingcart');
  }

  List<ShoppingProduct> getShoppingCartItems() {
    List<ShoppingProduct> shoppingList = _shoppingCart.values.toList();
    return shoppingList;
  }

  Future<void> deleteProduct(ShoppingProduct productToDelete) async {
    var id = _shoppingCart.values
        .firstWhere((element) => element.id == productToDelete.id).key;
    log(id.toString());
    await _shoppingCart.delete(id);
  }

  Future<void> addProduct(ShoppingProduct productToAdd) async {
    await _shoppingCart.add(productToAdd);
  }

  Future<void> updateQuantity(ShoppingProduct product, int value) async {
    var newProduct = ShoppingProduct(
        id: product.id,
        categoryId: product.categoryId,
        imageUrl: product.imageUrl,
        title: product.title,
        subtitle: product.subtitle,
        color: product.color,
        description: product.description,
        rating: product.rating,
        price: product.price,
        number: value);
    var currentProduct =
        _shoppingCart.values.firstWhere((element) => element.id == product.id);
    await _shoppingCart.put(currentProduct.key, newProduct);
  }
}
