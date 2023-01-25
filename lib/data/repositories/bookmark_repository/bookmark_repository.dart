import 'dart:async';
import 'dart:developer';

import 'package:furniture_app/data/models/product.dart';
import 'package:hive_flutter/adapters.dart';

class BookMarkRepository {
  late Box<Product> _bookmarks;
  Future<void> init() async {
    _bookmarks = await Hive.openBox<Product>('bookmarks');
  }

  List<Product> getBookMarks() {
    List<Product> bookMarks = _bookmarks.values.toList();
    return bookMarks;
  }

  Future<void> deleteBookMark(Product product) async {
    var productToDelete = _bookmarks.values.firstWhere((element) => element.id == product.id);
    await _bookmarks.delete(productToDelete.key);
  }

  Future<void> addBookMark(Product productToAdd) async {
    await _bookmarks.add(productToAdd);
  }
}
