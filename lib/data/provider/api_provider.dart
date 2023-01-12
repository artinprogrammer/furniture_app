import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:furniture_app/constants/api_constant.dart';

class ProductsApiProvider {
  final Dio _dio = Dio();

  var baseUrl = ApiConstant.baseUrl;
  var getHomeItemsCommand = ApiConstant.getHomeItems;
  var getDetailCommand = ApiConstant.getDetail;

  Future<dynamic> getHomeItems() async {
    var url = baseUrl + getHomeItemsCommand;
    var response = await _dio.get(url);
      return response;
  }

  Future<dynamic> getProductDetail(int id) async {
    var url = baseUrl + getDetailCommand + id.toString();
    var response = await _dio.get(url);
    if (response.statusCode == 200) {
      return response;
    }
  }
}
