import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ym_daa_toce/features/auth/presentation/change_password/views/change_password_screen.dart';
import 'package:ym_daa_toce/features/auth/presentation/login/controllers/auth_controller.dart';
import 'package:ym_daa_toce/features/class_activities/presentation/views/class_activities_screen.dart';
import 'package:ym_daa_toce/features/dashboard/presentation/views/dashboard.dart';
import 'package:ym_daa_toce/features/profile/presentation/view_profile/profile_screen.dart';
import '../../const/app_colors_const.dart';
import '../nav_states/nav_notifier.dart';

class BottomBar extends ConsumerStatefulWidget {
  final int initialIndex; // Add this line

  const BottomBar({Key? key, required this.initialIndex}) : super(key: key);

  @override
  ConsumerState<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends ConsumerState<BottomBar> {
  static final List<Widget> _widgetOptions = [
    const ProfileScreen(),
    Dashboard(),
    ClassActivitiesScreen(),
  ];

  int _index = 0;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex; // Set initial index from the widget parameter
  }

  @override
  Widget build(BuildContext context) {
    var navIndex = ref.watch(navProvider);

    return Scaffold(
      body: Center(
        child: _widgetOptions[navIndex.index],
      ),
      bottomNavigationBar: FloatingNavbar(
        backgroundColor: AppColorConst.kappWhiteColor,
        margin: EdgeInsets.only(bottom: 30),
        selectedBackgroundColor: Color.fromARGB(255, 154, 211, 255),
        unselectedItemColor: CupertinoColors.systemGrey,
        selectedItemColor: AppColorConst.kappprimaryColorBlue,
        onTap: (int val) {
          setState(() {
            _index = val;
            ref.read(navProvider.notifier).onIndexChanged(val);
          });
        },
        currentIndex: _index,
        items: [
          FloatingNavbarItem(icon: Icons.person, title: 'Profile'.tr()),
          FloatingNavbarItem(
              icon: Icons.widgets_outlined, title: 'Dashboard'.tr()),
          FloatingNavbarItem(
              icon: Icons.school_outlined, title: 'Class Activities'.tr()),
        ],
      ),
    );
  }
}
