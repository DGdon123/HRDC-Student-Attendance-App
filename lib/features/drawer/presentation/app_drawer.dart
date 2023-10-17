import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:ym_daa_toce/const/app_colors_const.dart';
import 'package:ym_daa_toce/const/app_dimension.dart';
import 'package:ym_daa_toce/const/app_fonts.dart';
import 'package:ym_daa_toce/const/app_images_const.dart';
import 'package:ym_daa_toce/features/auth/presentation/change_password/views/change_password_screen.dart';
import 'package:ym_daa_toce/features/auth/presentation/login/controllers/auth_controller.dart';
import 'package:ym_daa_toce/features/profile/data/model/profile_model.dart';
import 'package:ym_daa_toce/features/profile/presentation/view_profile/profile_screen.dart';
import 'package:ym_daa_toce/utils/custom_navigation/app_nav.dart';
import 'package:ym_daa_toce/utils/mediaquery_extention.dart';
import '../../../const/app_const.dart';
import '../../assign_class/presentation/views/attendance_section.dart';
import '../../profile/presentation/controllers/get_profile_controller.dart';

class AppDrawer extends ConsumerStatefulWidget {
  const AppDrawer({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppDrawerState();
}

class _AppDrawerState extends ConsumerState<AppDrawer> {
  ProfileModel? proof;
  String? avatarImage;
  @override
  void initState() {
    super.initState();
  }

  void data() {
    final profileData = ref.watch(profileControllerProvider);
    profileData.when(
        loading: () => Center(child: CircularProgressIndicator.adaptive()),
        error: (error, stackTrace) => Text(error.toString()),
        data: (data) {
          proof = data;
          return data;
        });
    if (proof?.gender == "Male") {
      avatarImage = AppImagesConst.kMaleImage;
    } else if (proof?.gender == "Female") {
      avatarImage = AppImagesConst.kUserImage;
    } else {
      avatarImage = AppImagesConst.kMaleImage;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    data();
    return Drawer(
      child: ListView(
        children: [
          authState.when(
              loggedIn: (data) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  alignment: Alignment.center,
                  width: context.widthPct(1),
                  // height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColorConst.kappprimaryColorBlue),
                  child: ListTile(
                    leading: Text(
                      data.userName,
                      style: TextStyle(
                          color: AppColorConst.kappWhiteColor,
                          fontSize: AppDimensions.body_16,
                          fontWeight: AppDimensions.fontNormal,
                          fontFamily: AppFont.kProductsanfont),
                    ),
                  ),
                );
              },
              loggedOut: () => Text("No Data Available".tr()),
              loading: () => LinearProgressIndicator()),

          DrawerItemWidget(
              drawerLabel: "Home".tr(),
              iconData: CupertinoIcons.home,
              onTap: () => Navigator.pop(context)),
          // DrawerItemWidget(
          //     drawerLabel: AppConst.kappBarAttendance,
          //     iconData: CupertinoIcons.book,
          //     onTap: () => Navigator.pop(context)),
          DrawerItemWidget(
              drawerLabel: "Profile".tr(),
              iconData: CupertinoIcons.person,
              onTap: () => normalNav(context, const ProfileScreen())),
          DrawerItemWidget(
              drawerLabel: "Change Password".tr(),
              iconData: CupertinoIcons.lock,
              onTap: () => normalNav(context, const ChangePasswordScreen())),

          Consumer(
            builder: (context, ref, child) => DrawerItemWidget(
                drawerLabel: "Logout".tr(),
                iconData: CupertinoIcons.right_chevron,
                onTap: () async {
                  Navigator.pop(context);
                  await showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          actions: [
                            IconButton(
                              onPressed: () async {
                                ref.invalidate(studentReasonListProvider);
                                ref.invalidate(
                                    absentReasonMissingStudentsProvider);
                                await ref
                                    .watch(authControllerProvider.notifier)
                                    .logout(context);

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration:
                                          const Duration(milliseconds: 800),
                                      content:
                                          Text("Log Out Successfully".tr()),
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: Text("Logout".tr().toUpperCase()),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Text("Cancel".tr().toUpperCase()),
                            ),
                          ],
                          title: Text(
                            "Are you sure to Logout".tr(),
                            style: TextStyle(
                                fontFamily: AppFont.kProductsanfont,
                                fontWeight: FontWeight.normal),
                          ),
                        );
                      });
                  // await ref.read(authControllerProvider.notifier).logout(context);
                }),
          ),
        ],
      ),
    );
  }
}

class DrawerItemWidget extends StatelessWidget {
  const DrawerItemWidget(
      {Key? key,
      required this.drawerLabel,
      required this.iconData,
      required this.onTap})
      : super(key: key);
  final String drawerLabel;
  final IconData iconData;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
        horizontalTitleGap: 4,
        minVerticalPadding: 20,
        leading: Icon(
          iconData,
          color: const Color(0xff183153),
        ),
        title: Text(
          drawerLabel,
          style: const TextStyle(color: Colors.black),
        ),
        onTap: onTap);
  }
}
