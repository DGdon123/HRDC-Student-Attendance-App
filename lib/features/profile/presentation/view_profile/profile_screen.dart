import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:ym_daa_toce/const/app_colors_const.dart';
import 'package:ym_daa_toce/const/app_const.dart';
import 'package:ym_daa_toce/const/app_dimension.dart';
import 'package:ym_daa_toce/const/app_fonts.dart';
import 'package:ym_daa_toce/features/assign_class/data/models/assign_class_model/assign_class_model.dart';
import 'package:ym_daa_toce/features/assign_class/presentation/controller/assign_class_controller.dart';
import 'package:ym_daa_toce/features/assign_class/presentation/views/attendance_section.dart';
import 'package:ym_daa_toce/features/auth/presentation/change_password/views/change_password_screen.dart';
import 'package:ym_daa_toce/features/auth/presentation/login/controllers/auth_controller.dart';
import 'package:ym_daa_toce/features/profile/presentation/controllers/get_profile_controller.dart';
import 'package:ym_daa_toce/utils/custom_navigation/app_nav.dart';
import 'package:ym_daa_toce/utils/mediaquery_extention.dart';

import '../../../../const/app_images_const.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<ProfileScreen> {
  Future<void> _refreshData() async {
    // Implement your data refreshing logic here.
    // For example, you can fetch updated data from an API or perform any necessary data syncing.

    // Simulate a delay (remove this in your actual implementation)
    await Future.delayed(Duration(seconds: 2));

    ref.refresh(assignedClassControllerProvider);
    ref.refresh(profileControllerProvider);
  }

  @override
  Widget build(BuildContext context) {
    AssignedClassModel? assignedData;
    var assingedClass = ref.watch(assignedClassControllerProvider);
    final profileData = ref.watch(profileControllerProvider);
    String? avatarImage;
    assingedClass.when(
        data: (data) {
          assignedData = data;
        },
        loading: () => Center(
                child: CircularProgressIndicator(
              color: AppColorConst.kappprimaryColorBlue,
            )),
        error: (error, stackTrace) => Text(error.toString()));
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile".tr()),
        actions: [
          Consumer(
            builder: (context, ref, child) => IconButton(
                icon: const Icon(Icons.logout_outlined),
                tooltip: 'Open shopping cart',
                onPressed: () async {
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
                                    .read(authControllerProvider.notifier)
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
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppColorConst.kappprimaryColorBlue,
        child: profileData.when(
            loading: () => Center(
                    child: CardPageSkeleton(
                  totalLines: 5,
                )),
            error: (error, stackTrace) => Text(error.toString()),
            data: (data) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 18),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height:
                                50, // Adjust the height based on your requirement
                            width:
                                50, // Adjust the width based on your requirement
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemGrey6,
                              borderRadius: BorderRadius.circular(
                                  10), // Make it circular,
                              image: DecorationImage(
                                scale: 10,
                                image: AssetImage(
                                  AppImagesConst.kTeacher,
                                ),
                                fit: BoxFit
                                    .fitWidth, // Try different BoxFit options
                              ),
                            ),
                          ),
                          const SizedBox(
                              width:
                                  10), // Add some spacing between image and text
                          Text(
                            data.name,
                            style: TextStyle(fontSize: AppDimensions.body_18),
                          ),
                        ],
                      ),
                    ).animate().scaleY(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CupertinoListTile(
                        backgroundColor: Colors.white,
                        leading: const Icon(CupertinoIcons.phone),
                        title: Text("Contact".tr(),
                            style: GoogleFonts.poppins(fontSize: 14)),
                        subtitle:
                            Text(data.contact, style: GoogleFonts.poppins()),
                      ),
                    ).animate().scaleY(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CupertinoListTile(
                        backgroundColor: Colors.white,
                        leading: const Icon(CupertinoIcons.envelope),
                        title: Text("Email".tr(),
                            style: GoogleFonts.poppins(fontSize: 14)),
                        subtitle:
                            Text(data.email, style: GoogleFonts.poppins()),
                      ),
                    ).animate().scaleY(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CupertinoListTile(
                        backgroundColor: Colors.white,
                        leading: const Icon(CupertinoIcons.building_2_fill),
                        title: Text("Permanent Address".tr(),
                            style: GoogleFonts.poppins(fontSize: 14)),
                        subtitle: Text(data.permanent_address,
                            style: GoogleFonts.poppins()),
                      ),
                    ).animate().scaleY(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CupertinoListTile(
                        backgroundColor: Colors.white,
                        leading: const Icon(CupertinoIcons.building_2_fill),
                        title: Text("Temporary Address".tr(),
                            style: GoogleFonts.poppins(fontSize: 14)),
                        subtitle: Text(data.temporary_address,
                            style: GoogleFonts.poppins()),
                      ),
                    ).animate().scaleY(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CupertinoListTile(
                        backgroundColor: Colors.white,
                        leading: const Icon(CupertinoIcons.person),
                        title: Text("Gender".tr(),
                            style: GoogleFonts.poppins(fontSize: 14)),
                        subtitle:
                            Text(data.gender, style: GoogleFonts.poppins()),
                      ),
                    ).animate().scaleY(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CupertinoListTile(
                        backgroundColor: Colors.white,
                        leading: const Icon(CupertinoIcons.book),
                        title: Text("School".tr(),
                            style: GoogleFonts.poppins(fontSize: 14)),
                        subtitle:
                            Text(data.school, style: GoogleFonts.poppins()),
                      ),
                    ).animate().scaleY(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CupertinoListTile(
                        backgroundColor: Colors.white,
                        leading: const Icon(Icons.school_outlined),
                        title: Text("Assigned Class".tr(),
                            style: GoogleFonts.poppins(fontSize: 14)),
                        subtitle: Text(
                            "${assignedData?.class_name} ${assignedData?.section}",
                            style: GoogleFonts.poppins()),
                      ),
                    ).animate().scaleY(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.widthPct(0.02),
                          vertical: context.heightPct(0.012)),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: ContinuousRectangleBorder(
                                side: const BorderSide(
                                    width: 0.8,
                                    color: AppColorConst.kappprimaryColorBlue),
                                borderRadius: BorderRadius.circular(8)),
                            backgroundColor: AppColorConst.kappprimaryColorBlue,
                            elevation: 0,
                            fixedSize: Size(context.widthPct(1), 45),
                          ),
                          onPressed: () =>
                              normalNav(context, const ChangePasswordScreen()),
                          child: Text(
                            "Change Password".tr(),
                            style:
                                TextStyle(color: AppColorConst.kappWhiteColor),
                          )),
                    ),
                    SizedBox(
                      height: AppDimensions.paddingDEFAULT,
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
