import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:furniture_app/Blocs/detail_bloc/detail_bloc.dart';
import 'package:furniture_app/Blocs/shopping_cart_bloc/shopping_cart_bloc.dart';
import 'package:furniture_app/constants/color_constants.dart';
import 'package:furniture_app/data/models/shopping_product.dart';
import 'package:furniture_app/data/provider/api_provider.dart';
import 'package:furniture_app/data/repositories/bookmark_repository/bookmark_repository.dart';
import 'package:furniture_app/data/repositories/detail_repository/detail_repository.dart';
import 'package:furniture_app/data/repositories/shopping_repository/shopping_repository.dart';
import 'package:furniture_app/main.dart';
import 'package:furniture_app/presentation/home_screen/home_screen.dart';

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
                          RepositoryProvider.of<DetialRepository>(context),
                      bookMarkRepository:
                          RepositoryProvider.of<BookMarkRepository>(context))
                    ..add(CurrentProductIdChanged(newProductId))),
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
                              icon: const Icon(CupertinoIcons.back),
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) => const  MyApp()));
                              },
                            ),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24))),
                            child: IconButton(
                                onPressed: () {
                                  if (!state.bookMarksList.any((product) =>
                                      product.id == state.currentProduct!.id)) {
                                    BlocProvider.of<DetailBloc>(context)
                                        .add(AddToBookMarksEvent());
                                  }
                                  if (state.bookMarksList.any((product) =>
                                      product.id == state.currentProduct!.id)) {
                                    BlocProvider.of<DetailBloc>(context)
                                        .add(DeleteFromBookMarksEvent());
                                  }
                                },
                                icon: Icon(
                                  state.bookMarksList.any((product) =>
                                          product.id ==
                                          state.currentProduct!.id)
                                      ? CupertinoIcons.bookmark_fill
                                      : CupertinoIcons.bookmark,
                                  color: Colors.black,
                                )),
                          )
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
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              state.currentProduct!.description,
                              style: textTheme.bodySmall,
                              maxLines: 10,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Text(
                              "Color:",
                              style: textTheme.headline3,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  color: state.productColor,
                                  border: Border.all(
                                      color:
                                          Color.fromARGB(255, 255, 255, 255)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Divider(
                          thickness: 1.5,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "\$${state.currentProduct!.price}",
                              style: textTheme.headline1,
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
                              builder: (context, shoppingCartState) {
                                bool isInShoppingCart = shoppingCartState
                                    .shoppingCartList
                                    .any((product) =>
                                        product.id == state.currentProduct!.id);
                                return Container(
                                  height: 50,
                                  decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(30))),
                                  child: Builder(
                                    builder: (context) {
                                      if (shoppingCartState.status ==
                                          ShoppingCartStatus.loading) {
                                        return const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(32, 8, 32, 8),
                                          child: SpinKitThreeBounce(
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        );
                                      }
                                      if (!isInShoppingCart) {
                                        return InkWell(
                                          onTap: () {
                                            BlocProvider.of<ShoppingCartBloc>(context)
                                                .add(AddNewProductToShoppingCart(
                                                    newProduct: ShoppingProduct(
                                                        id:
                                                            state
                                                                .currentProduct!
                                                                .id,
                                                        categoryId: state
                                                            .currentProduct!
                                                            .categoryId,
                                                        imageUrl: state
                                                            .currentProduct!
                                                            .imageUrl,
                                                        title: state
                                                            .currentProduct!
                                                            .title,
                                                        subtitle: state
                                                            .currentProduct!
                                                            .subtitle,
                                                        color: state
                                                            .currentProduct!
                                                            .color,
                                                        description: state
                                                            .currentProduct!
                                                            .description,
                                                        rating: state
                                                            .currentProduct!
                                                            .rating,
                                                        price: state
                                                            .currentProduct!
                                                            .price,
                                                        number: 1)));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 12, 16, 0),
                                            child: Text(
                                              "Buy now",
                                              style: textTheme.headline6,
                                            ),
                                          ),
                                        );
                                      }
                                      if (isInShoppingCart) {
                                        var currentProduct = shoppingCartState
                                            .shoppingCartList
                                            .firstWhere((product) =>
                                                product.id ==
                                                state.currentProduct!.id);
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8, bottom: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  currentProduct.number == 1
                                                      ? CupertinoIcons.trash
                                                      : CupertinoIcons.minus,
                                                ),
                                                onPressed: () {
                                                  if (currentProduct.number ==
                                                      1) {
                                                    BlocProvider.of<
                                                                ShoppingCartBloc>(
                                                            context)
                                                        .add(DeleteProductFromShoppingCart(
                                                            productToDelete:
                                                                currentProduct));
                                                  } else {
                                                    BlocProvider.of<
                                                                ShoppingCartBloc>(
                                                            context)
                                                        .add(UpdateQuantity(
                                                            currentProduct,
                                                            currentProduct
                                                                    .number -
                                                                1));
                                                  }
                                                },
                                                color: Colors.white,
                                              ),
                                              const SizedBox(
                                                width: 32,
                                              ),
                                              Text(
                                                  currentProduct.number
                                                      .toString(),
                                                  style: textTheme.headline6),
                                              const SizedBox(
                                                width: 32,
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                    CupertinoIcons.add),
                                                color: Colors.white,
                                                onPressed: () {
                                                  BlocProvider.of<
                                                              ShoppingCartBloc>(
                                                          context)
                                                      .add(UpdateQuantity(
                                                          currentProduct,
                                                          currentProduct
                                                                  .number +
                                                              1));
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
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
