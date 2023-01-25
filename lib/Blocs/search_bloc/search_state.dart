part of 'search_bloc.dart';

enum SearchStatus { initial, recentsLoaded, resultLoaded, failure }

class SearchState extends Equatable {
  const SearchState(
      {this.status = SearchStatus.initial,
      this.searchedProducts = const <Product>[],
      this.recentSearches = const <String>[],
      this.shoppingCartList = const <ShoppingProduct>[],
      this.searchQuery = ""});

  final SearchStatus status;
  final List<Product> searchedProducts;
  final List<String> recentSearches;
  final List<ShoppingProduct> shoppingCartList;
  final String searchQuery;

  SearchState copyWith(
      {SearchStatus? newStatus,
      List<Product>? newSearchedProducts,
      List<String>? newRecentSearches,
      List<ShoppingProduct>? newShoppingCartList,
      String? newSearchQuery}) {
    return SearchState(
        status: newStatus ?? status,
        searchedProducts: newSearchedProducts ?? searchedProducts,
        recentSearches: newRecentSearches ?? recentSearches,
        shoppingCartList: newShoppingCartList ?? shoppingCartList,
        searchQuery: newSearchQuery ?? searchQuery);
  }

  @override
  List<Object> get props =>
      [status, searchedProducts, recentSearches, shoppingCartList, searchQuery];
}
