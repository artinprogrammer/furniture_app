import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_app/Blocs/home_page_bloc/home_page_bloc.dart';
import 'package:furniture_app/Blocs/shopping_cart_bloc/shopping_cart_bloc.dart';
import 'package:furniture_app/constants/color_constants.dart';
import 'package:furniture_app/constants/string_constant.dart';
import 'package:furniture_app/presentation/search_page/search_page.dart';

import '../../core/widgets/productItem.dart';
import '../../data/provider/api_provider.dart';
import '../../data/repositories/bookmark_repository/bookmark_repository.dart';
import '../../data/repositories/home_repository/home_repostiory.dart';
import '../../data/repositories/shopping_repository/shopping_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Route<void> route() {
    return MaterialPageRoute(
        builder: (context) => MultiRepositoryProvider(
              providers: [
                RepositoryProvider(
                    create: (context) => HomeRepository(ProductsApiProvider())),
                RepositoryProvider(create: (context) => BookMarkRepository()),
                RepositoryProvider(create: (context) => ShoppingRepository()),
              ],
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => HomePageBloc(
                        homeRepository:
                            RepositoryProvider.of<HomeRepository>(context))
                      ..add(LoadHomeItemsEvent()),
                  ),
                  BlocProvider(
                      create: (context) => ShoppingCartBloc(
                          shoppingRepository:
                              RepositoryProvider.of<ShoppingRepository>(
                                  context))
                        ..add(RegisterShoppingCart()))
                ],
                child: const SafeArea(
                  child: Scaffold(
                    backgroundColor: ColorConstants.backgroundColor,
                    body: HomeScreen(),
                  ),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    var cornerPadding = width / 12;
    var textTheme = Theme.of(context).textTheme;

    final shoppingCartList =
        context.select((ShoppingCartBloc bloc) => bloc.state.shoppingCartList);

    return BlocBuilder<HomePageBloc, HomePageState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
              right: cornerPadding, left: cornerPadding, top: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringConstant.bestFurniture,
                    style: textTheme.headline1,
                  ),
                  Text(
                    StringConstant.perfectChoice,
                    style: textTheme.headline2,
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: width / 1.6,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(SearchPage().route());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search,
                              color: ColorConstants.textColor,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              StringConstant.search,
                              style: textTheme.subtitle1,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    child: PopupMenuButton<SortOption>(
                      shape: const ContinuousRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                              value: SortOption.byName,
                              child: Text(
                                "sort by name",
                                style: TextStyle(
                                    color: state.sortOption == SortOption.byName
                                        ? Colors.black
                                        : Colors.grey),
                              )),
                          PopupMenuItem(
                              value: SortOption.lowToHigh,
                              child: Text("sort by price(low to high)",
                                  style: TextStyle(
                                      color: state.sortOption ==
                                              SortOption.lowToHigh
                                          ? Colors.black
                                          : Colors.grey))),
                          PopupMenuItem(
                              value: SortOption.highToLow,
                              child: Text(
                                "sort by price(higth to low)",
                                style: TextStyle(
                                    color:
                                        state.sortOption == SortOption.highToLow
                                            ? Colors.black
                                            : Colors.grey),
                              )),
                        ];
                      },
                      onSelected: (sortOption) {
                        BlocProvider.of<HomePageBloc>(context)
                            .add(SortOptionChanged(sortOption));
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: const Icon(Icons.sort),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              SizedBox(
                height: 64,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      var categoryToEnum;
                      switch (categories[index]) {
                        case "All":
                          categoryToEnum = HomeCategory.all;
                          break;
                        case "Chair":
                          categoryToEnum = HomeCategory.chair;
                          break;
                        case "Bed":
                          categoryToEnum = HomeCategory.bed;
                          break;
                        case "Lamp":
                          categoryToEnum = HomeCategory.lamp;
                          break;
                        case "Floor":
                          categoryToEnum = HomeCategory.floor;
                          break;
                        default:
                      }
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: index == 0 ? 0 : 16),
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      state.selectedCategory == categoryToEnum
                                          ? ColorConstants.primaryColor
                                          : Colors.transparent,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(32))),
                              child: InkWell(
                                onTap: () {
                                  BlocProvider.of<HomePageBloc>(context)
                                      .add(CategoryChanged(categoryToEnum));
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  child: Text(categories[index].toString(),
                                      style: state.selectedCategory ==
                                              categoryToEnum
                                          ? const TextStyle(
                                              fontSize: 17, color: Colors.white)
                                          : textTheme.subtitle1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
              const SizedBox(
                height: 32,
              ),
              Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.filteredList.length,
                      itemBuilder: (context, index) {
                        final currentProduct = state.filteredList[index];
                        return ProductItem(
                            width: width,
                            height: height,
                            currentProduct: currentProduct,
                            textTheme: textTheme,
                            shoppingCartList: shoppingCartList);
                      }))
            ],
          ),
        );
      },
    );
  }
}
