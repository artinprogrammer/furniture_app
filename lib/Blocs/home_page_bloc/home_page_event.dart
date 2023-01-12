part of 'home_page_bloc.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeItemsEvent extends HomePageEvent {}

class CategoryChanged extends HomePageEvent {
  final HomeCategory category;

  const CategoryChanged(this.category);

  @override
  List<Object> get props => [category];
}

class SearchQueryChanged extends HomePageEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}

class SortOptionChanged extends HomePageEvent {
  final SortOption sortOption;

  const SortOptionChanged(this.sortOption);

  @override
  List<Object> get props => [sortOption];
}
