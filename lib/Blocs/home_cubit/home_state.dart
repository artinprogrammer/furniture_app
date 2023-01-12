part of 'home_cubit.dart';

enum HomeTab { home, cart, bookmark }

class HomeState extends Equatable {
  HomeState({this.currentTab = HomeTab.home});

  HomeTab currentTab;

  @override
  List<Object> get props => [currentTab];
}
