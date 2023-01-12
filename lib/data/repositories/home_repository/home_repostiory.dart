import 'dart:developer';

import 'package:furniture_app/data/models/product.dart';
import 'package:furniture_app/data/provider/api_provider.dart';

class HomeRepository {
  ProductsApiProvider _apiProvider;

  HomeRepository(this._apiProvider);

  Future<List<Product>> getHomeProducts() async {
    var response = await _apiProvider.getHomeItems();
    List<Product> dataList = [];
    if (response.statusCode == 200) {
      response.data["all_products"]
          .forEach((json) => dataList.add(Product.fromJson(json)));
    }
    return dataList;
  }
}
