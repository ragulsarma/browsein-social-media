import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_media_clone_flutter/src/common/di/di.dart';
import 'package:social_media_clone_flutter/src/constants/app_strings.dart';
import 'package:social_media_clone_flutter/src/features/home/presentation/bloc/post_cubit.dart';
import 'package:social_media_clone_flutter/src/features/home/presentation/screens/home_page.dart';
import 'package:social_media_clone_flutter/src/features/profile/presentation/screens/profile_page.dart';
import 'package:social_media_clone_flutter/src/features/uploadPost/presentation/bloc/post_upload_cubit.dart';
import 'package:social_media_clone_flutter/src/features/uploadPost/presentation/screens/upload_post_page.dart';
import 'package:social_media_clone_flutter/src/services/connection_change_service.dart';
import 'package:social_media_clone_flutter/src/constants/app_colors.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int currentPage = 0;

  // for tabs animation
  late PageController pageController;

  List<Widget> homeScreenItems = [
    const HomePage(),
    const UploadPostPage(),
    const ProfilePage()
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    ConnectionChangeService.initListen(
        getIt<PostsCubit>(), getIt<PostUploadCubit>());
  }

  void onPageChanged(int page) {
    setState(() {
      currentPage = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          children: homeScreenItems),
      bottomNavigationBar: CupertinoTabBar(
        onTap: navigationTapped,
        currentIndex: currentPage,
        backgroundColor: primaryBgColor,
        height: 70,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: (currentPage == 0) ? secondaryOrangeColor : secondaryColor,
            ),
            label: AppStrings.home,
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle_outline_rounded,
                color:
                    (currentPage == 1) ? secondaryOrangeColor : secondaryColor,
              ),
              label: AppStrings.upload,
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_outlined,
                color:
                    (currentPage == 2) ? secondaryOrangeColor : secondaryColor,
              ),
              label: AppStrings.profile,
              backgroundColor: primaryColor),
        ],
      ),
    );
  }
}
