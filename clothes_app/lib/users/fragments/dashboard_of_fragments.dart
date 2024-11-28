import 'package:clothes/users/fragments/home_fragrament_screen.dart';
import 'package:clothes/users/fragments/profile_fragment_screen.dart';
import 'package:clothes/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'favorites_fragment_screen.dart';
import 'order_fragment_screen.dart';

class DashboardOfFragments extends StatelessWidget {
  final int userId;
  final String userEmail;
  final String userName;

  DashboardOfFragments(
      {Key? key,
      required this.userId,
      required this.userEmail,
      required this.userName})
      : super(key: key) {
    // Initialize _fragmentScreens here
    _fragmentScreens = [
      HomeFragmentScreen(
        userId: userId,
        addtofavoriteCallback: updateFavorites,
        userEmail: userEmail,
        userName: userName,
      ),
      FavoritesFragmentScreen(
        favoriteItems: [],
      ),
      OrderFragmentScreen(
        userId: userId,
      ),
      ProfileFragmentScreen(
        userId: userId,
        userEmail: userEmail,
        userName: userName,
      ),
    ];
  }

  late final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());
  late List<Widget> _fragmentScreens;

  void updateFavorites(List<Map<String, dynamic>> updatedFavorites) {
    _fragmentScreens[1] =
        FavoritesFragmentScreen(favoriteItems: updatedFavorites);
  }

  final List _navigationButtonsProperties = [
    {
      "active_icon": Icons.home,
      "non_active_icon": Icons.home_outlined,
      "label": "Home",
    },
    {
      "active_icon": Icons.favorite,
      "non_active_icon": Icons.favorite_border,
      "label": "Favorite",
    },
    {
      "active_icon": FontAwesomeIcons.boxOpen,
      "non_active_icon": FontAwesomeIcons.box,
      "label": "Order",
    },
    {
      "active_icon": Icons.person,
      "non_active_icon": Icons.person_off_outlined,
      "label": "Profile",
    },
  ];

  final RxInt _indexNumber = 0.obs;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentUser(),
      initState: (currentState) {
        _rememberCurrentUser.getUserInfo();
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Obx(() => _fragmentScreens[_indexNumber.value]),
          ),
          bottomNavigationBar: Obx(() => BottomNavigationBar(
                currentIndex: _indexNumber.value,
                onTap: (value) {
                  _indexNumber.value = value;
                },
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white24,
                items: List.generate(_fragmentScreens.length, (index) {
                  var navBtnProperty = _navigationButtonsProperties[index];
                  return BottomNavigationBarItem(
                    backgroundColor: Colors.black,
                    icon: Icon(navBtnProperty['active_icon']),
                    activeIcon: Icon(navBtnProperty["active_cion"]),
                    label: navBtnProperty["label"],
                  );
                }),
              )),
        );
      },
    );
  }
}
