import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_app/Blocs/home_cubit/home_cubit.dart';
import 'package:furniture_app/Blocs/home_page_bloc/home_page_bloc.dart';
import 'package:furniture_app/Blocs/shopping_cart_bloc/shopping_cart_bloc.dart';
import 'package:furniture_app/constants/color_constants.dart';
import 'package:furniture_app/data/models/product.dart';
import 'package:furniture_app/data/provider/api_provider.dart';
import 'package:furniture_app/data/repositories/bookmark_repository/bookmark_repository.dart';
import 'package:furniture_app/data/repositories/home_repository/home_repostiory.dart';
import 'package:furniture_app/data/repositories/shopping_repository/shopping_repository.dart';
import 'package:furniture_app/presentation/home_page/home_page.dart';
import 'package:hive_flutter/adapters.dart';

import 'data/models/shopping_product.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ShoppingProductAdapter());
  Hive.registerAdapter(ProductAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            textTheme: const TextTheme(
                headline1: TextStyle(
                    fontSize: 25,
                    color: ColorConstants.textColor,
                    fontWeight: FontWeight.bold),
                headline2: TextStyle(
                    fontSize: 20,
                    color: ColorConstants.textColor,
                    fontWeight: FontWeight.w300),
                headline3: TextStyle(
                    fontSize: 18,
                    color: ColorConstants.textColor,
                    fontWeight: FontWeight.w500),
                headline4: TextStyle(
                    fontSize: 18,
                    color: ColorConstants.primaryColor,
                    fontWeight: FontWeight.w500),
                headline5: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
                subtitle1: TextStyle(
                    fontSize: 17,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
                subtitle2: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500))),
        home: MultiRepositoryProvider(
          providers: [
            RepositoryProvider(
                create: (context) => HomeRepository(ProductsApiProvider())),
            RepositoryProvider(create: (context) => BookMarkRepository()),
            RepositoryProvider(create: (context) => ShoppingRepository()),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => HomeCubit(),
              ),
              BlocProvider(
                create: (context) => HomePageBloc(
                    homeRepository:
                        RepositoryProvider.of<HomeRepository>(context))
                  ..add(LoadHomeItemsEvent()),
              ),
              BlocProvider(
                  create: (context) => ShoppingCartBloc(
                      shoppingRepository:
                          RepositoryProvider.of<ShoppingRepository>(context))
                    ..add(RegisterShoppingCart()))
            ],
            child: const HomePage(),
          ),
        ));
  }
}
