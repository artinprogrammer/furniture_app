import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_app/Blocs/bookmark_bloc/bookmark_bloc.dart';
import 'package:furniture_app/Blocs/detail_bloc/detail_bloc.dart';
import 'package:furniture_app/Blocs/shopping_cart_bloc/shopping_cart_bloc.dart';
import 'package:furniture_app/constants/color_constants.dart';
import 'package:furniture_app/data/provider/api_provider.dart';
import 'package:furniture_app/data/repositories/bookmark_repository/bookmark_repository.dart';
import 'package:furniture_app/data/repositories/detail_repository/detail_repository.dart';
import 'package:furniture_app/data/repositories/shopping_repository/shopping_repository.dart';
import 'package:furniture_app/presentation/bookmark/bookmark_screen.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({Key? key}) : super(key: key);
  Route<void> route({required int newProductId}) {
    return MaterialPageRoute(builder: ((context) {
      return MultiRepositoryProvider(
          providers: [
            RepositoryProvider(create: (context) => ShoppingRepository()),
            RepositoryProvider(
                create: (context) => DetialRepository(ProductsApiProvider())),
            RepositoryProvider(create: (context) => BookMarkRepository())
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) => ShoppingCartBloc(
                      shoppingRepository:
                          RepositoryProvider.of<ShoppingRepository>(context))
                    ..add(RegisterShoppingCart())),
              BlocProvider(
                  create: (context) => DetailBloc(
                      detailRepository:
                          RepositoryProvider.of<DetialRepository>(context))
                    ..add(CurrentProductIdChanged(newProductId))),
              BlocProvider(
                  create: (context) => BookmarkBloc(
                      bookMarkRepository:
                          RepositoryProvider.of<BookMarkRepository>(context))
                    ..add(RegisterBookmarkServicesEvent()))
            ],
            child: const SafeArea(
              child: Scaffold(
                backgroundColor: ColorConstants.backgroundColor,
                body: DetailPage(),
              ),
            ),
          ));
    }));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    var textTheme = Theme.of(context).textTheme;
    return BlocBuilder<DetailBloc, DetailState>(builder: (context, state) {
      if (state.status == DetailsPageStatus.loading) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state.status == DetailsPageStatus.failure) {
        return const Center(
          child: Text("oops! something went wrong"),
        );
      }
      if (state.status == DetailsPageStatus.loaded) {
        return SizedBox(
          height: height,
          child: Stack(
            children: [
              Container(
                height: height / 2.5,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  NetworkImage(state.currentProduct!.imageUrl),
                              fit: BoxFit.cover)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                            child: IconButton(
                              icon: Icon(CupertinoIcons.back),
                              onPressed: () {},
                            ),
                          ),
                          BlocBuilder<BookmarkBloc, BookmarkState>(
                              builder: (context, bookMarkState) {
                            if (bookMarkState.status ==
                                BookmarkStatus.loading) {
                              return const CircularProgressIndicator();
                            }
                            if (bookMarkState.status == BookmarkStatus.loaded) {
                              bool isInBookmarks = bookMarkState.bookmarks.any(
                                  (product) =>
                                      product.id == state.currentProduct!.id);
                              return InkWell(
                                onTap: () {
                                  if (!isInBookmarks) {
                                    BlocProvider.of<BookmarkBloc>(context).add(
                                        AddBookmarkEvent(
                                            state.currentProduct!));
                                  } else {
                                    BlocProvider.of<BookmarkBloc>(context).add(
                                        DeleteBookmarkEvent(
                                            state.currentProduct!));
                                  }
                                },
                                child: IgnorePointer(
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
                                    child: IconButton(
                                      icon: Icon(
                                          isInBookmarks
                                              ? CupertinoIcons.bookmark_fill
                                              : CupertinoIcons.bookmark,
                                          color: Colors.black),
                                      onPressed: () {},
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Container();
                          })
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: width,
                  height: height / 1.75,
                  decoration: const BoxDecoration(
                      color: ColorConstants.backgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32))),
                  child: Padding(
                    padding:
                        EdgeInsets.fromLTRB(width / 12, 16, width / 12, 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: width / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.currentProduct!.title,
                                    style: textTheme.headline1,
                                    maxLines: 2,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "by Amazon",
                                    style: textTheme.subtitle1,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 217, 217, 217)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(32))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 16, right: 16),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Color.fromARGB(255, 252, 189, 0),
                                      size: 35,
                                    ),
                                    Text(
                                      state.currentProduct!.rating,
                                      style: textTheme.headline3,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "description",
                              style: textTheme.subtitle2,
                            ),
                            const SizedBox(height: 8,),
                            Text(
                              state.currentProduct!.description,
                              style: textTheme.bodySmall,
                              maxLines: 11,
                            )
                          ],
                        ),
                        const SizedBox(height: 8,),
                        Row(
                          children: [
                            Text(
                              "Color:",
                              style: textTheme.headline3,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }
      return Container();
    });
  }
}