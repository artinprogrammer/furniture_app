import 'package:bloc/bloc.dart';
import 'package:furniture_app/data/models/product.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import 'package:furniture_app/data/repositories/home_repository/home_repostiory.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc({required HomeRepository homeRepository})
      : _homeRepository = homeRepository,
        super(const HomePageState()) {
    on<LoadHomeItemsEvent>(_loadHomeItems);
    on<CategoryChanged>(_changeCategory);
    on<SearchQueryChanged>(
      _search,
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 300))
          .switchMap(mapper),
    );
    on<SortOptionChanged>(_changeSortOption);
  }
  final HomeRepository _homeRepository;

  Future<void> _loadHomeItems(
      LoadHomeItemsEvent event, Emitter<HomePageState> emit) async {
    emit(state.copyWith(newStatus: HomeStatus.loading));
    try {
      List<Product> products = await _homeRepository.getHomeProducts();
      emit(state.copyWith(newStatus: HomeStatus.loaded, newProducts: products));
    } catch (e) {
      emit(state.copyWith(newStatus: HomeStatus.failure));
    }
  }

  void _changeCategory(CategoryChanged event, Emitter<HomePageState> emit) {
    emit(state.copyWith(newCategory: event.category));
  }

  Future<void> _search(
      SearchQueryChanged event, Emitter<HomePageState> emit) async {
    emit(state.copyWith(newStatus: HomeStatus.loading));
    try {
      List<Product> products = await _homeRepository.getHomeProducts();
      if (event.query == "") {
        emit(state.copyWith(
            newStatus: HomeStatus.loaded, newProducts: products));
      }
      List<Product> searchedProducts = products
          .where((product) => product.title.contains(event.query))
          .toList();
      emit(state.copyWith(
          newStatus: HomeStatus.loaded, newProducts: searchedProducts));
    } catch (e) {
      emit(state.copyWith(newStatus: HomeStatus.failure));
    }
  }

  Future<void> _changeSortOption(SortOptionChanged event, Emitter<HomePageState> emit) async{
    emit(state.copyWith(newStatus: HomeStatus.loading));
    try{
      List<Product> products = await _homeRepository.getHomeProducts();
      var sortedProducts = products.toList();
      switch (event.sortOption) {
      case SortOption.byName:
        sortedProducts.sort(
            (productA, productB) => productA.title.compareTo(productB.title));
        break;
      case SortOption.lowToHigh:
        sortedProducts.sort(
            (productA, productB) => productA.price.compareTo(productB.price));
        break;
      case SortOption.highToLow:
        sortedProducts.sort(
            (productA, productB) => productB.price.compareTo(productA.price));
        break;
    }
    emit(state.copyWith(newStatus: HomeStatus.loaded,newSortOption: event.sortOption,newProducts: sortedProducts));
    }catch(e){
      emit(state.copyWith(newStatus: HomeStatus.failure));
    }
  }
}
