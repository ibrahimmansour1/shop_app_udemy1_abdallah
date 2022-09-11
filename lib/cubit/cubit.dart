import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app_abdallah/categories/categories_screen.dart';
import 'package:shop_app_abdallah/models/shop_app/home_model.dart';
import 'package:shop_app_abdallah/products/products_screen.dart';
import 'package:shop_app_abdallah/settings/settings_screen.dart';
import 'package:shop_app_abdallah/shared/components/constants.dart';
import 'package:shop_app_abdallah/shared/network/end_points.dart';
import 'package:shop_app_abdallah/shared/network/remote/dio_helper.dart';

import '../favorites/favorites_screen.dart';
import 'states.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());
  static ShopCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;

  List<Widget> bottomScreens = [
    ProductsScreen(),
    categoriesScreen(),
    favoritesScreen(),
    settingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangeBottomNav());
  }

  HomeModel? homeModel;

  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(url: HOME, token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      printFullText(homeModel!.data!.banners[0].image!);
      print(homeModel!.status);
      emit(ShopSucessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }
}