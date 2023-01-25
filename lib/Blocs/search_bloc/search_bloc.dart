import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:furniture_app/data/models/shopping_product.dart';
import 'package:furniture_app/data/repositories/shopping_repository/shopping_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:furniture_app/data/models/product.dart';
import 'package:furniture_app/data/repositories/home_repository/home_repostiory.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(
      {required HomeRepository homeRepository,
      required ShoppingRepository shoppingRepository})
      : _homeRepository = homeRepository,
        _shoppingRepository = shoppingRepository,
        super(const SearchState()) {
    on<SearchQueryChanged>(_loadNewData,
        transformer: (events, mapper) => events
            .debounceTime(const Duration(milliseconds: 300))
            .switchMap(mapper));
    on<AddProductToShoppingCart>(_addProductToShoppingCart);
  }

  final HomeRepository _homeRepository;
  final ShoppingRepository _shoppingRepository;

  Future<void> _loadNewData(
      SearchQueryChanged event, Emitter<SearchState> emit) async {
    if (event.searchQuery == "") {
      emit(state.copyWith(
        newStatus: SearchStatus.recentsLoaded,
        newRecentSearches: recentSearches,
      ));
    } else {
      var allProducts = await _homeRepository.getHomeProducts();
      List<Product> result = allProducts
          .where((product) => product.title.contains(event.searchQuery))
          .toList();
      await _shoppingRepository.init();
      var shoppingCart = await _shoppingRepository.getShoppingCartItems();
      emit(state.copyWith(
          newStatus: SearchStatus.resultLoaded,
          newSearchedProducts: result,
          newShoppingCartList: shoppingCart,
          newSearchQuery: event.searchQuery));
    }
  }

  Future<void> _addProductToShoppingCart(
      AddProductToShoppingCart event, Emitter<SearchState> emit) async {
    var productToAdd = ShoppingProduct(
        id: event.productToAdd.id,
        categoryId: event.productToAdd.categoryId,
        imageUrl: event.productToAdd.imageUrl,
        title: event.productToAdd.title,
        subtitle: event.productToAdd.subtitle,
        color: event.productToAdd.color,
        description: event.productToAdd.description,
        rating: event.productToAdd.rating,
        price: event.productToAdd.price,
        number: 1);
    await _shoppingRepository.addProduct(productToAdd);
    var result = await _shoppingRepository.getShoppingCartItems();
    emit(state.copyWith(newShoppingCartList: result));
  }

  List<String> recentSearches = ["chair", "table", "lamp"];
}
