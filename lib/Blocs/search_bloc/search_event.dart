part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String searchQuery;

  const SearchQueryChanged({required this.searchQuery});
}

class AddProductToShoppingCart extends SearchEvent {
  final Product productToAdd;

  const AddProductToShoppingCart(this.productToAdd);
  @override
  List<Object> get props => [productToAdd];
}
