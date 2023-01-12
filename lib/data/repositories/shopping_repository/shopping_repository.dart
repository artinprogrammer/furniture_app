import 'dart:async';

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

  Future<void> deleteProduct(int id) async {
    await _shoppingCart.delete(id);
  }

  Future<void> addProduct(ShoppingProduct productToAdd) async {
    await _shoppingCart.add(productToAdd);
  }
}
