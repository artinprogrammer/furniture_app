import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_app/Blocs/search_bloc/search_bloc.dart';
import 'package:furniture_app/data/repositories/home_repository/home_repostiory.dart';
import 'package:furniture_app/data/repositories/shopping_repository/shopping_repository.dart';

import '../../constants/color_constants.dart';
import '../../constants/string_constant.dart';
import '../../data/provider/api_provider.dart';
import '../../main.dart';
import '../details_page/detail_page.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);

  final TextEditingController _textController = TextEditingController();

  Route<void> route() {
    return MaterialPageRoute(
        builder: (context) => MultiRepositoryProvider(
                providers: [
                  RepositoryProvider(
                      create: (context) =>
                          HomeRepository(ProductsApiProvider())),
                  RepositoryProvider(create: (context) => ShoppingRepository()),
                ],
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (context) => SearchBloc(
                            homeRepository:
                                RepositoryProvider.of<HomeRepository>(context),
                            shoppingRepository:
                                RepositoryProvider.of<ShoppingRepository>(
                                    context))
                          ..add(SearchQueryChanged(searchQuery: "")))
                  ],
                  child: SafeArea(
                    child: Scaffold(
                      resizeToAvoidBottomInset: true,
                      backgroundColor: ColorConstants.backgroundColor,
                      body: SearchPage(),
                    ),
                  ),
                )));
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return SingleChildScrollView(
      child: BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
        _textController.text = state.searchQuery;
        return Column(
          children: [
            TextField(
              controller: _textController,
              onChanged: (query) {
                BlocProvider.of<SearchBloc>(context)
                    .add(SearchQueryChanged(searchQuery: query));
              },
              textInputAction: TextInputAction.search,
              onSubmitted: (query) {
                log(query);
              },
              autofocus: true,
              decoration: InputDecoration(
                  focusColor: Colors.black,
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2)),
                  prefixIcon: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MyApp()));
                    },
                    icon: const Icon(CupertinoIcons.back),
                  ),
                  hintText: "Search"),
            ),
            Builder(builder: (context) {
              if (state.status == SearchStatus.recentsLoaded) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Recent Searches :",
                        style: textTheme.headline3,
                      ),
                      SizedBox(
                          height: 250,
                          child: ListView.builder(
                              itemCount: state.recentSearches.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    BlocProvider.of<SearchBloc>(context).add(
                                        SearchQueryChanged(
                                            searchQuery:
                                                state.recentSearches[index]));
                                  },
                                  title: Text(state.recentSearches[index]),
                                );
                              })),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                      )
                    ],
                  ),
                );
              }
              if (state.status == SearchStatus.resultLoaded) {
                return Padding(
                    padding: EdgeInsets.fromLTRB(width / 12, 64, width / 12, 0),
                    child: SizedBox(
                      height: height / 1.3,
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.searchedProducts.length,
                          itemBuilder: (context, index) {
                            var currentProduct = state.searchedProducts[index];
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(DetailPage()
                                    .route(newProductId: currentProduct.id));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: width,
                                  height: height / 4.5,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: width / 2.7,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(16)),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      currentProduct.imageUrl),
                                                  fit: BoxFit.cover)),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                currentProduct.title,
                                                style: textTheme.headline3,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              Text(
                                                StringConstant.byAmazon,
                                                style: textTheme.subtitle2,
                                              ),
                                              const SizedBox(
                                                height: 16,
                                              ),
                                              Text(
                                                currentProduct.subtitle,
                                                style: textTheme.subtitle2,
                                                overflow: TextOverflow.clip,
                                                maxLines: 2,
                                              ),
                                              const SizedBox(
                                                height: 32,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "\$${currentProduct.price}",
                                                    style: textTheme.headline4,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      if (!state
                                                          .shoppingCartList
                                                          .any((product) =>
                                                              product.id ==
                                                              currentProduct
                                                                  .id)) {
                                                        BlocProvider.of<
                                                                    SearchBloc>(
                                                                context)
                                                            .add(AddProductToShoppingCart(
                                                                currentProduct));
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: const BoxDecoration(
                                                          color: ColorConstants
                                                              .primaryColor,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          16))),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                16, 8, 16, 8),
                                                        child: Text(
                                                          state.shoppingCartList
                                                                  .any((product) =>
                                                                      product
                                                                          .id ==
                                                                      currentProduct
                                                                          .id)
                                                              ? "In Cart"
                                                              : "Buy",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ));
              }
              if (state.status == SearchStatus.failure) {
                return const Center(
                  child: Text("oops! sth went wrong"),
                );
              }
              return Container();
            })
          ],
        );
      }),
    );
  }
}
