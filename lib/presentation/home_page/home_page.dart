import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_app/constants/color_constants.dart';
import 'package:furniture_app/presentation/bookmark/bookmark_screen.dart';
import 'package:furniture_app/presentation/cart/cart_screen.dart';
import 'package:furniture_app/presentation/home_screen/home_screen.dart';

import '../../Blocs/home_cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedTab =
        context.select((HomeCubit cubit) => cubit.state.currentTab.index);
    return SafeArea(
        child: Scaffold(
      backgroundColor: ColorConstants.backgroundColor,
      body: IndexedStack(
        index: selectedTab,
        children: const [HomeScreen(), CartScreen(), BookMarkScreen()],
      ),
      bottomNavigationBar: FluidNavBar(
        defaultIndex: selectedTab,
        animationFactor: 0.9,
        style: const FluidNavBarStyle(
            iconUnselectedForegroundColor: Colors.grey,
            iconBackgroundColor: Color.fromARGB(255, 255, 255, 255),
            iconSelectedForegroundColor: Color.fromARGB(255, 255, 102, 0),
            barBackgroundColor: Colors.white),
        icons: [
          FluidNavBarIcon(icon: Icons.home),
          FluidNavBarIcon(icon: Icons.shopping_cart),
          FluidNavBarIcon(icon: Icons.bookmark),
        ],
        onChange: (val) {
          switch (val) {
            case 0:
              context.read<HomeCubit>().setTab(HomeTab.home);
              break;
            case 1:
              context.read<HomeCubit>().setTab(HomeTab.cart);
              break;
            case 2:
              context.read<HomeCubit>().setTab(HomeTab.bookmark);
              break;
            default:
          }
        },
      ),
    ));
  }
}
