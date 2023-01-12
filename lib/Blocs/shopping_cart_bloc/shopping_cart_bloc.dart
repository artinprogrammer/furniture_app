import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:furniture_app/data/models/product.dart';
import 'package:furniture_app/data/repositories/shopping_repository/shopping_repository.dart';

import '../../data/models/shopping_product.dart';

part 'shopping_cart_event.dart';
part 'shopping_cart_state.dart';

class ShoppingCartBloc extends Bloc<ShoppingCartEvent, ShoppingCartState> {
  ShoppingCartBloc({required ShoppingRepository shoppingRepository})
      : _shoppingRepository = shoppingRepository,
        super(const ShoppingCartState()) {
    on<RegisterShoppingCart>(_registerShoppingCart);
    on<LoadShoppingCart>(_loadShoppingCart);
    on<AddNewProductToShoppingCart>(_addProduct);
    on<DeleteProductFromShoppingCart>(_deleteProduct);
    on<DeleteShoppingCart>(_deleteShoppingCart);
  }
  final ShoppingRepository _shoppingRepository;

  Future<void> _registerShoppingCart(
      RegisterShoppingCart event, Emitter<ShoppingCartState> emit) async {
    await _shoppingRepository.init();
    add(LoadShoppingCart());
  }

  Future<void> _loadShoppingCart(
      LoadShoppingCart event, Emitter<ShoppingCartState> emit) async {
    emit(state.copyWith(newStatus: ShoppingCartStatus.loading));
    try {
      final shoppingCartList = await _shoppingRepository.getShoppingCartItems();
      double subTotal = 0;
      for (var i = 0; i < shoppingCartList.length; i++) {
        var currentProduct = shoppingCartList[i];
        subTotal += currentProduct.price * currentProduct.number;
      }
      double tax = 9 * subTotal / 100;
      double totalPrice = subTotal + tax;

      emit(state.copyWith(
          newStatus: ShoppingCartStatus.loaded,
          newShoppingCartList: shoppingCartList,
          newSubTotal: subTotal,
          newTax: tax,
          newTotalPrice: totalPrice));
    } catch (e) {
      emit(state.copyWith(newStatus: ShoppingCartStatus.failure));
    }
  }

  Future<void> _addProduct(AddNewProductToShoppingCart event,
      Emitter<ShoppingCartState> emit) async {
    log("add");
    await _shoppingRepository.addProduct(event.newProduct);
    add(LoadShoppingCart());
  }

  Future<void> _deleteProduct(DeleteProductFromShoppingCart event,
      Emitter<ShoppingCartState> emit) async {
    await _shoppingRepository.deleteProduct(event.productToDelete.key);
  }

  Future<void> _deleteShoppingCart(
      DeleteShoppingCart event, Emitter<ShoppingCartState> emit) async {
    for (var i = 0; i < state.shoppingCartList.length; i++) {
      await _shoppingRepository.deleteProduct(state.shoppingCartList[i].id);
    }
    add(LoadShoppingCart());
  }
}
