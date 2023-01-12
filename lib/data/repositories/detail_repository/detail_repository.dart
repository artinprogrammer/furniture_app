import 'package:furniture_app/data/models/product.dart';
import 'package:furniture_app/data/provider/api_provider.dart';

class DetialRepository {
  late ProductsApiProvider _apiProvider;

  DetialRepository(this._apiProvider);

  Future<Product> getProductDetails(int productId) async {
    final response = await _apiProvider.getProductDetail(productId);
    return Product.fromJson(response.data[0]);
  }
}
