part of 'home_page_bloc.dart';

enum HomeStatus { initial, loading, loaded, failure }

enum SortOption { lowToHigh, highToLow, byName }

enum HomeCategory { all, chair, bed, lamp, floor }

List<String> categories = [
  "All",
  "Chair",
  "Bed",
  "Lamp",
  "Floor",
];

class HomePageState extends Equatable {
  const HomePageState(
      {this.status = HomeStatus.initial,
      this.products = const <Product>[],
      this.sortOption = SortOption.byName,
      this.selectedCategory = HomeCategory.all});

  final HomeStatus status;
  final List<Product> products;
  final SortOption sortOption;
  final HomeCategory selectedCategory;

  int getCategoryIndex(HomeCategory category) {
    switch (selectedCategory) {
      case HomeCategory.chair:
        return 1;
      case HomeCategory.bed:
        return 2;
      case HomeCategory.lamp:
        return 3;
      case HomeCategory.floor:
        return 4;
      default:
        return 0;
    }
  }

  List<Product> get filteredList {
    List<Product> filteredProduct;

    filteredProduct = selectedCategory == HomeCategory.all
        ? products
        : products
            .where((product) =>
                product.categoryId == getCategoryIndex(selectedCategory))
            .toList();
    return filteredProduct;
  }

  HomePageState copyWith(
      {HomeStatus? newStatus,
      List<Product>? newProducts,
      SortOption? newSortOption,
      HomeCategory? newCategory}) {
    return HomePageState(
        status: newStatus ?? status,
        products: newProducts ?? products,
        sortOption: newSortOption ?? sortOption,
        selectedCategory: newCategory ?? selectedCategory);
  }

  @override
  List<Object?> get props => [status, products, sortOption, selectedCategory];
}
