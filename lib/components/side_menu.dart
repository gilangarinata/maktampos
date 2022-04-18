import 'package:flutter/material.dart';
import 'package:pos_admin/screens/category/category_screen.dart';
import 'package:pos_admin/screens/dashboard/dashboard_screen.dart';
import 'package:pos_admin/screens/product/product_screen.dart';
import 'package:pos_admin/utils/screen_utils.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../constants.dart';
import '../extensions.dart';
import '../responsive.dart';
import 'side_menu_item.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,  this.currentPage
  }) : super(key: key);

  final String? currentPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      padding: EdgeInsets.only(top: kDefaultPadding),
      color: kBgLightColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/user.png",
                    width: 46,
                  ),
                  const Spacer(),
                  // We don't want to show this close button on Desktop mood
                  if (!Responsive.isDesktop(context)) const CloseButton(),
                ],
              ),
              const SizedBox(height: kDefaultPadding * 2),
              // Menu Items
              SideMenuItem(
                press: () {
                  ScreenUtils(context).navigateTo(DashboardScreen(),replaceScreen: true);
                },
                title: "Home",
                iconSrc: "assets/Icons/Inbox.svg",
                isActive: currentPage == "home",
              ),
              SideMenuItem(
                press: () {
                  ScreenUtils(context).navigateTo(ProductScreen(),replaceScreen: true);
                },
                title: "Produk",
                iconSrc: "assets/Icons/Send.svg",
                isActive: currentPage == "product",
              ),
              SideMenuItem(
                press: () {
                  ScreenUtils(context).navigateTo(CategoryScreen(),replaceScreen: true);
                },
                title: "Kategori",
                iconSrc: "assets/Icons/File.svg",
                isActive: currentPage == "category",
              ),
              SideMenuItem(
                press: () {},
                title: "Deleted",
                iconSrc: "assets/Icons/Trash.svg",
                isActive: false,
                showBorder: false,
              ),

              const SizedBox(height: kDefaultPadding * 2),
              // Tags
            ],
          ),
        ),
      ),
    );
  }
}