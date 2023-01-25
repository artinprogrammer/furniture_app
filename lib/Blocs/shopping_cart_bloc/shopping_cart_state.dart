part of 'shopping_cart_bloc.dart';

enum ShoppingCartStatus { initial, loading, loaded, failure }

class ShoppingCartState extends Equatable {
  const ShoppingCartState(
      {this.status = ShoppingCartStatus.initial,
      this.shoppingCartList = const <ShoppingProduct>[],
      this.recentAddedProducts = const <ShoppingProduct>[],
      this.subTotal = 0,
      this.totalPrice = 0,
      this.tax = 0});
  final ShoppingCartStatus status;
  final List<ShoppingProduct> shoppingCartList;
  final List<ShoppingProduct> recentAddedProducts;
  final double subTotal;
  final double totalPrice;
  final double tax;

  ShoppingCartState copyWith(
      {ShoppingCartStatus? newStatus,
      List<ShoppingProduct>? newShoppingCartList,
      List<ShoppingProduct>? newRecentAddedProducts,
      double? newTotalPrice,
      double? newSubTotal,
      double? newTax}) {
    return ShoppingCartState(
        status: newStatus ?? status,
        shoppingCartList: newShoppingCartList ?? shoppingCartList,
        recentAddedProducts: newRecentAddedProducts ?? recentAddedProducts,
        totalPrice: newTotalPrice ?? totalPrice,
        subTotal: newSubTotal ?? subTotal,
        tax: newTax ?? tax);
  }

  @override
  List<Object> get props =>
      [status, shoppingCartList, recentAddedProducts, totalPrice, tax,subTotal];
}
