part of 'shopping_cart_bloc.dart';

abstract class ShoppingCartEvent extends Equatable {
  const ShoppingCartEvent();

  @override
  List<Object> get props => [];
}

class RegisterShoppingCart extends ShoppingCartEvent{}

class LoadShoppingCart extends ShoppingCartEvent {}

class AddNewProductToShoppingCart extends ShoppingCartEvent {
  final ShoppingProduct newProduct;

  const AddNewProductToShoppingCart({required this.newProduct});

  @override
  List<Object> get props => [newProduct];
}

class DeleteProductFromShoppingCart extends ShoppingCartEvent {
  final ShoppingProduct productToDelete;

  const DeleteProductFromShoppingCart({required this.productToDelete});

  @override
  List<Object> get props => [productToDelete];
}

class UpdateQuantity extends ShoppingCartEvent{
  final ShoppingProduct product;
  final int value;

  const UpdateQuantity(this.product, this.value);

  @override
  List<Object> get props => [value,product];
}

class DeleteShoppingCart extends ShoppingCartEvent {}
