import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:furniture_app/Blocs/shopping_cart_bloc/shopping_cart_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    var textTheme = Theme.of(context).textTheme;
    return BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
        builder: (context, state) {
      if (state.status == ShoppingCartStatus.loading) {
        return const Center(
            child: SpinKitThreeBounce(
          color: Colors.red,
        ));
      }
      if (state.status == ShoppingCartStatus.failure) {
        return const Center(
          child: Text("oops!something went wrong :("),
        );
      }
      if (state.status == ShoppingCartStatus.loaded) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(width / 12, 16, width / 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "My Cart",
                        style: textTheme.headline1,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        "${state.shoppingCartList.length} items",
                        style: textTheme.subtitle1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 233, 233, 233),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32))),
              child: Column(
                children: [
                  SizedBox(
                    height: height / 1.7,
                    child: Padding(
                      padding:
                          EdgeInsets.fromLTRB(width / 12, 0, width / 12, 0),
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.shoppingCartList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var currentProduct = state.shoppingCartList[index];
                            return Padding(
                              padding: const EdgeInsets.only(top: 32),
                              child: Container(
                                height: 120,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16))),
                                child: Row(
                                  children: [
                                    Container(
                                      width: width / 2.75,
                                      height: 120,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                currentProduct.imageUrl,
                                              ),
                                              fit: BoxFit.cover),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(16))),
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
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            "\$${currentProduct.price}",
                                            style: textTheme.subtitle1,
                                          ),
                                          const SizedBox(
                                            height: 32,
                                          ),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  if (currentProduct.number >
                                                      1) {
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
                                                child: Container(
                                                  width: 35,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  25))),
                                                  child: const Icon(
                                                    CupertinoIcons.minus,
                                                    color: Colors.grey,
                                                    size: 17,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                currentProduct.number
                                                    .toString(),
                                                style: textTheme.subtitle1,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  BlocProvider.of<
                                                              ShoppingCartBloc>(
                                                          context)
                                                      .add(UpdateQuantity(
                                                          currentProduct,
                                                          currentProduct
                                                                  .number +
                                                              1));
                                                },
                                                child: Container(
                                                  width: 35,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  25))),
                                                  child: const Icon(
                                                    CupertinoIcons.plus,
                                                    color: Colors.grey,
                                                    size: 17,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 32),
                                              InkWell(
                                                onTap: () {
                                                  BlocProvider.of<
                                                              ShoppingCartBloc>(
                                                          context)
                                                      .add(DeleteProductFromShoppingCart(
                                                          productToDelete:
                                                              currentProduct));
                                                },
                                                child: Container(
                                                  width: 35,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  25))),
                                                  child: const Icon(
                                                    CupertinoIcons.trash,
                                                    color: Colors.red,
                                                    size: 17,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  const SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Subtotal:",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 19,
                              fontWeight: FontWeight.w400
                            ),
                          ),
                          const SizedBox(width: 8,),
                          Text(
                            "\$${state.subTotal}",
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w400
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Taxes:",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 19,
                              fontWeight: FontWeight.w400
                            ),
                          ),
                          const SizedBox(width: 8,),
                          Text(
                            "\$${state.tax}",
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w400
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8,),
                  Container(
                    width: double.infinity,
                    height: 74,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(32),topRight: Radius.circular(32))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("\$${state.totalPrice}",style: textTheme.headline1,),
                        Container(
                          height: 40,
                          width: 150,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(32))
                          ),
                          child: const Center(
                            child: Text("Check Out",style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                            ),),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ))
          ],
        );
      }
      return Container();
    });
  }
}
