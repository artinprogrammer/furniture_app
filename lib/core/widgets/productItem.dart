import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_app/presentation/details_page/detail_page.dart';

import '../../Blocs/home_cubit/home_cubit.dart';
import '../../Blocs/shopping_cart_bloc/shopping_cart_bloc.dart';
import '../../constants/color_constants.dart';
import '../../constants/string_constant.dart';
import '../../data/models/product.dart';
import '../../data/models/shopping_product.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
    required this.width,
    required this.height,
    required this.currentProduct,
    required this.textTheme,
    required this.shoppingCartList,
  }) : super(key: key);

  final double width;
  final double height;
  final Product currentProduct;
  final TextTheme textTheme;
  final List<ShoppingProduct> shoppingCartList;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(DetailPage().route(newProductId: currentProduct.id));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: width,
          height: height / 4.5,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Container(
                  width: width / 2.7,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      image: DecorationImage(
                          image: NetworkImage(currentProduct.imageUrl),
                          fit: BoxFit.cover)),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${currentProduct.price}",
                            style: textTheme.headline4,
                          ),
                          InkWell(
                            onTap: () {
                              var productToAdd = ShoppingProduct(
                                  id: currentProduct.id,
                                  categoryId: currentProduct.categoryId,
                                  imageUrl: currentProduct.imageUrl,
                                  title: currentProduct.title,
                                  subtitle: currentProduct.subtitle,
                                  color: currentProduct.color,
                                  description: currentProduct.description,
                                  rating: currentProduct.rating,
                                  price: currentProduct.price,
                                  number: 1);
                              if (!shoppingCartList.contains(productToAdd)) {
                                BlocProvider.of<ShoppingCartBloc>(context).add(
                                    AddNewProductToShoppingCart(
                                        newProduct: productToAdd));
                              } else {
                                context.read<HomeCubit>().setTab(HomeTab.cart);
                              }
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: ColorConstants.primaryColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                child: Text(
                                  shoppingCartList.any((product) =>
                                          product.id == currentProduct.id)
                                      ? "In Cart"
                                      : "Buy",
                                  style: const TextStyle(color: Colors.white),
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
  }
}
